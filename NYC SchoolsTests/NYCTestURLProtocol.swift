//
//  NYCTestURLProtocol.swift
//  NYC SchoolsTests
//
//  Created by Ravi Theja Karnatakam on 2/5/23.
//

import Foundation
import NYC_Schools

/**
 Override URL protocol to intercept the response.
 */
class NYCTestURLProtocol: URLProtocol {
    static var urlHandler: ((URL) async throws -> (Data, HTTPURLResponse?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = NYCTestURLProtocol.urlHandler else {
            fatalError("NYCTestURLProtocol url handler is unavailable")
        }
        
        guard let requestURL = request.url else {
            client?.urlProtocol(self, didFailWithError: NetworkManagerError.invalidURL(url: ""))
            return
        }
        
        Task {
            var dataResponse: (Data, HTTPURLResponse?)

            do {
                dataResponse = try await handler(requestURL)
                client?.urlProtocol(self, didReceive: dataResponse.1!, cacheStoragePolicy: .notAllowed)
                
                client?.urlProtocol(self, didLoad: dataResponse.0)

                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
    
    override func stopLoading() {
        // no-op for this prototype.
    }
}

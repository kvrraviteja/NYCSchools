//
//  NetworkManager.swift
//  NYC Schools
//
//  Created by Ravi Theja Karnatakam on 2/1/23.
//

import Foundation

/**
 Possible network errors.
 */
enum NetworkManagerError: Error {
    case invalidURL(url : String)
    case failedWithErrorCode(code: Int)
    case failedToDecodeResponse
}

/**
 Loading states of data.
 */
enum DataLoadingState {
    case none
    case loading
    case failedToLoad
    case noDataFound
    case loaded
}

/**
 Protocol to define all required APIs.
 */
protocol NetworkManager {
    func getSchools<T: School>(_ params: [String: String]) async throws -> [T]
}

/**
A NYC network manager, to provide NYC schools data.
 */
struct NYCNetworkManager: NetworkManager {
    let urlProvider = NYCURLProvider()
    
    /**
     Construct the final URL with given params.
     */
    private func constructUrl(_ baseUrl: String,
                            params:[String : String]) -> String {
        var finalUrl = baseUrl
        
        // Caller to ensure valid key, value pair is passed.
        for (key, value) in params {
            finalUrl = (finalUrl + "?" + key + "=" + value)
        }
        return finalUrl
    }

    /**
     Get NYC schools.
     */
    func getSchools<T>(_ params: [String : String]) async throws -> [T] where T : School {
        // Prepare fianl url with baseUrl and query params if any.
        let urlString = constructUrl(urlProvider.baseURL(API.listSchools),
                                   params: params)
        guard let url = URL(string: urlString) else {
            // Debug log message
            print("getSchools API has invalid URL:\(urlString)")
            throw NetworkManagerError.invalidURL(url: urlString)
        }
        
        // Make a request to get data from the prepared url
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Valid the response
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        guard (statusCode == 200) else {
            print("getSchools API failed with error code : \(String(describing: statusCode))")
            throw NetworkManagerError.failedWithErrorCode(code: statusCode ?? 0)
        }
        
        // Return decoded results.
        var schools = [T]()
        do {
            schools = try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("getSchools API failed to decode data : \(error)")
            throw NetworkManagerError.failedToDecodeResponse
        }
        
        return schools
    }
}

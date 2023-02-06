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
public enum NetworkManagerError: Error, Equatable {
    case invalidURL(url : String)
    case failedToFetchData
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
public protocol NetworkManager {
    func getSchools<T: School>(_ params: [String: String]) async throws -> [T]
    func getSATScore<T: SATScore>(_ params: [String : String]) async throws -> [T]
}

/**
A NYC network manager, to provide NYC schools data.
 */
public struct NYCNetworkManager: NetworkManager {
    // Provide a singleton, where caller may choose to use default URLSession.
    static let shared = NYCNetworkManager()

    // The URLSession instance used to fetch data.
    let urlSession: URLSession
    
    // The URL provider instance.
    let urlProvider = NYCRouteProvider()
    
    private init() {
        urlSession = URLSession.shared
    }
    
    public init(_ session: URLSession) {
        urlSession = session
    }
    
    /**
     Construct the final URL with given params.
     */
    func constructUrl(_ baseUrl: String,
                      params:[String : String]) -> String {
        var finalUrl = baseUrl
        
        // Caller to ensure valid key, value pair is passed.
        for (key, value) in params {
            finalUrl = (finalUrl + "?" + key + "=" + value)
        }
        return finalUrl
    }

    func getResponse<T>(for urlString: String) async throws -> [T] where T : Decodable {
        guard let url = URL(string: urlString) else {
            // Logging for debug purposes.
            print("getSchools API has invalid URL:\(urlString)")
            throw NetworkManagerError.invalidURL(url: urlString)
        }
        
        // Make a request to get data from the prepared url
        var dataResponse: (Data, URLResponse)
        do {
            dataResponse = try await urlSession.data(from: url)
        } catch {
            print("\(urlString) API failed to fetch data")
            throw NetworkManagerError.failedToFetchData
        }
        
        // Validate the response. As per API docs, status code 200 is success response.
        // Optionally, handle other status codes.
        // For example, 202 is request in-progress, retry mechanism can be implemented.
        let statusCode = (dataResponse.1 as? HTTPURLResponse)?.statusCode
        guard (statusCode == 200) else {
            print("\(urlString) API failed with error code : \(String(describing: statusCode))")
            throw NetworkManagerError.failedWithErrorCode(code: statusCode ?? 0)
        }
        
        // Return decoded results.
        var decodedResults = [T]()
        do {
            decodedResults = try JSONDecoder().decode([T].self, from: dataResponse.0)
        } catch {
            print("\(urlString) API failed to decode data : \(error)")
            throw NetworkManagerError.failedToDecodeResponse
        }
        
        return decodedResults
    }
    
    /**
     Get NYC schools.
     */
    public func getSchools<T>(_ params: [String : String]) async throws -> [T] where T : School {
        // Prepare fianl url with baseUrl and query params if any.
        let urlString = constructUrl(urlProvider.baseURL(Route.listSchools), params: params)

        return try await getResponse(for: urlString)
    }
    
    /**
     Get SAT Scores, with given parameters.
     */
    public func getSATScore<T>(_ params: [String : String]) async throws -> [T] where T : SATScore {
        // Prepare fianl url, with baseUrl and query params if any.
        let urlString = constructUrl(urlProvider.baseURL(Route.listSATScores), params: params)
        
        return try await getResponse(for: urlString)
    }
}

//
//  APIManager.swift
//  NYC Schools
//
//  Created by Ravi Theja Karnatakam on 2/3/23.
//

import Foundation

/**
 List of APIs supported.
 */
enum API {
    case listSchools
    case listSATScores
}

/**
 A url provider protocol
 */
protocol URLProvider {
    func baseURL(_ type: API) -> String
}

/**
 NYC url provider.
 */
struct NYCURLProvider: URLProvider {
    private let token = "LsemPgGNsGircMaZb1jiCGEBC"
    
    func baseURL(_ type: API) -> String {
        switch type {
        case .listSchools:
            return appendAppToken("https://data.cityofnewyork.us/resource/s3k6-pzi2.json")
        case .listSATScores:
            return appendAppToken("https://data.cityofnewyork.us/resource/f9bf-2cp4.json")
        }
    }
    
    private func appendAppToken(_ baseUrl: String) -> String {
        return baseUrl
        // As per API docs, the app token is required.
        // but looks like the API works with out app token too.
//        return baseUrl + "$$app_token=\(token)"
    }
}

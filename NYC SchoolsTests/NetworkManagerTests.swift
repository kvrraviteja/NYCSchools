//
//  NetworkManagerTests.swift
//  NYC SchoolsTests
//
//  Created by Ravi Theja Karnatakam on 2/5/23.
//

import XCTest
import NYC_Schools

class NetworkManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func successTestData() -> String {
        let jsonString = """
        [
        {
            "dbn": "01M292",
            "school_name": "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES",
            "num_of_sat_test_takers": "29",
            "sat_critical_reading_avg_score": "355",
            "sat_math_avg_score": "404",
            "sat_writing_avg_score": "363"
        }
        ]
        """
        return jsonString
    }

    /**
     Request to parse valid SAT score data and validates the response. `NYCTestURLProtocol` is used to intercept the response.
     */
    func testValidSATScoreResponse() async {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [NYCTestURLProtocol.self]
        let networkManager = NYCNetworkManager(URLSession(configuration: sessionConfig))
        
        // Get test data for success response.
        guard let data = successTestData().data(using: .utf8) else {
            return
        }
        
        // Intercept the request to return stub response.
        NYCTestURLProtocol.urlHandler = { url in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (data, response)
        }
        
        do {
            let scores : [NYCSATScore] = try await networkManager.getSATScore(["dbn":"01M292"])
            XCTAssert(!scores.isEmpty, "Scores can not be empty")
            let score = scores.first
            
            // Similarily, verify all necessary info.
            XCTAssertEqual(score?.schoolName, "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES", "Fix School Name")
        } catch {
            // no-op in this case.
        }
    }
}

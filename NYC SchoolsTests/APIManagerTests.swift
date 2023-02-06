//
//  APIManagerTests.swift
//  NYC SchoolsTests
//
//  Created by Ravi Theja Karnatakam on 2/5/23.
//

import XCTest
import NYC_Schools

class APIManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNYCRoutes() {
        let provider = NYCRouteProvider()
        XCTAssertEqual(provider.baseURL(.listSchools),
                       "https://data.cityofnewyork.us/resource/s3k6-pzi2.json",
                       "Fix listSchools route base url.")
        XCTAssertEqual(provider.baseURL(.listSATScores),
                       "https://data.cityofnewyork.us/resource/f9bf-2cp4.json",
                       "Fix listSATScores route base url.")
    }
}

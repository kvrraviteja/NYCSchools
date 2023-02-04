//
//  School.swift
//  NYC Schools
//
//  Created by Ravi Theja Karnatakam on 2/1/23.
//

import Foundation

/**
 A school model object to display school data.
 */
protocol School: Decodable {
    var uID: String { get }
    var name: String { get }
    var description: String { get }
    var city: String { get }
    var zip: String { get }
    var address: String { get }
    var availableGrades: String { get }
}

/**
 A NYC school model object. 
 */
public struct NYCSchool: School {
    let school_name: String
    let overview_paragraph: String
    let dbn: String
    var city: String
    var zip: String
    var location: String
    var finalgrades: String?

    var uID: String {
        return dbn
    }
    
    var name: String {
        return school_name
    }
    
    var description: String {
        return overview_paragraph
    }
    
    var availableGrades: String {
        guard let grades = finalgrades else { return "Grades info not available." }
        return "Offered grades: \(grades)"
    }
    
    var address: String {
        if (location.split(separator: "(").isEmpty) {
            return location
        } else {
            return String(location.split(separator: "(")[0])
        }
    }
}

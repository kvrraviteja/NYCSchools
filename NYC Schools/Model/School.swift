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
public protocol School: Decodable {
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
    public var city: String
    public var zip: String
    var location: String
    var finalgrades: String?

    public var uID: String {
        return dbn
    }
    
    public var name: String {
        return school_name
    }
    
    public var description: String {
        return overview_paragraph
    }
    
    // The custom logic should be done at the view model level.
    public var availableGrades: String {
        guard let grades = finalgrades else { return "Grades info not available." }
        return "Grades offered: \(grades)"
    }
    
    public var address: String {
        if (location.split(separator: "(").isEmpty) {
            return location
        } else {
            return String(location.split(separator: "(")[0])
        }
    }
}


public protocol SATScore: Decodable {
    var uID: String { get }
    var schoolName: String { get }
    var studentsCount: String { get }
    var readingScore: String { get }
    var mathScore: String { get }
    var writingScore: String { get }
}

public struct NYCSATScore: SATScore {
    let school_name: String
    let num_of_sat_test_takers: String
    let dbn: String
    let sat_critical_reading_avg_score: String
    let sat_math_avg_score: String
    let sat_writing_avg_score: String

    
    public var uID: String {
        return dbn
    }
    
    public var schoolName: String {
        return school_name
    }
    
    public var studentsCount: String {
        return num_of_sat_test_takers
    }
    
    public var readingScore: String {
        return sat_critical_reading_avg_score
    }
    
    public var mathScore: String {
        return sat_math_avg_score
    }
    
    public var writingScore: String {
        return sat_writing_avg_score
    }
}

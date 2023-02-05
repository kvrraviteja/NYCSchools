//
//  SchoolDetailsViewModel.swift
//  NYC Schools
//
//  Created by Ravi Theja Karnatakam on 2/4/23.
//

import Foundation

class NYCSchoolDetailsViewModel {
    var dataLoadingState = DataLoadingState.none
    var scores = [NYCSATScore]()

    func fetchDetails(_ school: School) async {
        
        do {
            let fetchedScores : [NYCSATScore] = try await NYCNetworkManager.shared.getSATScore(["dbn": school.uID])
            
            scores = fetchedScores
            dataLoadingState = fetchedScores.isEmpty ? .noDataFound : .loaded
        } catch {
            dataLoadingState = .failedToLoad
        }
    }
}

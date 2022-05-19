//
//  RottenViewModel.swift
//  Rotten games
//
//  Created by AMStudent on 11/12/21.
//

import Foundation
import UIKit
import Combine


class RottenViewModel: ObservableObject {

// gets data
    
@Published var review = [ReviewData]()

let apiURL = "https://firebasestorage.googleapis.com/v0/b/rotten-games.appspot.com/o/rotten-games-default-rtdb-export%20(2).json?alt=media&token=e11d2af0-1576-412e-9513-e11ce8bd3954"

init() {
    fetchReviewData()
}

// cleans up data for code to understand
    
func fetchReviewData() {
    guard let url = URL(string: apiURL) else { return }
    
    let session = URLSession.shared
    let task = session.dataTask(with: url) { (data, response, error) in
        guard let cleanData = data?.parseData(removeString: "null,") else { return }
                   
        DispatchQueue.main.async {
            do {
                let review = try
                JSONDecoder().decode([ReviewData].self, from: cleanData)
                self.review = review
            }catch{
                print("errormsg:", error)
            }
        }
    }
    task.resume()
}

// change the background color plan for each dev
    
func detectBackgroundColor(forDevs devs: String) -> UIColor {
    switch devs {
    case "Activision": return .systemGray6
    case "Bethesda": return .systemOrange
    case "Ubisoft": return .systemBlue
    case "343 Industries": return .systemGreen
    default: return .systemGray
        }
    }
}

//  allows for program to save data for flags and indvidual review

class RottenTools: ObservableObject {
    @Published var microReview: Double
    @Published var flagedGamespot: Bool
    @Published var updateGamespot: Bool
    @Published var flagedIGN: Bool
    @Published var updateIGN: Bool
    @Published var flagedMetacritic: Bool
    @Published var updateMetacritic: Bool
    @Published var flagedPCGamer: Bool
    @Published var updatePCGamer: Bool
    init(
        microReview: Double = 5,
        flagedGameSpot: Bool = true,
        updateGameSpot: Bool = true,
        flagedIGN: Bool = true,
        updateIGN: Bool = true,
        flagedMetacritic: Bool = true,
        updateMetacritic: Bool = true,
        flagedPCGamer: Bool = true,
        updatePCGamer: Bool = true
    ) {
        self.microReview = microReview
        self.flagedGamespot = flagedGameSpot
        self.updateGamespot = updateGameSpot
        self.flagedIGN = flagedIGN
        self.updateIGN = updateIGN
        self.flagedMetacritic = flagedMetacritic
        self.updateMetacritic = updateMetacritic
        self.flagedPCGamer = flagedPCGamer
        self.updatePCGamer = updatePCGamer
    }
}

extension Data {
    func parseData(removeString string: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?.replacingOccurrences(of: string, with: "")
        guard let data = parsedDataString?.data(using: .utf8) else { return nil }
        
        return data
    }
}

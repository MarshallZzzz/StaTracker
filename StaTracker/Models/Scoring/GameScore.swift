//
//  GameScore.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import Foundation

// Enum to represent the state of the game at 40-40 (deuce)
// A struct to manage the score
struct GameScore: Codable {
    let id = UUID()
    let format: MatchFormat?=nil
    let scoringType: ScoringType
    
    var currPlayerPoints: Int
    var oppPlayerPoints: Int

    var displayScore: String {
        let scoreMap: [Int: String] = [0: "0", 1: "15", 2: "30", 3: "40"]
        
        let p1Score = scoreMap[currPlayerPoints] ?? ""
        let p2Score = scoreMap[oppPlayerPoints] ?? ""
        
        // Handle "No-Ad" rule at 40-40 (Deuce)
        if format?.scoringType == .noAd && currPlayerPoints >= 3 && oppPlayerPoints >= 3 {
            return "Deuce - Next point wins"
        }
        
        // Handle "Ad" scoring
        if format?.scoringType == .ad {
            if currPlayerPoints >= 3 && oppPlayerPoints >= 3 {
                if currPlayerPoints > oppPlayerPoints + 1 {
                    return "Game P1" // P1 wins by two
                } else if oppPlayerPoints > currPlayerPoints + 1 {
                    return "Game P2" // P2 wins by two
                } else if currPlayerPoints > oppPlayerPoints {
                    return "Ad-in"
                } else if oppPlayerPoints > currPlayerPoints {
                    return "Ad-out"
                } else {
                    return "Deuce" // The next point can create an advantage
                }
            }
        }
        
        // Handle standard scoring
        if currPlayerPoints > 3 || oppPlayerPoints > 3 {
            return "Game Over"
        }
        return "\(p1Score) - \(p2Score)"
    }
}

extension GameScore{
    mutating func currPlayerScored(){
        currPlayerPoints += 1
    }
    mutating func oppPlayerScored(){
        oppPlayerPoints += 1
    }
    
    
    
}

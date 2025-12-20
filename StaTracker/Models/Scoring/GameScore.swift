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
    
    var ads: ScoringType
    var currPlayerPoints: Int
    var oppPlayerPoints: Int
    
    init(gameType: ScoringType){
        self.ads = gameType
        self.currPlayerPoints = 0
        self.oppPlayerPoints = 0
    }

    func isGameOver() -> Bool {

        if ads == .noAd{
            // At deuce → next point wins
            return currPlayerPoints >= 4 || oppPlayerPoints >= 4
        }
        else{
            if currPlayerPoints >= 4 || oppPlayerPoints >= 4 {
                return abs(currPlayerPoints - oppPlayerPoints) >= 2
            }
            // Win by 2, but games essentially end at “Game Over”
            return false
        }
        
    }

    func displayGameScore() -> String {
        let scoreMap: [Int: String] = [
            0: "0",
            1: "15",
            2: "30",
            3: "40"
        ]
        
        let difference = currPlayerPoints - oppPlayerPoints
        
        if ads == .ad
        && currPlayerPoints >= 3
        && oppPlayerPoints >= 3
        && abs(difference) <= 2
        {
            if difference == 0{
                return "Deuce"
            } else if difference > 0{
                return "Ad - In"
            } else{
                return "Ad - Out"
            }
        }
        
        let currPoints = scoreMap[currPlayerPoints] ?? "0"
        let oppPoints = scoreMap[oppPlayerPoints] ?? "0"
        return "\(currPoints)-\(oppPoints)"
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

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
}

extension GameScore{
    mutating func currPlayerScored(){
        currPlayerPoints += 1
    }
    mutating func oppPlayerScored(){
        oppPlayerPoints += 1
    }    
}

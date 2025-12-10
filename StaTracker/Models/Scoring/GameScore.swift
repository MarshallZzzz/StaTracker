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
    let format: MatchFormat
    
    var server: ServingPlayer
    var currPlayerPoints: Int
    var oppPlayerPoints: Int

}

extension GameScore{
    mutating func currPlayerScored(){
        currPlayerPoints += 1
    }
    mutating func oppPlayerScored(){
        oppPlayerPoints += 1
    }
    
    
    
}

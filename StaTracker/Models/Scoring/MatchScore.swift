//
//  MatchScore.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//


//match concept map
//Holds the set
//checks if player has enough sets to win based on the match setting
//sets the winner

import Foundation


struct MatchScore: Codable {
    var sets: [SetScore] = []
    
    let matchFormat: MatchFormat
    
    init(format: MatchFormat){
        self.matchFormat = format
        self.sets.append(SetScore(format: matchFormat))
    }

    func isMatchOver() -> Bool {
        let setsToWin = matchFormat.setsToWin
        
        if sets.filter({$0.winner == .currPlayer}).count >= setsToWin || sets.filter({$0.winner == .oppPlayer}).count >= setsToWin{
            return true
        }
        return false
    }
    
    func getMatchWinner() -> Winner? {
        let setsToWin = matchFormat.setsToWin
        let player1Sets = sets.filter {$0.winner == .currPlayer}.count
        let player2Sets = sets.filter {$0.winner == .oppPlayer}.count
        
        if player1Sets >= setsToWin {
            return .currPlayer
        } else if player2Sets >= setsToWin {
            return .oppPlayer
        }
        
        return nil
    }
    
}

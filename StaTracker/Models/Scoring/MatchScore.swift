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
    var currSetNum: Int = 0
//    var currSet: SetScore? = nil
    
    let matchFormat: MatchFormat
    
    init(format: MatchFormat){
        self.matchFormat = format
        self.sets.append(SetScore(format: matchFormat))
    }
    
    func isMatchOver() -> Bool {
        let setsToWin = matchFormat.setsToWin
        
        if sets.filter({$0.winner == .curr}).count >= setsToWin || sets.filter({$0.winner == .opp}).count >= setsToWin{
            return true
        }
        return false
    }
    
    func getMatchWinner() -> Player? {
        let setsToWin = matchFormat.setsToWin
        let player1Sets = sets.filter {$0.winner == .curr}.count
        let player2Sets = sets.filter {$0.winner == .opp}.count
        
        if player1Sets >= setsToWin {
            return .curr
        } else if player2Sets >= setsToWin {
            return .opp
        }
        
        return nil
    }
    
    mutating func createNewSet(format: MatchFormat){
        //create set
        //create game
        //append game to set
        
        var newSet = SetScore(format: format)
        var newGame = GameScore(gameType: format.scoringType)
        
        newSet.games.append(newGame)
        self.sets.append(newSet)
    }

}

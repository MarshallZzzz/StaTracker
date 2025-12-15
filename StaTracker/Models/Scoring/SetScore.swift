//
//  SetScore.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.

import Foundation

struct SetScore: Codable {
    let id = UUID()
    let format: MatchFormat
    var games: [GameScore] = []
    var currPlayerGames: Int = 0
    var oppPlayerGames: Int = 0
    var winner: Player? = nil
    
    init(format: MatchFormat){
        self.format = format
        self.currPlayerGames = 0
        self.oppPlayerGames = 0
        self.games.append(GameScore(gameType: format.scoringType))
    }
    
    // Optional property to store tiebreak points if the set goes to a tiebreak
    // This only has a value when a tiebreak is active or completed.
    var tieBreakScore: tieBreakScore? = nil

    // You can add a computed property to check if the set is won
    // The exact logic depends heavily on the 'MatchFormat' rules.
    mutating func isSetComplete(format: MatchFormat) -> Bool {
        let p1 = currPlayerGames
        let p2 = oppPlayerGames
        let gamesToWin = format.gamesPerSetToWin
        let tiebreakAt = format.playTieBreakAt
        
        //standard set checks
        if (p1 >= gamesToWin || p2 >= gamesToWin){
            if (p1 == tiebreakAt && p2 == tiebreakAt){
                //add tiebreak
                return false
            }
            else {
                return true
            }
        }

        return false
    }
    
}
extension SetScore {
    mutating func currGameWon(){
        currPlayerGames += 1
    }
    mutating func oppGameWon(){
        oppPlayerGames += 1
    }
    
    mutating func currPlayerWon(){
        winner = .curr
    }
    mutating func oppPlayerWon(){
        winner = .opp
    }
}

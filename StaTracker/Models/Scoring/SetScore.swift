//
//  SetScore.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.

import Foundation

struct SetScore: Codable {
    //basic setup
    let id = UUID()
    let format: MatchFormat
    var games: [GameScore] = []
    
    //internal initialization
    var currPlayerGames: Int = 0
    var oppPlayerGames: Int = 0
    
    //completion variables
    var winner: Player? = nil
    var tieBreak: TieBreakScore? = nil
//    var tieBreakWinner: Player? = nil
    
    init(format: MatchFormat){
        self.format = format
        self.currPlayerGames = 0
        self.oppPlayerGames = 0
        self.games.append(GameScore(gameType: format.scoringType))
    }

    // Checks to see if set is complete based on the given format
    func isSetComplete() -> Bool {
        let gamesToWin = format.gamesPerSetToWin
        let tiebreakAt = format.playTieBreakAt
        
        //standard set checks
        if (currPlayerGames == gamesToWin + 1 && oppPlayerGames == gamesToWin) // check tieBreak score when curr player win
        || (oppPlayerGames == gamesToWin + 1 && currPlayerGames == gamesToWin) // check tieBreak score when opp player win
        || (currPlayerGames >= gamesToWin && currPlayerGames >= oppPlayerGames + 2) // check win by two conditions once curr reaches gamesToWin
        || (oppPlayerGames >= gamesToWin && oppPlayerGames >= currPlayerGames + 2) // check win by two condition once opp reaches gamesToWin
        {
            return true
        }
        return false
    }

    
    mutating func setWinner(_ winner: Player){
        self.winner = winner
    }
    
    func isSetInTieBreak() -> Bool {
        return (currPlayerGames == format.playTieBreakAt && oppPlayerGames == format.playTieBreakAt)
    }
    
}
extension SetScore {
    mutating func currGameWon(){
        currPlayerGames += 1
    }
    mutating func oppGameWon(){
        oppPlayerGames += 1
    }
}

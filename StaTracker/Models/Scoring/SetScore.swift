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
    var winner: Winner? = nil
    
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
        
        // Check if tiebreak points decided the set
        if let tiebreak = tieBreakScore {
            let pointsToWin = (format.finalSetFormat == .matchTiebreak) ? 10 : 7
            // Check tiebreak win condition (win by 2 points)
            if (tiebreak.p1 >= pointsToWin || tiebreak.p2 >= pointsToWin) && abs(tiebreak.p1 - tiebreak.p2) >= 2 {
                self.winner = (tiebreak.p1 > tiebreak.p2) ? .currPlayer : .oppPlayer
                return true
            }
        }
        
        // Check standard set win condition (win by 2 games)
        let standardWin = (p1 >= gamesToWin || p2 >= gamesToWin) && abs(p1 - p2) >= 2
        
        // Check if the score is exactly at the tiebreak threshold (e.g., 6-6)
        let isAtTiebreakScore = p1 == tiebreakAt && p2 == tiebreakAt
        
        if standardWin {
            self.winner = (p1 > p2) ? .currPlayer : .oppPlayer
            return true
        } else if isAtTiebreakScore && tieBreakScore != nil {
            // Set is complete via tiebreak logic handled above
            self.winner = (p1 > p2) ? .currPlayer : .oppPlayer
            return true
        }
        
        return false
    }
}

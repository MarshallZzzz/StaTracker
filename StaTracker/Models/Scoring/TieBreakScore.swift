//
//  TieBreakScore.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/15/25.
//

import Foundation

struct TieBreakScore: Codable {
    let id = UUID()
    
    var winAt: Int
    var currPlayerPoints: Int
    var oppPlayerPoints: Int
    var winner: Player? = nil
    
    init(winAt: Int){
        self.winAt = winAt
        self.currPlayerPoints = 0
        self.oppPlayerPoints = 0
    }
    
    //check if tie break is over with standard: 7 and super: 10
    func isTieBreakOver() -> Bool {
        if (currPlayerPoints >= winAt || oppPlayerPoints >= winAt){
            return abs(currPlayerPoints - oppPlayerPoints) >= 2
        }
        return false
    }
    
    //get the player with more points ... MUST COME AFTER isTieBreakOver()
    func getWinner() -> Player? {
        return currPlayerPoints > oppPlayerPoints ? .curr : .opp
    }
}

extension TieBreakScore{
    mutating func currPlayerScored(){
        currPlayerPoints += 1
    }
    
    mutating func oppPlayerScored(){
        oppPlayerPoints += 1
    }
}

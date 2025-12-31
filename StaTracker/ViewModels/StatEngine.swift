//
//  StatEngine.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/20/25.
//

import Foundation

struct StatEngine {
    var points: [Point]
    
    init(points: [Point]) {
        self.points = points
    }
    
    
    
/* <----------------- Serve -----------------> */
    // Total # of first and Second serves
    var totalFirstServes: Int {
        return points.filter{$0.firstServe != nil && $0.server == .curr}.count
    }
    
    var totalSecondServes: Int {
        return points.filter{$0.secondServe != nil && $0.secondServe?.made != nil && $0.server == .curr}.count
    }
    
    
    // # of made first and second serves
    var totalMadeFirstServe: Int {
        return points.filter{$0.firstServe?.made == .made}.count
    }
    
    var totalMadeSecondServe: Int {
        return points.filter{$0.secondServe?.made == .made}.count
    }
    
    // Serve Percentages
    var firstServePercentage: Double{
        return Double(totalMadeFirstServe) / Double(totalFirstServes)
    }
    var secondServePercentage: Double{
        return Double(totalMadeSecondServe) / Double(totalSecondServes)
    }
    
    //Aces
    var totalAces: Int {
        return points.filter{$0.firstServe?.outcome == .ace || $0.secondServe?.outcome == .ace}.count
    }
    
    //# of double faults
    var doubleFaults: Int {
        return points.filter{$0.firstServe?.made == .miss && $0.secondServe?.made == .miss}.count
    }
    
    // made -> flat
        //flat -> T
        //flat -> body
        //flat -> wide
    
    // made -> slice
        // T , body, wide
    // made -> spin
        // T , body, wide
    // made -> kick
        // T , body, wide
    
    
    //Break points
//    var totalBreakPointsFaced: Int {
//        points.filter{$0.gameScore?.currPlayerPoints < 3 && $0.gamesScore?.oppPlayerPoints == 3}.count
//    }
/* <----------------- Receive -----------------> */
    
    //total first return points played
    var totalFirstReturns: Int {
        return points.filter{$0.firstReceive?.made == .made}.count
    }
    
    //total second return points played
    var totalSecondReturns: Int {
        return points.filter{$0.secondReceive?.made == .made}.count
    }
    
    //first serve return points won
    var firstServeReturnPointsWon: Int {
        return points.filter{$0.firstReceive?.made == .made && $0.playerWon == .curr}.count
    }
    
    //second serve return points won
    var secondServeReturnPointsWon: Int {
        return points.filter{$0.secondReceive?.made == .made && $0.playerWon == .curr}.count
    }
    
    //percentage of receive made
    var firstReceiveMadePercentage: Double {
        return Double(firstServeReturnPointsWon) / Double(totalFirstReturns)
    }
    var secondReceiveMadePercentage: Double {
        return Double(secondServeReturnPointsWon) / Double(totalSecondReturns)
    }
    
    //return points won
    var totalReturnPointsWon: Int {
        return points.filter{$0.firstReceive != nil && $0.playerWon == .curr}.count
    }
    
    /* <----------------- Rally -----------------> */
    var totalRallyPoints: Int {
        return points.count
    }
    
    var totalRallyPointsWon: Int {
        return points.filter{$0.playerWon == .curr}.count
    }
    
    var rallyWonPercentage: Double{
        return Double(totalRallyPointsWon)/Double(totalRallyPoints)
    }
    
}

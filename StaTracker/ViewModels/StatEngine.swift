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
    
    // MARK: - Helper Computed Properties
    
    private var servicePoints: [Point] {
        points.filter { $0.server == .curr }
    }
    
    private var returnPoints: [Point] {
        points.filter { $0.server == .opp }
    }
    
    private var rallyPoints: [Point] {
        points.filter { $0.rally != nil }
    }
    
    // MARK: - Serve Statistics
    
    var serveStats: ServeStats {
        let firstServeMade = servicePoints.filter { $0.firstServe?.made == .made }
        let secondServeMade = servicePoints.filter { $0.secondServe != nil  && $0.secondServe?.made == .made }
        let firstServeTotal = servicePoints.filter { $0.firstServe != nil }
        let secondServeTotal = servicePoints.filter { $0.secondServe != nil }
        
        return ServeStats(
            // Counts
            totalServes: firstServeTotal.count + secondServeTotal.count,
            firstServesMade: firstServeMade.count,
            secondServesMade: secondServeMade.count,
            firstServesTotal: firstServeTotal.count,
            secondServesTotal: secondServeTotal.count,
            aces: servicePoints.filter { $0.firstServe?.outcome == .ace || $0.secondServe?.outcome == .ace }.count,
            doubleFaults: servicePoints.filter { $0.firstServe?.made == .miss && $0.secondServe?.made == .miss }.count,
            
            // Win rates
            servicePointsWonRate: percentage(servicePoints.filter { $0.playerWon == .curr }.count, of: servicePoints.count),
            firstServePointsWonRate: percentage(firstServeMade.filter { $0.playerWon == .curr }.count, of: firstServeMade.count),
            secondServePointsWonRate: percentage(secondServeMade.filter { $0.playerWon == .curr }.count, of: secondServeMade.count),
            
            // Percentages
            firstServeInRate: percentage(firstServeMade.count, of: firstServeTotal.count),
            secondServeInRate: percentage(secondServeMade.count, of: secondServeTotal.count),
            
            // First serve types
            firstServeKick: percentage(firstServeMade.filter { $0.firstServe?.type == .kick }.count, of: firstServeMade.count),
            firstServeSpin: percentage(firstServeMade.filter { $0.firstServe?.type == .spin }.count, of: firstServeMade.count),
            firstServeSlice: percentage(firstServeMade.filter { $0.firstServe?.type == .slice }.count, of: firstServeMade.count),
            firstServeFlat: percentage(firstServeMade.filter { $0.firstServe?.type == .flat }.count, of: firstServeMade.count),
            
            // Second serve types
            secondServeKick: percentage(secondServeMade.filter { $0.secondServe != nil && $0.secondServe?.type == .kick }.count, of: secondServeMade.count),
            secondServeSpin: percentage(secondServeMade.filter { $0.secondServe != nil && $0.secondServe?.type == .spin }.count, of: secondServeMade.count),
            secondServeSlice: percentage(secondServeMade.filter { $0.secondServe != nil && $0.secondServe?.type == .slice }.count, of: secondServeMade.count),
            secondServeFlat: percentage(secondServeMade.filter { $0.secondServe != nil && $0.secondServe?.type == .flat }.count, of: secondServeMade.count)
        )
    }
    
    // MARK: - Return Statistics
    
    var returnStats: ReturnStats {
        let firstReturnTotal = returnPoints.filter { $0.firstReceive?.made != .oppMiss }
        let secondReturnTotal = returnPoints.filter { $0.secondReceive != nil && $0.secondReceive?.made != .oppMiss }
        let firstReturnMade = returnPoints.filter { $0.firstReceive?.made == .made }
        let secondReturnMade = returnPoints.filter { $0.secondReceive != nil && $0.secondReceive?.made == .made }
        let firstReturnMissed = returnPoints.filter { $0.firstReceive?.made == .miss }
        let secondReturnMissed = returnPoints.filter { $0.secondReceive != nil && $0.secondReceive?.made == .miss }
        
        return ReturnStats(
            // Counts
            firstReturnsTotal: firstReturnTotal.count,
            secondReturnsTotal: secondReturnTotal.count,
            firstReturnsMade: firstReturnMade.count,
            secondReturnsMade: secondReturnMade.count,
            breakPointOpportunities: returnPoints.filter { point in
                guard let score = point.gameScore else { return false }
                return score.currPlayerPoints >= 3 && score.currPlayerPoints > score.oppPlayerPoints
            }.count,
            
            // Win rates
            firstReturnPointsWonRate: percentage(firstReturnMade.filter { $0.playerWon == .curr }.count, of: firstReturnMade.count),
            secondReturnPointsWonRate: percentage(secondReturnMade.filter { $0.secondReceive != nil && $0.playerWon == .curr }.count, of: secondReturnMade.count),
            returnPointsWonRate: percentage(returnPoints.filter { $0.playerWon == .curr }.count, of: returnPoints.count),
            
            // Made rates
            firstReturnMadeRate: percentage(firstReturnMade.count, of: firstReturnTotal.count),
            secondReturnMadeRate: percentage(secondReturnMade.count, of: secondReturnTotal.count),
            
            // First return miss distribution
            firstReturnNetRate: percentage(firstReturnMissed.filter { $0.firstReceive?.miss == .net }.count, of: firstReturnMissed.count),
            firstReturnLongRate: percentage(firstReturnMissed.filter { $0.firstReceive?.miss == .long }.count, of: firstReturnMissed.count),
            firstReturnWideRate: percentage(firstReturnMissed.filter { $0.firstReceive?.miss == .wide }.count, of: firstReturnMissed.count),
            
            // Second return miss distribution
            secondReturnNetRate: percentage(secondReturnMissed.filter { $0.secondReceive != nil && $0.secondReceive?.miss == .net }.count, of: secondReturnMissed.count),
            secondReturnLongRate: percentage(secondReturnMissed.filter { $0.secondReceive != nil && $0.secondReceive?.miss == .long }.count, of: secondReturnMissed.count),
            secondReturnWideRate: percentage(secondReturnMissed.filter { $0.secondReceive != nil && $0.secondReceive?.miss == .wide }.count, of: secondReturnMissed.count)
        )
    }
    
    // MARK: - Rally Statistics
    
    var rallyStats: RallyStats {
        let rallyWins = rallyPoints.filter { $0.playerWon == .curr }
        let rallyLose = rallyPoints.filter { $0.playerWon == .opp}
        
        return RallyStats(
            // Counts
            totalRallyPoints: rallyPoints.count,
            rallyPointsWon: rallyWins.count,
            
            // Win rate
            rallyWinRate: percentage(rallyWins.count, of: rallyPoints.count),
            
            // Outcome types
            winnersRate: percentage(rallyWins.filter { $0.rally?.outcomeType == .winner }.count, of: rallyWins.count),
            forcedErrorsRate: percentage(rallyWins.filter { $0.rally?.outcomeType == .forcedError }.count, of: rallyWins.count),
            opponentUnforcedRate: percentage(rallyWins.filter { $0.rally?.outcomeType == .unforcedError }.count, of: rallyWins.count),
            
            // Position distribution
            baselineRate: percentage(rallyWins.filter { $0.rally?.playerPosition == .baseline }.count, of: rallyWins.count),
            noMansLandRate: percentage(rallyWins.filter { $0.rally?.playerPosition == .noMansLand }.count, of: rallyWins.count),
            netRate: percentage(rallyWins.filter { $0.rally?.playerPosition == .net }.count, of: rallyWins.count),
            
            //Lose by Unforced Errors
            unforcedRate: percentage(rallyLose.filter { $0.rally?.outcomeType == .unforcedError}.count, of: rallyLose.count)
        )
    }
    
    // MARK: - Helper Functions
    
    private func percentage(_ numerator: Int, of denominator: Int) -> Double {
        guard denominator > 0 else { return 0.0 }
        return Double(numerator) / Double(denominator)
    }
}

// MARK: - Statistics Structures

struct ServeStats {
    // Counts
    let totalServes: Int
    let firstServesMade: Int
    let secondServesMade: Int
    let firstServesTotal: Int
    let secondServesTotal: Int
    let aces: Int
    let doubleFaults: Int
    
    // Win rates
    let servicePointsWonRate: Double
    let firstServePointsWonRate: Double
    let secondServePointsWonRate: Double
    
    // In percentages
    let firstServeInRate: Double
    let secondServeInRate: Double
    
    // First serve types
    let firstServeKick: Double
    let firstServeSpin: Double
    let firstServeSlice: Double
    let firstServeFlat: Double
    
    // Second serve types
    let secondServeKick: Double
    let secondServeSpin: Double
    let secondServeSlice: Double
    let secondServeFlat: Double
}

struct ReturnStats {
    // Counts
    let firstReturnsTotal: Int
    let secondReturnsTotal: Int
    let firstReturnsMade: Int
    let secondReturnsMade: Int
    let breakPointOpportunities: Int
    
    // Win rates
    let firstReturnPointsWonRate: Double
    let secondReturnPointsWonRate: Double
    let returnPointsWonRate: Double
    
    // Made rates
    let firstReturnMadeRate: Double
    let secondReturnMadeRate: Double
    
    // First return miss distribution
    let firstReturnNetRate: Double
    let firstReturnLongRate: Double
    let firstReturnWideRate: Double
    
    // Second return miss distribution
    let secondReturnNetRate: Double
    let secondReturnLongRate: Double
    let secondReturnWideRate: Double
}

struct RallyStats {
    // Counts
    let totalRallyPoints: Int
    let rallyPointsWon: Int
    
    // Win rate
    let rallyWinRate: Double
    
    // Outcome types
    let winnersRate: Double
    let forcedErrorsRate: Double
    let opponentUnforcedRate: Double
    
    // Position distribution
    let baselineRate: Double
    let noMansLandRate: Double
    let netRate: Double
    
    // Loses
    let unforcedRate: Double
}

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
        let secondServeMade = servicePoints.filter { $0.secondServe?.made == .made }
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
        // 1. Group by wins and losses
        
        
        var totalRallyPoints = 0
        var rallyPointsWon = 0
        var rallyPointsLost = 0
//
//        let rallyWins = rallyPoints.filter { $0.playerWon == .curr }
//        let rallyLose = rallyPoints.filter { $0.playerWon == .opp}

        typealias ShotCountMap = [OutcomeType: [PlayerShotSide: [ShotType: Int]]]
//        typealias MissCountMap = [OutcomeType: [PlayerShotSide: [MissedPosition: Int]]]
        typealias OutcomeTotals = [OutcomeType: [PlayerShotSide: Int]]
    
        

        //WINNING SHOT TYPES AND TOTALS
        var outcomeTotals: OutcomeTotals = [
            .winner: [.forehand: 0, .backhand: 0],
            .forcedError: [.forehand: 0, .backhand: 0],
            .unforcedError: [.forehand: 0, .backhand: 0]
        ]

        var shotCounts: ShotCountMap = [
            .winner: [.forehand: [:], .backhand: [:]],
            .forcedError: [.forehand: [:], .backhand: [:]],
            .unforcedError: [.forehand: [:], .backhand: [:]]
        ]
        
        
        //LOSING SHOT TYPES AND TOTALS
        var lostOutcomeTotals: [OutcomeType: Int] =
        [
            .winner: 0,
            .forcedError: 0,
            .unforcedError: 0
        ]
        
        var missedTotals: [MissedPosition: Int] =
        [
            .net: 0,
            .long: 0,
            .wide: 0
        ]

        var lostUnforcedSideCount: [PlayerShotSide: [MissedPosition: Int]] =
        [
            .forehand: [
                    .net: 0,
                    .long: 0,
                    .wide: 0
                ],
                .backhand: [
                    .net: 0,
                    .long: 0,
                    .wide: 0
                ]
        ]
        
        var baselineWins = 0
        var noMansLandWins = 0
        var netWins = 0
        
//        var baselineLost = 0
//        var noMansLandLost = 0
//        var netLost = 0
//        
        for point in rallyPoints {
            guard let rally = point.rally,
                  let outcome = rally.outcomeType,
                  let side = rally.playerShotSide,
                  let shot = rally.type else { continue }

            totalRallyPoints += 1

            if point.playerWon == .curr {
                rallyPointsWon += 1

                if let position = rally.playerPosition {
                    switch position {
                    case .baseline: baselineWins += 1
                    case .noMansLand: noMansLandWins += 1
                    case .net: netWins += 1
                    }
                }
                outcomeTotals[outcome]?[side, default: 0] += 1
                shotCounts[outcome]?[side]?[shot, default: 0] += 1
                
            } else {
                rallyPointsLost += 1
                guard let miss = rally.missPosition else {continue}
                
                lostOutcomeTotals[outcome]? += 1
                missedTotals[miss]? += 1
                if outcome == .unforcedError {
                    
                    lostUnforcedSideCount[side]?[miss, default: 0] += 1
                }
            }
        }
        
        // 3. Helper to get percentages for any category
        func rate(_ count: Int, _ total: Int) -> Double {
            percentage(count, of: total)
        }

        func getRate(_ outcome: OutcomeType, _ side: PlayerShotSide, _ shot: ShotType) -> Double {
            let count = shotCounts[outcome]?[side]?[shot] ?? 0
            let total = outcomeTotals[outcome]?[side] ?? 0
            return rate(count, total)
        }

        //collecting total
        let winnersTotal = outcomeTotals[.winner]!.values.reduce(0, +)
        let forcedErrorsTotal = outcomeTotals[.forcedError]!.values.reduce(0, +)
        let unforcedErrorsTotal = outcomeTotals[.unforcedError]!.values.reduce(0, +)
        

        let lostByUnforcedErrorsTotal = lostOutcomeTotals[.unforcedError]!
        
        
    
        return RallyStats(
            // Counts
            totalRallyPoints: totalRallyPoints,
            rallyPointsWon: rallyPointsWon,
            
            // Win rate
            rallyWinRate: rate(rallyPointsWon, totalRallyPoints),
            
            // Outcome types
            
            //------ Won by Winners, Forced Erros, and Unfroced Errors --------//
            winnersRate: rate(winnersTotal, rallyPointsWon),
            forcedErrorsRate: rate(forcedErrorsTotal, rallyPointsWon),
            opponentUnforcedRate: rate(unforcedErrorsTotal, rallyPointsWon),
            
            //Lose by Unforced Errors
            unforcedRate: rate(lostByUnforcedErrorsTotal, rallyPointsLost),
            FHUnforcedRate: rate(lostUnforcedSideCount[.forehand]!.values.reduce(0, +), lostByUnforcedErrorsTotal),
            BHUnforcedRate: rate(lostUnforcedSideCount[.backhand]!.values.reduce(0, +), lostByUnforcedErrorsTotal),
            
            
            //MISSED POSITIONS
            netLost: rate(missedTotals[.net]!, lostByUnforcedErrorsTotal),
            longLost: rate(missedTotals[.long]!, lostByUnforcedErrorsTotal),
            wideLost: rate(missedTotals[.wide]!, lostByUnforcedErrorsTotal),

            
            
            // --------- SHOT TYPES ----------- //
            F_W_GS: getRate(.winner, .forehand, .groundstroke),
            F_W_Lob: getRate(.winner, .forehand, .lob),
            F_W_Slice: getRate(.winner, .forehand, .slice),
            F_W_DS: getRate(.winner, .forehand, .dropShot),
            F_W_HV: getRate(.winner, .forehand, .halfVolley),
            F_W_Approach: getRate(.winner, .forehand, .approach),
            F_W_DV: getRate(.winner, .forehand, .driveVolley),
            F_W_Volley: getRate(.winner, .forehand, .volley),
            F_W_Smash: getRate(.winner, .forehand, .smash),
            
            //FOREHAND FORCED ERRORS
            F_FE_GS: getRate(.forcedError, .forehand, .groundstroke),
            F_FE_Lob: getRate(.forcedError, .forehand, .lob),
            F_FE_Slice: getRate(.forcedError, .forehand, .slice),
            F_FE_DS: getRate(.forcedError, .forehand, .dropShot),
            F_FE_HV: getRate(.forcedError, .forehand, .halfVolley),
            F_FE_Approach: getRate(.forcedError, .forehand, .approach),
            F_FE_DV: getRate(.forcedError, .forehand, .driveVolley),
            F_FE_Volley: getRate(.forcedError, .forehand, .volley),
            F_FE_Smash: getRate(.forcedError, .forehand, .smash),
            
            //FOREHAND UNFORCED ERRORS
            F_UE_GS: getRate(.unforcedError, .forehand, .groundstroke),
            F_UE_Lob: getRate(.unforcedError, .forehand, .lob),
            F_UE_Slice: getRate(.unforcedError, .forehand, .slice),
            F_UE_DS: getRate(.unforcedError, .forehand, .dropShot),
            F_UE_HV: getRate(.unforcedError, .forehand, .halfVolley),
            F_UE_Approach: getRate(.unforcedError, .forehand, .approach),
            F_UE_DV: getRate(.unforcedError, .forehand, .driveVolley),
            F_UE_Volley: getRate(.unforcedError, .forehand, .volley),
            F_UE_Smash: getRate(.unforcedError, .forehand, .smash),
            
            //BACKHAND WINNERS
            B_W_GS: getRate(.winner, .backhand, .groundstroke),
            B_W_Lob: getRate(.winner, .backhand, .lob),
            B_W_Slice: getRate(.winner, .backhand, .slice),
            B_W_DS: getRate(.winner, .backhand, .dropShot),
            B_W_HV: getRate(.winner, .backhand, .halfVolley),
            B_W_Approach: getRate(.winner, .backhand, .approach),
            B_W_DV: getRate(.winner, .backhand, .driveVolley),
            B_W_Volley: getRate(.winner, .backhand, .volley),
            B_W_Smash: getRate(.winner, .backhand, .smash),
            
            //BACKHAND FORCED ERRORS
            B_FE_GS: getRate(.forcedError, .backhand, .groundstroke),
            B_FE_Lob: getRate(.forcedError, .backhand, .lob),
            B_FE_Slice: getRate(.forcedError, .backhand, .slice),
            B_FE_DS: getRate(.forcedError, .backhand, .dropShot),
            B_FE_HV: getRate(.forcedError, .backhand, .halfVolley),
            B_FE_Approach: getRate(.forcedError, .backhand, .approach),
            B_FE_DV: getRate(.forcedError, .backhand, .driveVolley),
            B_FE_Volley: getRate(.forcedError, .backhand, .volley),
            B_FE_Smash: getRate(.forcedError, .backhand, .smash),
            
            //BACKHAND UNFORCED ERRORS
            B_UE_GS: getRate(.unforcedError, .forehand, .groundstroke),
            B_UE_Lob: getRate(.unforcedError, .forehand, .lob),
            B_UE_Slice: getRate(.unforcedError, .forehand, .slice),
            B_UE_DS: getRate(.unforcedError, .forehand, .dropShot),
            B_UE_HV: getRate(.unforcedError, .forehand, .halfVolley),
            B_UE_Approach: getRate(.unforcedError, .forehand, .approach),
            B_UE_DV: getRate(.unforcedError, .forehand, .driveVolley),
            B_UE_Volley: getRate(.unforcedError, .forehand, .volley),
            B_UE_Smash: getRate(.unforcedError, .forehand, .smash),
            
            
            // Position distribution
            baselineRate: rate(baselineWins, rallyPointsWon),
            noMansLandRate: rate(noMansLandWins, rallyPointsWon),
            netRate: rate(netWins, rallyPointsWon)
            
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
    
    //---------- Outcome types ----------//
    
    //Winner
    let winnersRate: Double
//    let forehandWinnerRate: Double
//    let backhandWinnerRate: Double
//    
    //Force Errors
    let forcedErrorsRate: Double
    let opponentUnforcedRate: Double
    
    // Loses
    let unforcedRate: Double
    let FHUnforcedRate: Double
    let BHUnforcedRate: Double
    
    let netLost: Double
    let longLost: Double
    let wideLost: Double

    //FOREHAND WINNERS
    let F_W_GS: Double
    let F_W_Lob: Double
    let F_W_Slice: Double
    let F_W_DS: Double
    let F_W_HV: Double
    let F_W_Approach: Double
    let F_W_DV: Double
    let F_W_Volley: Double
    let F_W_Smash: Double
    
    //FOREHAND FORCEDERROR
    let F_FE_GS: Double
    let F_FE_Lob: Double
    let F_FE_Slice: Double
    let F_FE_DS: Double
    let F_FE_HV: Double
    let F_FE_Approach: Double
    let F_FE_DV: Double
    let F_FE_Volley: Double
    let F_FE_Smash: Double
    
    //FOREHAND UNFORCEDERROR
    let F_UE_GS: Double
    let F_UE_Lob: Double
    let F_UE_Slice: Double
    let F_UE_DS: Double
    let F_UE_HV: Double
    let F_UE_Approach: Double
    let F_UE_DV: Double
    let F_UE_Volley: Double
    let F_UE_Smash: Double
    

    //BACKHAND WINNERS
    let B_W_GS: Double
    let B_W_Lob: Double
    let B_W_Slice: Double
    let B_W_DS: Double
    let B_W_HV: Double
    let B_W_Approach: Double
    let B_W_DV: Double
    let B_W_Volley: Double
    let B_W_Smash: Double
    
    //BACKHAND FORCEDERROR
    let B_FE_GS: Double
    let B_FE_Lob: Double
    let B_FE_Slice: Double
    let B_FE_DS: Double
    let B_FE_HV: Double
    let B_FE_Approach: Double
    let B_FE_DV: Double
    let B_FE_Volley: Double
    let B_FE_Smash: Double
    
    //BACKHAND UNFORCEDERROR
    let B_UE_GS: Double
    let B_UE_Lob: Double
    let B_UE_Slice: Double
    let B_UE_DS: Double
    let B_UE_HV: Double
    let B_UE_Approach: Double
    let B_UE_DV: Double
    let B_UE_Volley: Double
    let B_UE_Smash: Double
    
    


    // Position distribution
    let baselineRate: Double
    let noMansLandRate: Double
    let netRate: Double
    
}

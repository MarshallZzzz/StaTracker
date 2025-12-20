//
//  ScoringEnums.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/25/25.
//

import Foundation

enum Player: Codable{
    case curr, opp
}

//Match format
/*
sets to win : Int
 
setType : setType
    case Fast 4
    case Standard Set 6
    case Pro set 8
 
automatic tiebreaker for each set
 
 if sets to win > 1
 
 Final Set format : finalSetFormat
    case set setType
    case tieBreaker
 
if final set is tieBreaker -> 10 points
 
 Scoring type: ScoringType
    case ad
    case no adt
 
 */

//Scoring
struct MatchFormat: Codable {
    let scoringType: ScoringType // Ad or No-Ad
//    let playTiebreakAt: Int // e.g., 4 for fast 4, 6 for standard set, 8 for pro set, or 0 if no tiebreak
    let setFormat:setFormat // e.g., 1 for one sets, tiebreaks, and pro sets, 2 for best out of 3, 3 for best out of 5
    let finalSetFormat: FinalSetFormat // How to decide the last set
    
    var setsToWin: Int {
        switch setFormat {
        case .bestOf3:
            return 2
        case .bestOf5:
            return 3
        default:
            return 1
        }
    }
    
    var gamesPerSetToWin: Int {
        switch setFormat {
        case .fast4:
            return 4
        case .proSet:
            return 8
        default:
            return 6
        }
    }
    
    var playTieBreakAt: Int {
        switch setFormat {
        case .fast4:
            return 3
        case .proSet:
            return 7
        default:
            return 6
        }
    }
    
}

extension MatchFormat {
    static let defaultFormat = MatchFormat(
        scoringType: .ad,
        setFormat: .bestOf3,
        finalSetFormat: .regularSet
    )
}

enum setFormat: String, Codable {
    case fast4, stdSet, proSet, bestOf3, bestOf5
}

enum tieBreakFormat: String, Codable{
    case standardTiebreaker
    case superTiebreaker
}

//ad or no add
enum ScoringType: Codable {
    case ad
    case noAd
}

//if scoring needs final set
enum FinalSetFormat: Codable {
    case regularSet // Win by 2 games
    case matchTiebreak // A tiebreak indicator
}


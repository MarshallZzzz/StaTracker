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

struct tieBreakScore: Codable {
    let p1: Int //player
    let p2: Int //opponent
}

//if add
enum Advantage: String, Codable {
    case deuce
    case adIn
    case adOut
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


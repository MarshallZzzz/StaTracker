//
//  MatchViewModel.swift
//  StaTracker

// MANAGE THE FLOW OF THE MATCH STATE
// HOW TO  PRESENT THE MODEL DATA?
//
//  Created by Marshall Zhang on 12/1/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MatchViewModel: ObservableObject {
    @Published var match: Match
    @Published var server: Player
    
    let currPlayer: String
    let oppPlayer: String
    let selectedFormat: MatchFormat
    var stats: StatEngine

    
    init(currPlayer: String, oppPlayer: String, server: Player, selectedFormat: MatchFormat) {
        self.currPlayer = currPlayer
        self.oppPlayer = oppPlayer
        self.selectedFormat = selectedFormat
        self.server = server
        self.match = Match(currPlayer: currPlayer, oppPlayer: oppPlayer, startingServer: server, format: selectedFormat)
        self.stats = StatEngine(points: [])
    }

    func isMatchComplete() -> Bool {
        computeStats()
        return match.matchComplete
    }
    
    func computeStats() {
        let finalizedStats = StatEngine(points: match.points)
        stats = finalizedStats
        
    }
}





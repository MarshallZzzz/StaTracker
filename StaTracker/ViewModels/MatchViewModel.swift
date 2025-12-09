//
//  MatchViewModel.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/1/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MatchViewModel: ObservableObject {
    @Published var match: Match
    
    let currPlayer: String
    let oppPlayer: String
    let selectedFormat: MatchFormat

    
    init(currPlayer: String, oppPlayer: String, selectedFormat: MatchFormat) {
        self.currPlayer = currPlayer
        self.oppPlayer = oppPlayer
        self.selectedFormat = selectedFormat
        self.match = Match(currPlayer: currPlayer, oppPlayer: oppPlayer, format: selectedFormat)
    }

}

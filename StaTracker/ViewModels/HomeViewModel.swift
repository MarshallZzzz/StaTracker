//
//  HomeViewModel.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {

    @Published var csvString: String?
    @Published var showShareSheet = false

    private let csvExporter = CSVExporter()
    private let matchStorage = MatchStorageService()

    func exportCSV() {
        let matches = matchStorage.loadAllMatches()
        let result = csvExporter.export(matches: matches)

        self.csvString = result
        self.showShareSheet = true
    }
}


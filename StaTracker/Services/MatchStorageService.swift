//
//  MatchStorageService.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//
import Foundation

class MatchStorageService {

    private let key = "storedMatches"

    func saveMatch(_ match: Match) {
        var all = loadAllMatches()
        all.append(match)

        if let encoded = try? JSONEncoder().encode(all) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func loadAllMatches() -> [Match] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Match].self, from: data)
        else { return [] }

        return decoded
    }
}

//
//  StatViewModel.swift
//  StaTracker
//
//  LIVE STAT VIEWMODEL
//
//  Created by Marshall Zhang on 12/20/25.
//

import Foundation
import Combine

//CHAT GPT VERSION
class StatsViewModel: ObservableObject {

    var cache: [String: Any] = [:]
    
    private var computeCount: [String: Int] = [:]
    private var lastProcessedPointCount = 0
    var points: [Point] = []
    
    @Published private var stats: StatEngine
//    @Published var charts: ChartsDataModel

    init() {
        self.stats = StatEngine(points: points)
//        self.charts = ChartsDataModel(from: stats)

    }

    func update(point: Point) {
        // Only recompute expensive stats when new points come in
        if points.count != lastProcessedPointCount {
            stats.points.append(point)
//            charts = ChartsDataModel(from: stats)
            cache.removeAll()                  // reset cache
            lastProcessedPointCount = points.count
        }
    }
    
    
    private func cached<T>(_ key: String, compute: () -> T) -> T {
          if let value = cache[key] as? T {
              return value
          }

          // Count how many times this stat was computed
          computeCount[key, default: 0] += 1

          let result = compute()
          cache[key] = result
          return result
      }
    
    func computeCountFor(_ key: String) -> Int {
        return computeCount[key] ?? 0
    }
    
    func totalFirstServes() -> Int {
        cached("totalFirstServes") {
            stats.totalFirstServes
        }
    }
    
}


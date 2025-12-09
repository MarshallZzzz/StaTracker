//
//  RallyData.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import Foundation

struct RallyData: Codable {
    var outcome: RallyOutcome?
    var outcomeType: OutcomeType?
    var playerShotSide: PlayerShotSide?
    var playerPosition: PlayerPosition?
    var type: ShotType?
    var trajectory: ShotTrajectory?
    var missPosition: missedPosition?
    var rallyNumber: Int?
}

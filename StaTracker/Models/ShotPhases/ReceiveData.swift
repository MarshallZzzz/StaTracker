//
//  ReceiveData.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import Foundation

struct ReceiveData: Codable {
    var made: ReceiveMade?
    var shotSide: PlayerShotSide?
    var trajectory: ShotTrajectory?
    var miss: MissedPosition?
    var outcome: ReceiveOutcome?
}

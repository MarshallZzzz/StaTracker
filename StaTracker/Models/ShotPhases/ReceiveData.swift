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
    var miss: ReceiveMissed?
    var outcome: ReceiveOutcome?
    
    mutating func resetData(){
        self.made = nil
        self.shotSide = nil
        self.trajectory = nil
        self.miss = nil
        self.outcome = nil
    }
}

//10

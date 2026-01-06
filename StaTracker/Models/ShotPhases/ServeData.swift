//
//  ServeData.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import Foundation

struct ServeData: Codable {
    var made: ServeMade? = nil
    var type: ServeType? = nil
    var madePosition: ServePosition? = nil
    var missPosition: MissedPosition? = nil
    var outcome: SROutcome? = nil
    
    mutating func resetData(){
        self.made = nil
        self.type = nil
        self.madePosition = nil
        self.missPosition = nil
        self.outcome = nil
    }
}

//12

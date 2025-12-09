//
//  ServeData.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import Foundation

struct ServeData: Codable {
    var made: ServeMade?
    var type: ServeType?
    var madePosition: ServePosition?
    var misType: ServeType?
    var missPosition: missedPosition?
    var outcome: SROutcome?
}

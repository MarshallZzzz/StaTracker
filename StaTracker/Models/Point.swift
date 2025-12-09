//
//  Point.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

enum ServingPlayer: String, Codable{
    case curr, opp
}

import Foundation
struct Point: Identifiable, Codable {
    let id = UUID()
    let server: ServingPlayer
    
    //Serve
    var firstServe = ServeData()
    var secondServe = ServeData()
    
    //REceive
    var firstReceive = ReceiveData()
    var secondReceive = ReceiveData()
    
    //Rally
    var rally = RallyData()
}


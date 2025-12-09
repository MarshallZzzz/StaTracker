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
    var firstServe: ServeData? = nil
    var secondServe: ServeData? = nil
    
    //REceive
    var firstReceive: ReceiveData? = nil
    var secondReceive: ReceiveData? = nil
    
    //Rally
    var rally: RallyData? = nil
}


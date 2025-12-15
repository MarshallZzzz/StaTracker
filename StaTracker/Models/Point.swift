//
//  Point.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//


import Foundation
struct Point: Identifiable, Codable {
    let id = UUID()
    let server: Player
    
    //Serve
    var firstServe: ServeData? = nil
    var secondServe: ServeData? = nil
    
    //REceive
    var firstReceive: ReceiveData? = nil
    var secondReceive: ReceiveData? = nil
    
    //Rally
    var rally: RallyData? = nil
    
    
    var playerWon: Player? = nil
    var currScore: String? = "0"
    var oppScore: String? = "0"
    var notes: String? = ""
}


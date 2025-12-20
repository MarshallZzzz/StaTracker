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
    var gameScore: GameScore? = nil
    var notes: String = ""
    
//    mutating func setGameScore(currScore: Int, oppScore: Int){
//        var scoreMap: [Int: String] = [
//            0: "0",
//            1: "15",
//            2: "30",
//            3: "40"
//        ]
//        
//        if currScore >= 3 && oppScore >= 3 {
//            var difference = currScore - oppScore
//            scoreMap = [
//                -1: "Ad - Out",
//                 0: "Deuce",
//                 1: "Ad - In",
//                 2: "Win"
//            ]
//        }
////        
////        self.currScore = scoreMap[currScore]!
////        self.oppScore = scoreMap[oppScore]!
//        
//    }
    
    mutating func setGameScore(gameScore: GameScore){
        self.gameScore = gameScore
    }
}


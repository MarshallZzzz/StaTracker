//
//  Match.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/26/25.
//

import Foundation

struct Match: Identifiable, Codable {
    let id = UUID()

    let currPlayer: String
    let oppPlayer: String
    let format: MatchFormat //the match format
    let date: Date//the date
    
    var score: MatchScore //the collection of scores
    var points: [Point] //collection of all the points
    
    init(currPlayer: String, oppPlayer: String, format: MatchFormat) {
        self.currPlayer = currPlayer
        self.oppPlayer = oppPlayer
        self.format = format
        self.score = MatchScore(format: format)
        self.points = []
        self.date = Date()
    }
    
    mutating func addPoint(_ point: Point) {
        points.append(point)
    }
    
}

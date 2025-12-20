//
//  UnifiedFlowViewModel.swift
//  StaTracker
//
//  Controls Serve → Rally or Receive → Rally unified flow
//

import SwiftUI
import Foundation
import Combine

class FlowViewModel: ObservableObject {
    
//    @ObservedObject var vm: MatchViewModel
    // External input: who's serving this point
    @Published var server: Player   // .curr or .opp
    
    // Unified state machine
    @Published var state: PointFlowState = .start

    
    @Published var currPoint: Point
    
    var onPointFinished: ((Point) -> Void)?
    var onMatchFinished: (() -> Void)?
    
    init(server: Player) {
        self.currPoint = Point(server: server)
        self.server = server
        startFlow()
    }
    
    func prepareNextPoint(server: Player){
        self.currPoint = Point(server: server)
        self.currPoint.firstServe = ServeData()
        self.currPoint.secondServe = ServeData()
        
        self.currPoint.firstReceive = ReceiveData()
        self.currPoint.secondReceive = ReceiveData()
        
        self.currPoint.rally = RallyData()
    }
    
    // Start Correct Flow
    func startFlow() {
        if server == .curr {
            currPoint.firstServe = ServeData()
            state = .serve(.serveMade)
        } else {
            currPoint.firstReceive = ReceiveData()
            state = .receive(.receiveMade)
        }
    }
    
    func updateServer(_ server: Player) {
        self.server = server
    }
    // MARK: - Assign values based on user input
    func updateFirstServe(_ data: ServeData) {
        currPoint.firstServe = data
    }
    
    func updateSecondServe(_ data: ServeData) {
        currPoint.secondServe = data
    }
    
    func updateFirstReceive(_ data: ReceiveData) {
        currPoint.firstReceive = data
    }
    
    func updateSecondReceive(_ data: ReceiveData) {
        currPoint.secondReceive = data
    }
    
    func updateRally(_ data: RallyData) {
        currPoint.rally = data
    }
//
//    func updateScore(_ currScore: String, _ oppScore: String){
//        currPoint.currScore = currScore
//        currPoint.oppScore = oppScore
//    }
//    
    func setWinner(_ win: Player){
        currPoint.playerWon = win
    }
    
//    func setGameScore(currScore: Int, oppScore: Int){
//        let scoreMap: [Int: String] = [
//            0: "0",
//            1: "15",
//            2: "30",
//            3: "40"
//        ]
//        
//        currPoint.currScore = scoreMap[currScore]!
//        currPoint.oppScore = scoreMap[oppScore]!
//        
//    }
    
    func setNotes(notes: String){
        currPoint.notes = notes
    }
    
    //Next step from serve, receive, or rally
    func advance(_ next: PointFlowState) {
        state = next
    }
    
    func finishPoint() {
        state = .finished

        onPointFinished?(currPoint)
    }
    
    func finishMatch(){
        state = .finished
    }
    
}
enum PointFlowState {
    case start
    case serve(servingPrompts)
    case receive(receivingPrompts)
    case rally(rallyPrompts)
    case finished
}

//struct FlowHistoryEntry: Identifiable {
//    let id = UUID()
//    let timestamp: Date
//    let prompt: String
//    let value: String
//    let flow: String  // "Serve", "Receive", "Rally"
//}

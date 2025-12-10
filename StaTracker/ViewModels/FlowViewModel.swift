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
    @Published var server: ServingPlayer   // .curr or .opp
    
    // Unified state machine
    @Published var state: PointFlowState = .start

    
    @Published var currPoint: Point
    
    var onPointFinished: ((Point) -> Void)?
    
    init(server: ServingPlayer) {
        self.currPoint = Point(server: server)
        self.server = server
        startFlow()
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
    
    func updateServer(server: ServingPlayer){
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
    
    func setWinner(_ win: Winner){
        currPoint.playerWon = win
    }
    
    //Next step from serve, receive, or rally
    func advance(_ next: PointFlowState) {
        state = next
    }
    
    func finishPoint() {
        state = .finished
        
        print("POINT COMPLETED:\n\(currPoint)")
        onPointFinished?(currPoint)
        
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

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
    
    // External input: who's serving this point
    @Published var server: ServingPlayer   // .curr or .opp
    
    // Unified state machine
    @Published var state: PointFlowState = .start
    
    // History of user selections
    @Published var history: [FlowHistoryEntry] = []
    
    // Progress percentage
    @Published var progress: CGFloat = 0.0
    
    init(server: ServingPlayer) {
        self.server = server
        startFlow()
    }
    
    // Start Correct Flow
    func startFlow() {
        if server == .curr {
            state = .serve(.serveMade)
        } else {
            state = .receive(.receiveMade)
        }
        updateProgress()
    }
    
    // Record an action
    func log(_ prompt: String, value: String, flow: String) {
        let entry = FlowHistoryEntry(
            timestamp: Date(),
            prompt: prompt,
            value: value,
            flow: flow
        )
        history.append(entry)
    }
    
//     Next step from serve, receive, or rally
    func advance(_ next: PointFlowState) {
        state = next
        updateProgress()
    }
    
    func finishPoint() {
        state = .finished
    }
    
    // Calculate progress
    func updateProgress() {
        let totalSteps: CGFloat = 10  // Adjust if adding more
        let current: CGFloat
        
        switch state {
        case .start: current = 0
        case .serve(let step):
            current = step.progressIndex
        case .receive(let step):
            current = step.progressIndex
        case .rally(let step):
            current = step.progressIndex
        case .finished:
            current = totalSteps
        }
        
        progress = current / totalSteps
    }
}

enum PointFlowState {
    case start
    case serve(servingPrompts)
    case receive(receivingPrompts)
    case rally(rallyPrompts)
    case finished
}

struct FlowHistoryEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let prompt: String
    let value: String
    let flow: String  // "Serve", "Receive", "Rally"
}

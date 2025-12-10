//
// FlowControllerView.swift
//

import SwiftUI

struct FlowControllerView: View {
    
    @ObservedObject var fm: FlowViewModel
//    @StateObject var vm: MatchViewModel
    
    var body: some View {
        
        VStack {
            switch fm.state {
                
            case .serve(let step):
                ServePromptingView(step: step, fm: fm)
                    .transition(.opacity.combined(with: .slide))
                
            case .receive(let step):
                ReceivePromptingView(step: step, fm: fm)
                    .transition(.opacity.combined(with: .slide))
                
            case .rally(let step):
                RallyPromtpingView(step: step, fm: fm)
                    .transition(.opacity.combined(with: .slide))
                
                //Create new point and update gamescore
            case .finished:
                Text("Point Complete")
                    .font(.largeTitle)
                    .padding()
                
            default:
                EmptyView()
            }
            
            Spacer()
        }
    }
}

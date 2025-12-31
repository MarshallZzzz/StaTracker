//
// FlowControllerView.swift
//

import SwiftUI

struct FlowControllerView: View {
    
    @ObservedObject var fm: FlowViewModel
    @ObservedObject var vm: MatchViewModel
    
    var stat: StatEngine? = nil
    //@State var server: ServingPlayer

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
                PromptButton("Match Complete")
                {
                    fm.onMatchFinished!()
//                    stat!.points = vm.match.points
                }
                
                
            default:
                EmptyView()
            }
            
            Spacer()
        }
    }
}

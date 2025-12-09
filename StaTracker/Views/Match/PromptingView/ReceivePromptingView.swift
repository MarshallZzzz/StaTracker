//
// ReceiveFlowView.swift
//

import SwiftUI

struct ReceivePromptingView: View {
    
    let step: receivingPrompts
    @ObservedObject var fm: FlowViewModel
    @State private var serveNumber = 1
    @State private var made: Bool = false
    
    var body: some View {
        
        VStack {
            switch step {
                
            case .receiveMade:
                Text(serveNumber == 1 ? "First Serve Return" : "Second Serve Return")
                    .font(.title)
                VStack{
                    
                    HStack {
                        stepButton("Made") {
                            //                        vm.log("Return Made", "Made", flow: "Receive")
                            made = true
                            fm.advance(.receive(.playerShotSide))
                        }
                        stepButton("Missed") {
                            //                        vm.log("Return Missed", "Missed", flow: "Receive")
                            made = false
                            fm.advance(.receive(.playerShotSide))
                        }
                    }
                    stepButton("Opponent Missed"){
                        serveNumber = 2
                        fm.advance(.receive(.receiveMade))
                    }
                }
            case .playerShotSide:
                Text("Player Position")
                    .font(.title)
                
                if made {
                    HStack {
                        stepButton("Forehand") {
                            //vm.log("Return Missed", "Missed", flow: "Receive")
                            fm.advance(.receive(.receivePosition))
                        }
                        stepButton("Backhand") {
                            //vm.log("Return Missed", "Missed", flow: "Receive")
                            fm.advance(.receive(.receivePosition))
                        }
                    }
                } else {
                    HStack{
                        stepButton("Forehand") {
                            //vm.log("Return Missed", "Missed", flow: "Receive")
                            fm.advance(.receive(.missedPosition))
                        }
                        stepButton("Backhand") {
                            //vm.log("Return Missed", "Missed", flow: "Receive")
                            fm.advance(.receive(.missedPosition))
                        }
                    }
                }
                
            case .receivePosition:
                Text("Returned Position")
                    .font(.title)
                HStack {
                    pos("Cross Court")
                    pos("Down Line")
                }

                
            case .missedPosition:
                Text("Missed Position")
                    .font(.title)
                
                VStack {
                    HStack {
                        missed("Net")
                        missed("Long")
                    }
                    missed("Wide")
                }
                
            case .receiveOutcome:
                Text("Return Outcome")
                    .font(.title)
                
                VStack {
                    HStack {
                        outcome("Winner")
                        outcome("Forced Error")
                    }
                    HStack {
                        outcome("Unforced Error")
                        stepButton("RALLY") {
//                            vm.log("Return Outcome", "Rally", flow: "Receive")
                            fm.advance(.rally(.rallyOutcome))
                        }
                    }
                }
                
            default:
                EmptyView()
            }
        }
    }
    
    private func pos(_ p: String) -> some View {
        stepButton(p) {
//            vm.log("Return Position", p, flow: "Receive")
            fm.advance(.receive(.receiveOutcome))
        }
    }

    
    private func missed(_ p: String) -> some View {
        stepButton(p) {
//            vm.log("Missed Return", p, flow: "Receive")
            fm.finishPoint()
        }
    }
    
    private func outcome(_ p: String) -> some View {
        stepButton(p) {
//            vm.log("Return Outcome", p, flow: "Receive")
            fm.finishPoint()
        }
    }
}

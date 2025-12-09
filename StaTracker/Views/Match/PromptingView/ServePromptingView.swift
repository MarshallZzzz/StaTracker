//
// ServeFlowView.swift
//

import SwiftUI

struct ServePromptingView: View {
    
    let step: servingPrompts
    @ObservedObject var fm: FlowViewModel
    
    @State private var serve = ServeData()
    @State private var serveNumber = 1
    
    var body: some View {
        
        VStack {
            switch step {
                
            case .serveMade:
                Text(serveNumber == 1 ? "First Serve" : "Second Serve")
                    .font(.title)
                EnumStepButtons(ServeMade.self) { value in
                    if value == .made {
                        serve.made = .made
                        fm.advance(.serve(.serveType))
                    } else {
                        serve.made = .miss
                        serveNumber = 2
                        fm.advance(.serve(.missedType))
                    }
                }
                
            case .serveType:
                Text("Serve Type?")
                    .font(.title)
                EnumStepButtons(ServeType.self) { value in
                    if value == .flat {
                        serve.type = .flat
                        fm.advance(.serve(.servePosition))
                    } else if value == .spin {
                        serve.type = .spin
                        fm.advance(.serve(.servePosition))
                    } else if value == .slice {
                        serve.type = .slice
                        fm.advance(.serve(.servePosition))
                    } else {
                        serve.type = .kick
                        fm.advance(.serve(.servePosition))
                    }
                }

                
            case .servePosition:
                Text("Serve Position?")
                    .font(.title)
                EnumStepButtons(ServePosition.self) { value in
                    if value == .wide {
                        serve.madePosition = .wide
                        fm.advance(.serve(.SROutcome))
                    } else if value == .body {
                        serve.madePosition = .body
                        fm.advance(.serve(.SROutcome))
                    } else if value == .T {
                        serve.madePosition = .T
                        fm.advance(.serve(.SROutcome))
                    }
                }

                
            case .missedType:
                Text("Serve Miss Type?")
                    .font(.title)
                EnumStepButtons(ServeType.self) { value in
                    if value == .flat {
                        serve.misType = .flat
                        fm.advance(.serve(.missedPosition))
                    } else if value == .spin {
                        serve.misType = .spin
                        fm.advance(.serve(.missedPosition))
                    } else if value == .slice {
                        serve.misType = .slice
                        fm.advance(.serve(.missedPosition))
                    } else {
                        serve.misType = .kick
                        fm.advance(.serve(.missedPosition))
                    }
                }
                
            case .missedPosition:
                Text("Missed Position?")
                    .font(.title)

                if serveNumber == 1{
                    VStack {
                        HStack {
                            missedPos("Net")
                            missedPos("Long")
                        }
                        missedPos("Wide")
                    }
                } else{
                    VStack {
                        HStack {
                            doubleFault("Net")
                            doubleFault("Long")
                        }
                        doubleFault("Wide")
                    }
                }
            case .SROutcome:
                Text("Serve Outcome")
                    .font(.title)
                
                VStack {
                    HStack {
                        srOutcome("Ace")
                        srOutcome("Forced Error")
                    }
                    HStack {
                        srOutcome("Unforced Error")
                        stepButton("RALLY") {
//                            vm.log("Serve Outcome", "Rally", flow: "Serve")
                            fm.advance(.rally(.rallyOutcome))
                        }
                    }
                }
                
            default:
                EmptyView()
            }
        }
    }
    
    private func missedType(_ type: String) -> some View {
        stepButton(type) {
//            vm.log("Miss Type", type, flow: "Serve")
            fm.advance(.serve(.missedPosition))
        }
    }
    
    private func missedPos(_ pos: String) -> some View {
        return stepButton(pos) {
//            vm.log("Miss Position", pos, flow: "Serve")
            serveNumber = 2
            fm.advance(.serve(.serveMade))
            
        }
    }

    private func doubleFault(_ pos: String) -> some View {
        stepButton(pos) {
//            vm.log("Miss Position", pos, flow: "Serve")
            fm.finishPoint()
        }
    }

    
    private func srOutcome(_ outcome: String) -> some View {
        stepButton(outcome) {
//            vm.log("Serve Outcome", outcome, flow: "Serve")
            fm.finishPoint()
        }
    }
}

//
// ServeFlowView.swift
//

import SwiftUI

struct ServePromptingView: View {
    
    let step: servingPrompts
    @ObservedObject var fm: FlowViewModel
    
    @State private var serve = ServeData()
    @State private var serveNumber = 1
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        VStack {
            switch step {
                
            case .serveMade:
                Text(serveNumber == 1 ? "First Serve" : "Second Serve")
                    .font(.title)
                EnumStepButtons(ServeMade.self) { value in
                    
                    if serveNumber == 1 {
                        fm.currPoint.firstServe?.made = value
                        fm.currPoint.secondServe = nil
                    } else{
                        fm.currPoint.secondServe?.made = value
                    }
                    
                    if value == .made{
                        fm.advance(.serve(.serveType))
                    } else{
                        fm.advance(.serve(.missedType))
                    }

                    
//                    if value == .made{
//                        if serveNumber == 1 {
//                            fm.currPoint.firstServe?.made = value
////                            fm.updateFirstServe(serve)
//                            fm.currPoint.secondServe = nil
//                            fm.advance(.serve(.serveType))
//                        } else {
//                            fm.currPoint.secondServe?.made = value
////                            fm.updateSecondServe(serve)
//                            fm.advance(.serve(.serveType))
//                        }
//                        
//                    } else {
//                        fm.advance(.serve(.missedType))
//                    }
                }
                
            case .serveType:
                Text("Serve Type?")
                    .font(.title)
                EnumStepButtons(ServeType.self) { value in
                    
                    if serveNumber == 1{
                        fm.currPoint.firstServe?.type = value
//                        fm.updateFirstServe(serve)
                    } else {
                        fm.currPoint.secondServe?.type = value
//                        fm.updateSecondServe(serve)
                    }
                    
                    fm.advance(.serve(.servePosition))
                }

            case .servePosition:
                Text("Serve Position?")
                    .font(.title)
                EnumStepButtons(ServePosition.self) { value in
                    
                    if serveNumber == 1{
                        fm.currPoint.firstServe?.madePosition = value
//                        fm.updateFirstServe(serve)
                    } else {
                        fm.currPoint.secondServe?.madePosition = value
//                        fm.updateSecondServe(serve)
                    }
                    
                    fm.advance(.serve(.SROutcome))
                }
                
            case .missedType:
                Text("Serve Miss Type?")
                    .font(.title)
                EnumStepButtons(ServeType.self) { value in
                    
                    if serveNumber == 1{
                        fm.currPoint.firstServe?.misType = value
//                        fm.updateFirstServe(serve)
                    } else {
                        fm.currPoint.secondServe?.misType = value
//                        fm.updateSecondServe(serve)
                    }
                    
                    fm.advance(.serve(.missedPosition))
                }
                
            case .missedPosition:
                Text("Missed Position?")
                    .font(.title)

                EnumStepButtons(MissedPosition.self){ value in
                    
                    if serveNumber == 1{
                        fm.currPoint.firstServe?.missPosition = value
                        fm.currPoint.secondServe?.resetData()
                        fm.advance(.serve(.serveMade))
                        serveNumber = 2
                    } else {
                        fm.currPoint.secondServe?.missPosition = value
//                        fm.updateSecondServe(serve)
                        fm.setWinner(.opp)
                        serveNumber = 1
                        fm.finishPoint()
                    }

                }
            case .SROutcome:
                Text("Serve Outcome")
                    .font(.title)
                EnumStepButtons(SROutcome.self) {value in
                    
                    if serveNumber == 1{
                        fm.currPoint.firstServe?.outcome = value
//                        fm.updateFirstServe(serve)
                    } else {
                        serveNumber = 1
                        fm.currPoint.secondServe?.outcome = value
//                        fm.updateSecondServe(serve)/
                    }
                    
                    if value == .rally {
                        fm.advance(.rally(.rallyOutcome))
                    } else {
                        fm.currPoint.rally = nil
                        fm.setWinner(.curr)
//                        fm.advance(.serve(.notes))
                        fm.finishPoint()
                    }
                }
            
            case .notes:
                VStack{
                    Text("Notes")
                        .font(.title)
                    TextField("Add match notes...", text: $fm.currPoint.notes, axis: .vertical)
                        .font(.body)
                            .padding(16)
                            .frame(minHeight: 250, alignment: .topLeading) // Large, predictable box
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                    PromptButton("Complete Point",action: fm.finishPoint)
                }

            default:
                EmptyView()
            }
        }
        .onAppear {
            // Reset when the view first shows up for a new point
            self.serve = ServeData()
        }
        .onChange(of: serveNumber) { _, _ in
            // Reset when moving from First Serve to Second Serve
            self.serve = ServeData()
        }
    }
}

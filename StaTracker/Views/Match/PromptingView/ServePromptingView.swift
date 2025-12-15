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
                    
                    serve.made = value
                    
                    if serveNumber == 1{
                        fm.updateFirstServe(serve)
                        
                        if value == .made{
                            fm.currPoint.secondServe = nil
                            fm.advance(.serve(.serveType))
                            return
                        }
                    } else {
                        fm.updateSecondServe(serve)
                        if value == .made{
                            fm.advance(.serve(.serveType))
                        }
                    }
                    
                    if value == .miss {
                        fm.advance(.serve(.missedType))
                    }
                }
                
            case .serveType:
                Text("Serve Type?")
                    .font(.title)
                EnumStepButtons(ServeType.self) { value in
                    serve.type = value
                    
                    if serveNumber == 1{
                        fm.updateFirstServe(serve)
                    } else {
                        fm.updateSecondServe(serve)
                    }
                    
                    fm.advance(.serve(.servePosition))
                }

            case .servePosition:
                Text("Serve Position?")
                    .font(.title)
                EnumStepButtons(ServePosition.self) { value in
                    
                    serve.madePosition = value
                    
                    if serveNumber == 1{
                        fm.updateFirstServe(serve)
                    } else {
                        fm.updateSecondServe(serve)
                    }
                    
                    fm.advance(.serve(.SROutcome))
                }
                
            case .missedType:
                Text("Serve Miss Type?")
                    .font(.title)
                EnumStepButtons(ServeType.self) { value in
                    serve.misType = value
                    
                    if serveNumber == 1{
                        fm.updateFirstServe(serve)
                    } else {
                        fm.updateSecondServe(serve)
                    }
                    
                    fm.advance(.serve(.missedPosition))
                }
                
            case .missedPosition:
                Text("Missed Position?")
                    .font(.title)

                EnumStepButtons(MissedPosition.self){ value in
                    serve.missPosition = value
                    
                    if serveNumber == 1{
                        fm.updateFirstServe(serve)
                        fm.advance(.serve(.serveMade))
                        serveNumber = 2
                    } else {
                        fm.updateSecondServe(serve)
                        fm.setWinner(.opp)
                        serveNumber = 1
                        fm.finishPoint()
                    }

                }
            case .SROutcome:
                Text("Serve Outcome")
                    .font(.title)
                EnumStepButtons(SROutcome.self) {value in
                    serve.outcome = value
                    
                    if serveNumber == 1{
                        fm.updateFirstServe(serve)
                    } else {
                        serveNumber = 1
                        fm.updateSecondServe(serve)
                    }
                    
                    if value == .rally {
                        fm.advance(.rally(.rallyOutcome))
                    } else {
                        fm.currPoint.rally = nil
                        fm.setWinner(.curr)
                        fm.finishPoint()
                    }
                }

            default:
                EmptyView()
            }
        }
    }
}

//
// ReceiveFlowView.swift
//

import SwiftUI

struct ReceivePromptingView: View {
    
    let step: receivingPrompts
    @ObservedObject var fm: FlowViewModel
    
    @State private var receive = ReceiveData()
    @State private var serveNumber = 1
    @State private var made: Bool = false
    
    var body: some View {
        
        VStack {
            switch step {
                
            case .receiveMade:
                Text(serveNumber == 1 ? "First Serve Return" : "Second Serve Return")
                    .font(.title)
                EnumStepButtons(ReceiveMade.self) { value in
//                    receive.made = value
//                    print("Receive made: \(receive)")
                    
                    if serveNumber == 1{
                        fm.currPoint.firstReceive?.made = value
                        receive.made = value
                        
                        if value == .oppMiss{ // reset data prep for receive # 2
//                            self.receive = ReceiveData()
                            serveNumber = 2

                        } else if value == .miss || value == .made {
                            receive.made = value
                            fm.currPoint.secondReceive = nil
                            fm.advance(.receive(.playerShotSide))
                        } else {
                            print("error serve 1")
                        }

                        
                    } else{
                        fm.currPoint.secondReceive?.made = value
                        receive.made = value
                        serveNumber = 1
                        
                        if value == .oppMiss{ // player double fault, reset -> set winner -> finish game
//                            receive.resetData()
                            self.receive = ReceiveData()
                            fm.setWinner(.curr)
                            fm.advance(.receive(.notes))
//                            return

                        } else if value == .miss || value == .made{
                            receive.made = value
                            fm.advance(.receive(.playerShotSide))
                        } else {
                            print("error serve 2")
                        }
                    }
                    
                    print("Receive made: \(receive)")
                }

            case .playerShotSide:
                Text("Player Position")
                    .font(.title)
                EnumStepButtons(PlayerShotSide.self){value in
                    receive.shotSide = value
                    print("in player shot side: \(receive)")
                    
                    if serveNumber == 1{
//                        fm.updateFirstReceive(receive)
                        fm.currPoint.firstReceive?.shotSide = value
                    } else {
//                        fm.updateSecondReceive(receive)
                        fm.currPoint.secondReceive?.shotSide = value
                    }
                    
                    if receive.made == .made {
                        fm.advance(.receive(.receivePosition))
                    } else if receive.made == .miss {
                        fm.advance(.receive(.missedPosition))
                    }
                }

                
            case .receivePosition:
                Text("Returned Position")
                    .font(.title)
                EnumStepButtons(ShotTrajectory.self){value in
                    receive.trajectory = value
                    
                    if serveNumber == 1{
                        fm.currPoint.firstReceive?.trajectory = value
                    } else {
                        fm.currPoint.secondReceive?.trajectory = value
                    }
                    fm.advance(.receive(.receiveOutcome))
                }

            case .missedPosition:
                Text("Missed Position")
                    .font(.title)
                EnumStepButtons(ReceiveMissed.self){value in
                    receive.miss = value
        
                    if serveNumber == 1{
                        fm.currPoint.firstReceive?.miss = value
                    } else {
                        fm.currPoint.secondReceive?.miss = value
                        serveNumber = 1
                    }
                    
                    fm.setWinner(.opp)
                    receive.resetData()
                    fm.advance(.receive(.notes))
                }
                
            case .receiveOutcome:
                Text("Return Outcome")
                    .font(.title)
                
                EnumStepButtons(ReceiveOutcome.self){value in
                    receive.outcome = value
                    
                    if serveNumber == 1{
                        fm.currPoint.firstReceive?.outcome = value
                    } else {
                        serveNumber = 1
                        fm.currPoint.secondReceive?.outcome = value
                    }
                    
                    if value == .rally{
                        fm.advance(.rally(.rallyOutcome))
                    } else {
                        fm.currPoint.rally = nil
                        fm.setWinner(.curr)
                        receive.resetData()     //reset local ReceiveData
                        fm.advance(.receive(.notes))
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
    }
}

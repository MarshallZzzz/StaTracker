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
                    receive.made = value
                    
                    if serveNumber == 1{
                        fm.updateFirstReceive(receive)
                        
                        if value == .made {
                            fm.currPoint.secondReceive = nil
                        } else if value == .oppMiss {   // if opponents misses, automatically jumpt to the second
                            serveNumber = 2
                            return
                        } else {
                            fm.advance(.receive(.playerShotSide))
                        }
                    } else {
                        fm.updateSecondReceive(receive)
                        
                        if value == .oppMiss { //second serve, if they miss against then win point
                            serveNumber = 1
                            fm.setWinner(.curr)
                            fm.finishPoint()
                            return
                        }
                    }
                    
                    fm.advance(.receive(.playerShotSide))
                }
            case .playerShotSide:
                Text("Player Position")
                    .font(.title)
                EnumStepButtons(PlayerShotSide.self){value in
                    receive.shotSide = value
                    
                    if serveNumber == 1{
                        fm.updateFirstReceive(receive)
                    } else {
                        fm.updateSecondReceive(receive)
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
                        fm.updateFirstReceive(receive)
                    } else {
                        fm.updateSecondReceive(receive)
                    }
                    fm.advance(.receive(.receiveOutcome))
                }

                
            case .missedPosition:
                Text("Missed Position")
                    .font(.title)
                EnumStepButtons(MissedPosition.self){value in
                    receive.miss = value
        
                    if serveNumber == 1{
                        fm.updateFirstReceive(receive)
                        fm.setWinner(.opp)
                        fm.finishPoint()
                    } else {
                        fm.updateSecondReceive(receive)
                        fm.setWinner(.opp)
                        serveNumber = 1
                        fm.finishPoint()
                    }
                }
                
            case .receiveOutcome:
                Text("Return Outcome")
                    .font(.title)
                
                EnumStepButtons(ReceiveOutcome.self){value in
                    receive.outcome = value
                    
                    if serveNumber == 1{
                        fm.updateFirstReceive(receive)
                    } else {
                        serveNumber = 1
                        fm.updateSecondReceive(receive)
                    }
                    
                    if value == .rally{
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

//
// ReceiveFlowView.swift
//

import SwiftUI

struct ReceivePromptingView: View {
    
    let step: receivingPrompts
    @ObservedObject var fm: FlowViewModel
    
//    @State private var receive = ReceiveData()
    
    @State private var serveNumber = 1
    @State private var made: Bool = false
    
    
    var body: some View {
        
        VStack {
            switch step {
                
            case .receiveMade:
                if serveNumber == 1 {
                    Text("First Serve Return")
                        .font(.title)
                } else {
                    HStack{
                        Button(action: {
                            withAnimation(.spring())
                            {serveNumber = 1}
                        }){
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(8) // Space between the icon and the circle border
                                .background(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1) // The circular border
                                )
                        }
                        Text("Second Serve Return ")
                            .font(.title)
                    }
                }
                EnumStepButtons(ReceiveMade.self) { value in
                    
                    if serveNumber == 1{
                        fm.currPoint.firstReceive?.made = value

                        
                        if value == .oppMiss{ // reset data prep for receive # 2
                            serveNumber = 2

                        } else{
                            if value == .made {made = true}
                            else if value == .miss{made = false}
                            
                            fm.advance(.receive(.playerShotSide))
                        }
                    } else{
                        fm.currPoint.secondReceive?.made = value

                        if value == .oppMiss{ // player double fault, reset -> set winner -> finish game
                            serveNumber = 1
                            fm.setWinner(.curr)
                            fm.advance(.receive(.notes))

                        } else {
                            if value == .made {made = true}
                            else if value == .miss{made = false}
                            
                            fm.advance(.receive(.playerShotSide))
                        }
                    }
                    
                }

            case .playerShotSide:
                HStack{
                    promptBackButton(action: {fm.advance(.receive(.receiveMade))})
                    Text("Player Side")
                        .font(.title)
                }
                EnumStepButtons(PlayerShotSide.self){value in
                    
                    if serveNumber == 1{
                        fm.currPoint.firstReceive?.shotSide = value
                        
                    } else {
                        fm.currPoint.secondReceive?.shotSide = value
                    }
                    
                    if made {
                        fm.advance(.receive(.receivePosition))
                    } else {
                        fm.advance(.receive(.missedPosition))
                    }
                }

                
            case .receivePosition:
                HStack{
                    promptBackButton(action: {fm.advance(.receive(.playerShotSide))})
                    Text("Receive Position")
                        .font(.title)
                }
                EnumStepButtons(ShotTrajectory.self){value in
                    
                    if serveNumber == 1{
                        fm.currPoint.firstReceive?.trajectory = value
                    } else {
                        fm.currPoint.secondReceive?.trajectory = value
                    }
                    fm.advance(.receive(.receiveOutcome))
                }

            case .missedPosition:
                HStack{
                    promptBackButton(action: {fm.advance(.receive(.playerShotSide))})
                    Text("Missed Position")
                        .font(.title)
                }
                EnumStepButtons(ReceiveMissed.self){value in
        
                    if serveNumber == 1{
                        fm.currPoint.firstReceive?.miss = value
                    } else {
                        fm.currPoint.secondReceive?.miss = value
                        serveNumber = 1
                    }
                    
                    fm.setWinner(.opp)
                    fm.advance(.receive(.notes))
                }
                
            case .receiveOutcome:
                HStack{
                    promptBackButton(action: {fm.advance(.receive(.receivePosition))})
                    Text("Receive Outcome")
                        .font(.title)
                }
                EnumStepButtons(ReceiveOutcome.self){value in
                    
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
                        fm.advance(.receive(.notes))
                    }
                    
                }
                
            case .notes:
                VStack{
                    HStack{
                        promptBackButton(action: {fm.advance(.receive(.receiveMade))})
                        Text("Notes")
                            .font(.title)
                    }
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

//
// RallyFlowView.swift
//

import SwiftUI

struct RallyPromtpingView: View {
    
    let step: rallyPrompts
    @ObservedObject var fm: FlowViewModel
    
    @State private var win: Bool = false
    
    var body: some View {
        
        VStack {
            switch step {
                
            case .rallyOutcome:
                Text("Rally Outcome")
                    .font(.title)
                EnumStepButtons(RallyOutcome.self){ value in
                    if value == .win {win = true} else {win = false}

                    fm.currPoint.rally?.outcome = value
                    fm.advance(.rally(.outComeType))
                }
                
            case .outComeType: // Winner, Forced Error, Unforced Error
                HStack{
                    promptBackButton(action: {fm.advance(.rally(.rallyOutcome))})
                    Text("Outcome Type")
                        .font(.title)
                }
                EnumStepButtons(OutcomeType.self){value in
                    fm.currPoint.rally?.outcomeType = value
                    
                    
                    if win{
                        if value == .unforcedError{
                            fm.setWinner(.curr)
                            fm.advance(.rally(.notes))
                        }
                        else{
                            fm.advance(.rally(.playerShotSide))
                        }
                    }else{
                        if value == .unforcedError{
                            fm.advance(.rally(.playerShotSide))
                        } else {
                            fm.setWinner(.opp)
                            fm.advance(.rally(.notes))
                        }
                    }
                }
                
            case .playerShotSide:
                HStack{
                    promptBackButton(action: {fm.advance(.rally(.outComeType))})
                    Text("Shot Side")
                        .font(.title)
                }
                EnumStepButtons(PlayerShotSide.self){value in
                    fm.currPoint.rally?.playerShotSide = value
                    fm.advance(.rally(.playerPosition))
                }
                
            case .playerPosition:
                HStack{
                    promptBackButton(action: {fm.advance(.rally(.playerShotSide))})
                    Text("Court Position")
                        .font(.title)
                }
                EnumStepButtons(PlayerPosition.self){value in
                    fm.currPoint.rally?.playerPosition = value
                    fm.advance(.rally(.shotType))
                }
                

            case .shotType:
                HStack{
                    promptBackButton(action: {fm.advance(.rally(.playerPosition))})
                    Text("Shot Type")
                        .font(.title)
                }
                EnumStepButtons(ShotType.self){value in
                    fm.currPoint.rally?.type = value
                    fm.advance(.rally(.shotTrajectory))
                }
                
            case .shotTrajectory:
                HStack{
                    promptBackButton(action: {fm.advance(.rally(.shotType))})
                    Text("Shot Direction")
                        .font(.title)
                }
                EnumStepButtons(ShotTrajectory.self){value in
                    fm.currPoint.rally?.trajectory = value
                    
                    if win{
                        fm.setWinner(.curr)
                        fm.advance(.rally(.notes))
                    } else {
                        fm.advance(.rally(.missedPosition))
                    }
                }
                
            case .missedPosition:
                HStack{
                    promptBackButton(action: {fm.advance(.rally(.shotTrajectory))})
                    Text("Missed Position")
                        .font(.title)
                }
                EnumStepButtons(MissedPosition.self){value in
                    fm.currPoint.rally?.missPosition = value
                    fm.setWinner(.opp)
                    fm.advance(.rally(.notes))
                }
                
            case .notes:
                VStack{
                    HStack{
                        promptBackButton(action: {fm.advance(.rally(.rallyOutcome))})
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

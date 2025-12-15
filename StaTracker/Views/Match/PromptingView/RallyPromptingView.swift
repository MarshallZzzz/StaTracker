//
// RallyFlowView.swift
//

import SwiftUI

struct RallyPromtpingView: View {
    
    let step: rallyPrompts
    @ObservedObject var fm: FlowViewModel
    @State private var rally = RallyData()
    
    @State private var win: Bool = false
    
    var body: some View {
        
        VStack {
            switch step {
                
            case .rallyOutcome:
                Text("Rally Outcome")
                    .font(.title)
                EnumStepButtons(RallyOutcome.self){ value in
                    rally.outcome = value
                    fm.updateRally(rally)
                    fm.advance(.rally(.outComeType))
                }
                
                
            case .outComeType: // Winner, Forced Error, Unforced Error
                Text("Outcome Type")
                    .font(.title)
                EnumStepButtons(OutcomeType.self){value in
                    rally.outcomeType = value
                    
                    fm.updateRally(rally)
                    
                    if rally.outcome == .win{
                        if value == .unforcedError{
                            fm.setWinner(.curr)
                            fm.finishPoint()
                        }
                        else{
                            fm.advance(.rally(.playerShotSide))
                        }
                    }else{
                        if value == .unforcedError{
                            fm.advance(.rally(.playerShotSide))
                        } else {
                            fm.setWinner(.opp)
                            fm.finishPoint()
                        }
                    }
                }
                
            case .playerShotSide:
                Text("Shot Side")
                    .font(.title)
                EnumStepButtons(PlayerShotSide.self){value in
                    rally.playerShotSide = value
                    fm.updateRally(rally)
                    fm.advance(.rally(.playerPosition))
                }
                
            case .playerPosition:
                Text("Player Position")
                    .font(.title)
                EnumStepButtons(PlayerPosition.self){value in
                    rally.playerPosition = value
                    fm.updateRally(rally)
                    fm.advance(.rally(.shotType))
                }
                

            case .shotType:
                Text("Shot Type")
                    .font(.title)
                EnumStepButtons(ShotType.self){value in
                    rally.type = value
                    
                    fm.updateRally(rally)
                    
                    fm.advance(.rally(.shotTrajectory))
                }
                
            case .shotTrajectory:
                Text("Shot Trajectory")
                    .font(.title)
                EnumStepButtons(ShotTrajectory.self){value in
                    rally.trajectory = value
                    
                    fm.updateRally(rally)
                    
                    if rally.outcome == .win{
                        fm.setWinner(.curr)
                        fm.finishPoint()
                    } else {
                        fm.advance(.rally(.missedPosition))
                    }
                }
                
            case .missedPosition:
                Text("Missed Position")
                    .font(.title)
                EnumStepButtons(MissedPosition.self){value in
                    rally.missPosition = value
                    fm.updateRally(rally)
                    fm.setWinner(.opp)
                    fm.finishPoint()
                }
                
                
            default:
                EmptyView()
            }
        }
    }
}

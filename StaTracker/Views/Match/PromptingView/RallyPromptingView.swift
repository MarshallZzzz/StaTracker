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
                
                    HStack {
                        stepButton("Win") {
                            //                        vm.log("Rally Outcome", "Unforced Error", flow: "Rally")
                            win = true
                            fm.advance(.rally(.outComeType))
                        }
                        stepButton("Lose") {
                            //                        vm.log("Rally Outcome", "Unforced Error", flow: "Rally")
                            win = false
                            fm.advance(.rally(.outComeType))
                        }
                    }
                
            case .outComeType: // Winner, Forced Error, Unforced Error
                Text("Outcome Type")
                    .font(.title)
                if win{
                    VStack{
                        HStack {
                            outcomeType("Winner")
                            outcomeType("Forced Error")
                        }
                        rallyOutcome("Unforced Error")
                    }
                } else {
                    VStack{
                        HStack {
                            rallyOutcome("Winner")
                            rallyOutcome("Forced Error")
                        }
                        outcomeType("Unforced Error")
                    }
                }
            case .playerPosition:
                Text("Player Position")
                    .font(.title)
                
                VStack {
                    HStack {
                        position("Baseline")
                        position("Mid Court")
                    }
                    position("Net")
                }
                
            case .playerShotSide:
                Text("Shot Side")
                    .font(.title)
                
                HStack {
                    side("Forehand")
                    side("Backhand")
                }

            case .shotType:
                Text("Shot Type")
                    .font(.title)
                
                if win {
                    VStack {
                        HStack {
                            type("Smash")
                            type("Volley")
                        }
                        HStack{
                            type("Drive Volley")
                            type("Approach")
                        }
                        HStack{
                            type("Slice")
                            type("Drop Shot")
                        }
                        HStack{
                            type("Half Volley")
                            type("Lob")
                        }
                        type("Groundstroke")
                    }
                } else {
                    VStack {
                        HStack{
                            missTraj("Smash")
                            missTraj("Volley")
                        }
                        HStack{
                            missTraj("Drive Volley")
                            missTraj("Approach")
                        }
                        HStack {
                            missTraj("Slice")
                            missTraj("Drop Shot")
                        }
                        HStack{
                            missTraj("Half Volley")
                            missTraj("Lob")
                        }
                        missTraj("Groundstroke")
                    }
                }
                
            case .shotTrajectory:
                Text("Shot Trajectory")
                    .font(.title)
                HStack {
                    traj("Cross Court")
                    traj("Down the Line")
                }
                
            case .missedPosition:
                Text("Missed Position")
                    .font(.title)
                
                VStack {
                    HStack {
                        miss("Net")
                        miss("Long")
                    }
                    miss("Wide")
                }
                
            default:
                EmptyView()
            }
        }
    }
    
    private func rallyOutcome(_ outcome: String) -> some View {
        stepButton(outcome) {
//            vm.log("Rally Outcome", outcome, flow: "Rally")
            fm.finishPoint()
        }
    }
    
    private func outcomeType(_ p: String) -> some View {
        stepButton(p) {
            fm.advance(.rally(.playerPosition))
        }
    }
    
    private func position(_ p: String) -> some View {
        stepButton(p) {
//            vm.log("Player Position", p, flow: "Rally")
            fm.advance(.rally(.playerShotSide))
        }
    }
    
    private func side(_ p: String) -> some View {
        stepButton(p) {
//            vm.log("Shot Side", p, flow: "Rally")
            fm.advance(.rally(.shotType))
        }
    }
    
    private func type(_ p: String) -> some View {
        stepButton(p) {
//            vm.log("Shot Type", p, flow: "Rally")
            fm.advance(.rally(.shotTrajectory))
        }
    }
    
    private func traj(_ p: String) -> some View {
        stepButton(p) {
//            vm.log("Trajectory", p, flow: "Rally")
            fm.finishPoint()
        }
    }
    
    private func missTraj(_ p: String) -> some View {
        stepButton(p) {
            fm.advance(.rally(.missedPosition))
        }
    }
    
    private func miss(_ p: String) -> some View {
        stepButton(p) {
//            vm.log("Rally Missed", p, flow: "Rally")
            fm.finishPoint()
        }
    }
}

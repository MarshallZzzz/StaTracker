//
// ServeFlowView.swift
//

import SwiftUI

struct ServePromptingView: View {
    
    let step: servingPrompts
    @ObservedObject var fm: FlowViewModel
    
    //    @State private var serve = ServeData()
    @State private var serveNumber = 1
    @FocusState private var isNotesFocused: Bool
    
    var body: some View {
        ZStack{
            if isNotesFocused {
                Color.clear
                    .contentShape(Rectangle()) // Makes transparent area clickable
                    .onTapGesture {
                        isNotesFocused = false
                    }
            }
            
            VStack {
                switch step {
                    
                case .serveMade:
                    if serveNumber == 1 {
                        Text("First Serve")
                            .font(.title)
                    } else {
                        HStack{
                            Button(action: {withAnimation(.spring())
                                {
                                    fm.advance(.serve(.missedPosition))
                                    serveNumber = 1
                                }}){
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 14, weight: .semibold))
                                        .padding(8) // Space between the icon and the circle border
                                        .background(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 1) // The circular border
                                        )
                                }
                            Text("Second Serve")
                                .font(.title)
                        }
                    }
                    
                    EnumStepButtons(ServeMade.self) { value in
                        
                        if serveNumber == 1 {
                            fm.currPoint.firstServe?.made = value
                        } else{
                            fm.currPoint.secondServe?.made = value
                        }
                        
                        if value == .made{
                            fm.advance(.serve(.serveType))
                        } else{
                            fm.advance(.serve(.missedPosition))
                        }
                    }
                    
                case .serveType:
                    HStack{
                        promptBackButton(action: {fm.advance(.serve(.serveMade))})
                        Text("Serve Type")
                            .font(.title)
                    }
                    EnumStepButtons(ServeType.self) { value in
                        
                        if serveNumber == 1{
                            fm.currPoint.firstServe?.type = value
                        } else {
                            fm.currPoint.secondServe?.type = value
                        }
                        
                        fm.advance(.serve(.servePosition))
                    }
                    
                case .servePosition:
                    HStack{
                        promptBackButton(action: {fm.advance(.serve(.serveType))})
                        Text("Serve Position")
                            .font(.title)
                    }
                    EnumStepButtons(ServePosition.self) { value in
                        
                        if serveNumber == 1{
                            fm.currPoint.firstServe?.madePosition = value
                        } else {
                            fm.currPoint.secondServe?.madePosition = value
                        }
                        
                        fm.advance(.serve(.SROutcome))
                    }
                    
                    
                case .missedPosition:
                    HStack{
                        promptBackButton(action: {fm.advance(.serve(.serveMade))})
                        Text("Missed")
                            .font(.title)
                    }
                    
                    EnumStepButtons(MissedPosition.self){ value in
                        
                        if serveNumber == 1{
                            fm.currPoint.firstServe?.missPosition = value
                            fm.currPoint.secondServe?.resetData()
                            fm.advance(.serve(.serveMade))
                            serveNumber = 2
                        } else {
                            fm.currPoint.secondServe?.missPosition = value
                            fm.setWinner(.opp)
                            serveNumber = 1
                            fm.advance(.serve(.notes))
                        }
                        
                    }
                    
                case .SROutcome:
                    HStack{
                        promptBackButton(action: {fm.advance(.serve(.servePosition))})
                        Text("Outcome")
                            .font(.title)
                    }
                    EnumStepButtons(SROutcome.self) {value in
                        
                        if serveNumber == 1{
                            fm.currPoint.firstServe?.outcome = value
                        } else {
                            serveNumber = 1
                            fm.currPoint.secondServe?.outcome = value
                        }
                        
                        if value == .rally {
                            fm.advance(.rally(.rallyOutcome))
                        } else {
                            fm.setWinner(.curr)
                            fm.advance(.serve(.notes))
                        }
                    }
                    
                case .notes:
                    VStack{
                        HStack{
                            promptBackButton(action: {fm.advance(.serve(.SROutcome))})
                            Text("Notes")
                                .font(.title)
                        }
                        TextField("Add match notes...", text: $fm.currPoint.notes, axis: .vertical)
                            .font(.body)
                        // 1. Reserve vertical space so the whole box is tappable immediately
                            .lineLimit(10, reservesSpace: true)
                        // 2. Ensure text starts at the leading edge
                            .multilineTextAlignment(.leading)
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                            .focused($isNotesFocused)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer() // Pushes button to the right
                                    Button("Done") {
                                        isNotesFocused = false // 3. Dismiss keyboard
                                    }
                                }
                            }
                        PromptButton("Complete Point",action: fm.finishPoint)
                    }
                    
                default:
                    EmptyView()
                }
            }
        }
    }
}

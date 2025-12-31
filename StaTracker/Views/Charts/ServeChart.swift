//
//  ServeChart.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/30/25.
//

import SwiftUI
import Charts

struct ServeChart: View {
    @State var StatEngine: StatEngine
    
    //Serve Parameters
    @State var serveMade: ServeMade = .made
    @State var sMade: ServeMade = .made
    
    //Serve Made
    @State var serveType: ServeType? = nil
    @State var sType: ServeType = .flat
    @State var servePosition: ServePosition? = nil
    @State var serveOutcome: SROutcome? = nil
    
    //Serve Miss
    @State var serveMissPosition: MissedPosition? = nil
    
    
    
    var body: some View {
        HStack{
            VStack{
                Picker("Serve Made", selection: $sMade){
                    ForEach(ServeMade.allCases, id: \.self) { category in
                        Button(action: {
                            // Toggle selection: if already active, set to nil. Else, set to selection.
                            serveMade = (serveMade == category) ? .made : category
                        }) {
                            Text(category.rawValue)
                                .padding(.horizontal)
                                .background(serveMade == category ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(serveMade == category ? .white : .primary)
                                .cornerRadius(20)
                        }
                    }
                    
                }
                .pickerStyle(.menu)
                .padding()
            }
//            VStack{
//                Picker("Serve Type", selection: $sType){
//                    ForEach(ServeType.allCases, id: \.self) { category in
//                        Button(action: {
//                            // Toggle selection: if already active, set to nil. Else, set to selection.
//                            ServeType = (ServeType == category) ? nil : category
//                        }) {
//                            Text(category.rawValue)
//                                .padding(.horizontal)
//                                .background(ServeType == category ? Color.blue : Color.gray.opacity(0.2))
//                                .foregroundColor(ServeType == category ? .white : .primary)
//                                .cornerRadius(20)
//                        }
//                    }
//                    
//                }
//                .pickerStyle(.menu)
//                .padding()
//            }
        }
    }
    
    
}

#Preview{
    let point1 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
    let point2 = Point(server: .curr, firstServe: ServeData(made: .miss), secondServe: ServeData(made: .miss), firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .opp)
    
    var points = [point1, point2]
    let StatEngine = StatEngine(points: points)
    ServeChart(StatEngine: StatEngine)
}


//
//  ServeChart.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/30/25.
//

import SwiftUI
import Charts

struct ServeChart: View {
//    @State var StatEngine: StatEngine
    
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
    
    let FSPercentage = [
        (made: "Made", number: 0.49),
        (made: "Miss", number: 0.51)
    ]
    let SSPercentage = [
        (made: "Made", number: 0.63),
        (made: "Miss", number: 0.37)
    ]
    
    var body: some View {
        GroupBox{
            VStack{
                HStack{
                    Chart(FSPercentage, id: \.made){ made, number in
                        SectorMark(
                            angle: .value("Amount", number),
                            innerRadius: .ratio(0.618),
                            outerRadius: .inset(10),
                            angularInset: 1
                        )
                        .foregroundStyle(by: .value("Serve made", made))
                        .annotation(position: .overlay) {
                            Text("\((number).formatted(.percent.precision(.fractionLength(0))))") // Display number directly
                                .font(.system(size: 10))
                                .foregroundStyle(.black)
                        }
                    }
                    .chartLegend(.hidden)
                    .chartForegroundStyleScale([
                        "Made": .blue,  // Or your preferred primary color
                        "Miss": .gray   // Sets the "miss" sector to gray
                    ])
                    .chartBackground { chartProxy in
                        GeometryReader { geometry in
                            let frame = geometry[chartProxy.plotFrame!]
                            let minDimension = min(frame.width, frame.height)
                            VStack(spacing: minDimension * 0.02) {
                                Text("First")
                                    .font(.system(size: minDimension * 0.15, weight: .bold)) // 15% of chart size
                                    .foregroundColor(.primary)
                                Text("serve %")
                                    .font(.system(size: minDimension * 0.08)) // 8% of chart size
                                    .foregroundStyle(.secondary)
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                    
                    Chart(SSPercentage, id: \.made){ made, number in
                        SectorMark(
                            angle: .value("Amount", number),
                            innerRadius: .ratio(0.618),
                            outerRadius: .inset(10),
                            angularInset: 1
                        )
                        .foregroundStyle(by: .value("Serve made", made))
                        .annotation(position: .overlay) {
                            Text("\((number).formatted(.percent.precision(.fractionLength(0))))") // Display number directly
                                .font(.caption)
                                .foregroundStyle(.black)
                        }
                    }
                    .chartLegend(.hidden)
                    .chartForegroundStyleScale([
                        "Made": .blue,  // Or your preferred primary color
                        "Miss": .gray   // Sets the "miss" sector to gray
                    ])
                    .chartBackground { chartProxy in
                        GeometryReader { geometry in
                            let frame = geometry[chartProxy.plotFrame!]
                            VStack {
                                Text("Second")
                                    .font(.title2.bold())
                                    .foregroundColor(.primary)
                                Text("serve %")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }
                
            }
        } label: {
            Label("Serve", systemImage: "")
                .font(Font.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(10)
        .groupBoxStyle(statGroupBoxStyle())
    }
    
    
}


#Preview{
    let point1 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
    let point2 = Point(server: .curr, firstServe: ServeData(made: .miss), secondServe: ServeData(made: .miss), firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .opp)
    
    var points = [point1, point2]
    let StatEngine = StatEngine(points: points)
    ServeChart()
}


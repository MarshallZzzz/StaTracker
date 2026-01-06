//
//  ServeChart.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/30/25.
//

import SwiftUI
import Charts

struct ServeChart: View {
    @State var stat: StatEngine
    
    init(stat: StatEngine){
        _stat = State(initialValue: stat)
    }
    
    var FSPercentage: [(name: String, number: Double)]{
        [
            (name: "Made", number: stat.serveStats.firstServeInRate),
            (name: "Miss", number: 1 - stat.serveStats.firstServeInRate)
        ]
    }
    var SSPercentage: [(name: String, number: Double)]{
        [
            (name: "Made", number: stat.serveStats.secondServeInRate),
            (name: "Miss", number: 1 - stat.serveStats.secondServeInRate)
        ]
    }

    var FSTypePercentage: [(name: String, number: Double)]{
        [
            (name: "Flat", number: stat.serveStats.firstServeFlat),
            (name: "Kick", number: stat.serveStats.firstServeKick),
            (name: "Slice", number: stat.serveStats.firstServeSlice),
            (name: "Spin", number: stat.serveStats.firstServeSpin)
        ]
    }
    
    var SSTypePercentage: [(name: String, number: Double)]{
        [
            (name: "Flat", number: stat.serveStats.secondServeFlat),
            (name: "Kick", number: stat.serveStats.secondServeKick),
            (name: "Slice", number: stat.serveStats.secondServeSlice),
            (name: "Spin", number: stat.serveStats.secondServeSpin)
        ]
    }
    
    var body: some View {
        ScrollView{
            //        GroupBox{
            VStack{
                HStack(spacing: 20){
                    Chart(FSPercentage, id: \.name){ name, number in
                        SectorMark(
                            angle: .value("Amount", number),
                            innerRadius: .ratio(0.618),
                            outerRadius: .inset(0.5),
                            angularInset: 1
                        )
                        .foregroundStyle(by: .value("Serve made", name))
                        .annotation(position: .overlay) {
                            Text("\((number).formatted(.percent.precision(.fractionLength(0))))") // Display number directly
                                .font(.system(size: 10))
                                .foregroundStyle(.black)
                                .padding(50)
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
                    
                    Chart(SSPercentage, id: \.name){ name, number in
                        SectorMark(
                            angle: .value("Amount", number),
                            innerRadius: .ratio(0.618),
                            outerRadius: .inset(0.5),
                            angularInset: 1
                        )
                        .foregroundStyle(by: .value("Serve made", name))
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
                .frame(height: 200)
                
            }
            
            //Service Points won
            ProgressViewTemplatePercentage(title: "Service Points Won", percentage: stat.serveStats.servicePointsWonRate)
            
            //1st serve points won
            ProgressViewTemplatePercentage(title: "1st Serve Points Won", percentage: stat.serveStats.firstServePointsWonRate)
            
            //2nd serve points won
            ProgressViewTemplatePercentage(title: "2nd Serve Points Won", percentage: stat.serveStats.secondServePointsWonRate)
            
            
            //Break Points Faced
            
            //Break Points Saved?
            
            //Service Games Played
            
            //aces
            ProgressViewInt(title: "Aces", value: stat.serveStats.aces)
            
            // double faults
            ProgressViewInt(title: "Double Fault", value: stat.serveStats.doubleFaults)
            
            PieChartTemplate(title: "1st Serve",subtitle: "Type", data: FSTypePercentage)
            PieChartTemplate(title: "2nd Serve",subtitle: "Type", data: SSTypePercentage)
        }
        
    }
}
//
//
//#Preview{
//    let point1 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
//    let point2 = Point(server: .curr, firstServe: ServeData(made: .miss), secondServe: ServeData(made: .miss), firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .opp)
//    
//    var points = [point1, point2]
//    let StatEngine = StatEngine(points: points)
//    ServeChart(stat: StatEngine)
//}


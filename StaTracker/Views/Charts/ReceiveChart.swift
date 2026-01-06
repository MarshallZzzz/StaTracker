//
//  ReceiveChart.swift
//  StaTracker
//
//  Created by Marshall Zhang on 1/3/26.
//

import Foundation
import SwiftUI
import Charts

struct ReceiveChart: View {
    @State var stat: ReturnStats
    
    init(stat: StatEngine){
        _stat = State(initialValue: stat.returnStats)
    }
    
    var FRMade: [(name: String, number: Double)]{
        [
            (name: "Made", number: stat.firstReturnMadeRate),
            (name: "Miss", number: 1 - stat.firstReturnMadeRate)
        ]
    }
    var SRMade: [(name: String, number: Double)]{
        [
            (name: "Made", number: stat.secondReturnMadeRate),
            (name: "Miss", number: 1 - stat.secondReturnMadeRate)
        ]
    }
    
    var FRMiss: [(name: String, number: Double)]{
        [
            (name: "Net", number: stat.firstReturnNetRate),
            (name: "Long", number: stat.firstReturnLongRate),
            (name: "Wide", number: stat.firstReturnWideRate)
        ]
    }
    var SRMiss: [(name: String, number: Double)]{
        [
            (name: "Net", number: stat.secondReturnNetRate),
            (name: "Long", number: stat.secondReturnLongRate),
            (name: "Wide", number: stat.secondReturnWideRate)
        ]
    }
    
    
    var body: some View {
        VStack{
            HStack(spacing: 20){
                Chart(FRMade, id: \.name){ name, number in
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
                            Text("receive %")
                                .font(.system(size: minDimension * 0.08)) // 8% of chart size
                                .foregroundStyle(.secondary)
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
                
                Chart(SRMade, id: \.name){ name, number in
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
                            Text("receive %")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
            .frame(height: 200)
            
        }
        
        //1st return points won
        ProgressViewTemplatePercentage(title: "1st Return Points Won", percentage: stat.firstReturnPointsWonRate)
        
        //2nd return points won
        ProgressViewTemplatePercentage(title: "2nd Return Points Won", percentage: stat.secondReturnPointsWonRate)
        
        //Return Points Won
        ProgressViewTemplatePercentage(title: "Return Points Won", percentage: stat.returnPointsWonRate)

        //Break Point opportunities
        ProgressViewInt(title: "Break Point Opportunities", value: stat.breakPointOpportunities)

        
        /*---------- Unforced Errors and losses ----------*/
        PieChartTemplate(title: "1st Receive", subtitle: "Misses", data: FRMiss)
        PieChartTemplate(title: "2nd Receive", subtitle: "Misses", data: SRMiss)
        
    }
}
//
//#Preview {
//    ReceiveChart()
//}

//
//  PieChartTemplate.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/29/25.
//

import Charts
import SwiftUI

struct PieChartTemplate: View {
    let title: String
    let subTitle: String
    let data: [(name: String, number: Double)]
    
    init(title: String, subtitle: String, data: [(String, Double)]) {
        self.title = title
        self.subTitle = subtitle
        self.data = data
    }
    

    
    var body: some View{
        if (!data.allSatisfy { $0.number == 0.0 }){
            Chart(data, id: \.name){ name, number in
                SectorMark(
                    angle: .value("Percentage", number),
                    innerRadius: .ratio(0.618), //// -> donut
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("Name", name))
                .annotation(position: .overlay) {
                    Text("\((number).formatted(.percent.precision(.fractionLength(0))))")
                        .font(.caption)
                        .offset(x: 0, y: 5)
                }
            }
            .frame(height: 300)
            .padding(10)
            .chartLegend(alignment: .center, spacing: 16)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    let minDimension = min(frame.width, frame.height)
                    VStack(spacing: minDimension * 0.02) {
                        Text(title)
                            .font(.system(size: minDimension * 0.1, weight: .bold)) // 15% of chart size
                            .foregroundColor(.primary)
                        Text(subTitle)
                            .font(.system(size: minDimension * 0.08)) // 8% of chart size
                            .foregroundStyle(.secondary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        
    }
    
}

#Preview {
    let title = "First Serve Position"
    let firstServe =
    [
        (name: "flat" , percentage: 0.23),
        (name: "slice" , percentage: 0.50),
        (name: "spin" , percentage: 0.12),
        (name: "kick" , percentage: 0.15)
    ]
    
    PieChartTemplate(title: "First Serve", subtitle:"Position", data:firstServe)
}

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
    let data: [(name: String, number: Int)]
    
    init(title: String, data: [(String, Int)]) {
        self.title = title
        self.data = data
    }
    
    var body: some View{
        Chart(data, id: \.name){ name, number in
            SectorMark(
                angle: .value("Percentage", number),
                innerRadius: .ratio(0.618), //// -> donut
                angularInset: 1.5
            )
                .foregroundStyle(by: .value("Name", name))
                .annotation(position: .overlay) {
                    Text(name)
                        .font(.caption)
                        .offset(x: 0, y: 5)
                }
        }
        .chartBackground { chartProxy in
          GeometryReader { geometry in
              let frame = geometry[chartProxy.plotFrame!]
            VStack {

              Text(title)
                .font(.title2.bold())
                .foregroundColor(.primary)
            }
            .position(x: frame.midX, y: frame.midY)
          }
        }
    }
    
}

#Preview {
    let title = "First Serve Position"
    let firstServe =
    [
        (name: "flat" , percentage: 80),
        (name: "slice" , percentage: 50),
        (name: "spin" , percentage: 12),
        (name: "kick" , percentage: 5)
    ]
    
    PieChartTemplate(title: title, data:firstServe)
}

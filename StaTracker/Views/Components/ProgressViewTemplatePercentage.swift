//
//  ProgressViewTemplate.swift
//  StaTracker
//
//  Created by Marshall Zhang on 1/3/26.
//

import Foundation
import SwiftUI
import Charts

struct ProgressViewTemplatePercentage: View {
    var title: String
    var percentage: Double

    
    var body: some View{
        
        VStack{
            HStack {
                Text("\(title)")
                Spacer()
                Text(percentage.formatted(.percent.precision(.fractionLength(0))))
//                                Text(vm.stats.firstServePercentage.formatted(.percent.precision(.fractionLength(0))))
            }
            ProgressView(value: percentage) {//vm.stats.firstServePercentage
            }
            .tint(.green)
            .scaleEffect(x: 1, y: 3, anchor: .center) // Increases height by 3x
            .padding(.vertical, 5) // Adds space for the increased thickness
        }
        
    }
    
}

//
//  ProgressViewTemplate.swift
//  StaTracker
//
//  Created by Marshall Zhang on 1/3/26.
//

import Foundation
import SwiftUI
import Charts

struct ProgressViewInt: View {
    var title: String
    var value: Int

    
    var body: some View{
        
        VStack{
            HStack {
                Text("\(title)")
                Spacer()
                Text("\(value)")
//                                Text(vm.stats.firstServePercentage.formatted(.percent.precision(.fractionLength(0))))
            }
            ProgressView(value: 100) {//vm.stats.firstServePercentage
            }
            .tint(.green)
            .scaleEffect(x: 1, y: 3, anchor: .center) // Increases height by 3x
            .padding(.vertical, 5) // Adds space for the increased thickness
        }
        
    }
    
}

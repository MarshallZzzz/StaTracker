//
//  RallyChart.swift
//  StaTracker
//
//  Created by Marshall Zhang on 1/3/26.
//

import Foundation
import SwiftUI
import Charts

struct RallyChart: View{
    @State var stat: RallyStats
    
    init(stat: StatEngine){
        _stat = State(initialValue: stat.rallyStats)
    }
    
    var rallyData: [(name: String, number: Double)]{
        [
            (name: "Won", number: stat.rallyWinRate),
            (name: "Lose", number: 1 - stat.rallyWinRate),
        ]
    }
    
    var rallyWinType: [(name: String, number: Double)]{
        [
            (name: "Winner", number: stat.winnersRate),
            (name: "Forced Error", number: stat.forcedErrorsRate),
            (name: "Opponent Unforced", number: stat.opponentUnforcedRate)
        ]
    }
    
    var playerPosition: [(name: String, number: Double)]{
        [
            (name: "Baseline", number: stat.baselineRate),
            (name: "No Mans Land", number: stat.noMansLandRate),
            (name: "Net", number: stat.netRate)
        ]
    }
    
    struct sideDirection {
        let side: String
        let direction: String
        let value: Double
    }
    
    let trajectoryData: [sideDirection] = [
        sideDirection(side: "Forehand", direction: "CrossCourt", value: 0.44),
        sideDirection(side: "Forehand", direction: "Down the Line", value: 0.56),
        sideDirection(side: "Backhand", direction: "CrossCourt", value: 0.22),
        sideDirection(side: "Backhand", direction: "Down the Line", value: 0.78)
    ]
//    
//    let shotSide = [
//        (name: "Forehand", number: 0.5),
//        (name: "Backhand", number: 0.5)
//    ]
//    
//    let direction = [
//        (name: "CrossCourt", number: 0.5),
//        (name: "Down the Line", number: 0.5)
//    ]
    
    var body: some View{
        VStack(spacing: 20){
            PieChartTemplate(title: "Total", subtitle: "points won", data: rallyData)
            PieChartTemplate(title: "Winning", subtitle: "type", data: rallyWinType)
            PieChartTemplate(title: "Position", subtitle: "Court", data: playerPosition)
            
            //combine these
//            PieChartTemplate(title: "Side", subtitle: "Player Shot", data: rallyWinType)
//            PieChartTemplate(title: "Direction", subtitle: "Player Shot", data: rallyWinType)
//
            
            // SHOT SIDE AND TRAJECTORY
//            Chart(trajectoryData, id: \.side) {item in
//                BarMark(
//                    x: .value("Shot Side", item.side),
//                    y: .value("Percentage", item.value),
//                    width: .inset(10)
//                )
//                .foregroundStyle(by: .value("Trajectory", item.direction))
//            }
//            .chartLegend(alignment: .center)
            
            
            
            //MISSES
            

        }
        
    }
    
    //WIN TYPE -> winner - forced error - unforced error
    //PLAYER POSITION -> Baseline - nomans - net
    //Win by Forehand or backhand
    //Win by crosscourt or DTL
    
    //Progress bars for shot types - bar graph?
    
    
    /*---------- Unforced Errors and losses ----------*/
}

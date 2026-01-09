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
    
    typealias dataTuple = (name: String, number: Double)
    
    var rallyData: [dataTuple]{
        [
            (name: "Won", number: stat.rallyWinRate),
            (name: "Lose", number: 1 - stat.rallyWinRate),
        ]
    }
    
    //pie chart -> Outcome types(won: winners - forced/unforced errors) / totally rally points won
    var rallyWinType: [dataTuple]{
        [
            (name: "Winner", number: stat.winnersRate),
            (name: "Forced Error", number: stat.forcedErrorsRate),
            (name: "Opponent Unforced", number: stat.opponentUnforcedRate)
        ]
    }
    
    
    //Pie chart -> player positions / total rally points won
    var playerPosition: [dataTuple]{
        [
            (name: "Baseline", number: stat.baselineRate),
            (name: "No Mans Land", number: stat.noMansLandRate),
            (name: "Net", number: stat.netRate)
        ]
    }
//    
    var missedPositions: [dataTuple]{
        [
            (name: "Net Miss", number: stat.netLost),
            (name: "Long Miss", number: stat.longLost),
            (name: "Wide Miss", number: stat.wideLost)
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
            
            
            //unforced erros -
            //pie chart - missed position
            PieChartTemplate(title: "Missed", subtitle: "Position", data: missedPositions)
            
            //progress bar - # of unforced errors / total rally points lost
            ProgressViewTemplatePercentage(title: "Unforced Errors", percentage: stat.unforcedRate)

            //progress bar - backhand / # of unforced errors & forehand / # of unforced errors
            ProgressViewTemplatePercentage(title: "Unforced Forehand Errors", percentage: stat.FHUnforcedRate)
            ProgressViewTemplatePercentage(title: "Unforced Backhand Errors", percentage: stat.BHUnforcedRate)
            
            //Display Specifics
            /*
             SHOT TYPES - GroundStroke, Lob, Slice, DropShot, Half Volley, Approach, Drive Volley, Volley, Smash
             Forehand
                Won by: Winners
                Won by: Forced Errors
                Lost by: Unforced Errors
             
             Backhand
                Won by: Winners
                Won by: Forced Errors
                Lost by: Unforced Errors
                
             
             */
            
            
        }
        
    }
    
    //WIN TYPE -> winner - forced error - unforced error
    //PLAYER POSITION -> Baseline - nomans - net
    //Win by Forehand or backhand
    //Win by crosscourt or DTL
    
    //Progress bars for shot types - bar graph?
    
    
    /*---------- Unforced Errors and losses ----------*/
}

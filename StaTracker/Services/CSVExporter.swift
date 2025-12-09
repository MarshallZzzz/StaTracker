//
//  CSVExporter.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import Foundation

class CSVExporter {

    func export(matches: [Match]) -> String {
        var csv = "matchID,date,pointIndex,wonPoint,firstServeIn,secondServeIn,serveType,rallyLength,outcome\n"

        for match in matches {
            for (index, p) in match.points.enumerated() {
                csv += "\(match.id.uuidString),"
                csv += "\(match.date),"
                csv += "\(index + 1),"
//                csv += "\(p.isServing),"
//                // Serve Data
//                csv += "\(p.serveData?.serveNumber?.rawValue ?? -1),"          // 1st or 2nd serve
//                csv += "\(p.serveData?.made?.rawValue ?? "-"),"                // made / miss
//                csv += "\(p.serveData?.type?.rawValue ?? "-"),"                // flat / slice / kick / spin
//                csv += "\(p.serveData?.madePosition?.rawValue ?? "-"),"            // wide / middle / T
//                csv += "\(p.serveData?.missPosition?.rawValue ?? "-"),"        // net / long / wide
//                csv += "\(p.serveData?.outcome?.rawValue ?? "-"),"             // ace / FE / UFE / rally
//
//                // Receive Data
//                csv += "\(p.receiveData?.made?.rawValue ?? "-"),"
////                csv += "\(p.receiveData?.type?.rawValue ?? "-"),"
//                csv += "\(p.receiveData?.trajectory?.rawValue ?? "-"),"
//                csv += "\(p.receiveData?.miss?.rawValue ?? "-"),"
//                csv += "\(p.receiveData?.outcome?.rawValue ?? "-"),"
//
//                // Rally
//                csv += "\(p.rallyLength ?? 0),"
//                csv += "\(p.rally?.playerPosition?.rawValue ?? "-"),"
//                csv += "\(p.rally?.playerShotSide?.rawValue ?? "-"),"
//                csv += "\(p.rally?.type?.rawValue ?? "-"),"
//                csv += "\(p.rally?.trajectory?.rawValue ?? "-"),"
//                csv += "\(p.rally?.missPosition?.rawValue ?? "-"),"
//
//                // Final outcome
//                csv += "\(p.outcome?.rawValue ?? "N/A"),"
//                csv += "\(p.wonPoint ?? true)\n"
            }
        }

        return csv
    }
}

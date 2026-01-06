//
//  CSVExporter.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class CSVExporter {
    
//    func generateCSV(match: Match) -> String {
//        var csv = "Set,Game,PointNum,Winner,Server,Notes\n"
//        
//        for (index, point) in match.points.enumerated() {
//            // Clean notes: remove commas so they don't break the CSV columns
//            let cleanNotes = (point.notes ?? "").replacingOccurrences(of: ",", with: " ")
//            let row = "\(point.server),\(point.firstServe?.made),\(index + 1),\(cleanNotes)\n"
//            csv.append(row)
//        }
//        return csv
//    }
    func generateCSV(match: Match) -> String{
        var csv = "MatchID,Date,Format,CurrPlayer,OppPlayer\n"
        let matchRow = "\(match.id.uuidString),\(match.date),\(match.format),\(match.currPlayer),\(match.oppPlayer),\(0),\(0),\(0),\(0),\(0),\(0),\(0),\(0)\n"
        
        csv.append(matchRow)
        csv.append("\n")
        
        csv = "PointIndex,GameScore,Serve/Receive,FirstServe,ServeMade,ServeType,ServePosition,MissPosition,ServeOutcome,SecondServe,ServeMade,ServeType,ServePosition,MissPosition,ServeOutcome,FirstReturn,ReturnMade,ReturnSide,ReturnTrajectory,ReturnMiss,ReturnOutcome,SecondReturn,ReturnMade,ReturnSide,ReturnTrajectory,ReturnMiss,ReturnOutcome,Rally,RallyOutcome,OutcomeType,ShotSide,PlayerPosition,ShotType,ShotTrajectory,MissPosition\n"
        for (index, p) in match.points.enumerated(){
            let row = """
            \(index + 1),\
            \(p.gameScore?.displayGameScore() ?? "0 - 0"),\
            \(p.server),\
            \(""),\
            \(p.firstServe?.made?.rawValue ?? ""),\
            \(p.firstServe?.type?.rawValue ?? ""),\
            \(p.firstServe?.madePosition?.rawValue ?? ""),\
            \(p.firstServe?.missPosition?.rawValue ?? ""),\
            \(p.firstServe?.outcome?.rawValue ?? ""),\
            \(""),\
            \(p.secondServe?.made?.rawValue ?? ""),\
            \(p.secondServe?.type?.rawValue ?? ""),\
            \(p.secondServe?.madePosition?.rawValue ?? ""),\
            \(p.secondServe?.missPosition?.rawValue ?? ""),\
            \(p.secondServe?.outcome?.rawValue ?? ""),\
            \(""),\
            \(p.firstReceive?.made?.rawValue ?? ""),\
            \(p.firstReceive?.shotSide?.rawValue ?? ""),\
            \(p.firstReceive?.trajectory?.rawValue ?? ""),\
            \(p.firstReceive?.miss?.rawValue ?? ""),\
            \(p.firstReceive?.outcome?.rawValue ?? ""),\
            \(""),\
            \(p.secondReceive?.made?.rawValue ?? ""),\
            \(p.secondReceive?.shotSide?.rawValue ?? ""),\
            \(p.secondReceive?.trajectory?.rawValue ?? ""),\
            \(p.secondReceive?.miss?.rawValue ?? ""),\
            \(p.secondReceive?.outcome?.rawValue ?? ""),\
            \(""),\
            \(p.rally?.outcome?.rawValue ?? ""),\
            \(p.rally?.outcomeType?.rawValue ?? ""),\
            \(p.rally?.playerShotSide?.rawValue ?? ""),\
            \(p.rally?.playerPosition?.rawValue ?? ""),\
            \(p.rally?.type?.rawValue ?? ""),\
            \(p.rally?.trajectory?.rawValue ?? ""),\
            \(p.rally?.missPosition?.rawValue ?? ""),\
            \n
            """
            csv.append(row)
            
        }
        return csv
    }

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

// The "Document" wrapper iOS uses to understand what it's saving
struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    var text: String

    init(text: String = "") {
        self.text = text
    }

    // Required initializer for reading (usually empty for simple exports)
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else { text = "" }
    }

    // Tells iOS how to write the data to a file
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

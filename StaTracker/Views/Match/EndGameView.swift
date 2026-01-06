//
//  EndGameView.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/12/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct EndGameView: View {
    @StateObject var vm: MatchViewModel
    
    @State private var isExporting = false
    @State private var csvDocument: CSVDocument?
    
    private enum Metrics {
        static let mainSpacing: CGFloat = 10
        static let gameScoreSize: CGFloat = 100
        static let separatorWidth: CGFloat = 50
        static let separatorHeight: CGFloat = 2
        static let setColumnWidth: CGFloat = 40
        static let checkEmojiSize: CGFloat = 10
        static let cornerRadius: CGFloat = 25
    }
    
    
    var body: some View {
        ScrollView{
            VStack(spacing: Metrics.mainSpacing) {
                
                //Header Match Complete
                VStack{
                    Text("Match Analysis")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    Text("\(vm.match.date.formatted(.dateTime.month(.twoDigits).day(.twoDigits).year()))")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                // Score display Module
                setsHistory
                
                //Overall Performance Stat display
                GroupBox{
                    VStack{
                        ProgressViewTemplatePercentage(title: "1st Serve %", percentage: vm.stats.serveStats.firstServeInRate)
                        ProgressViewTemplatePercentage(title: "2nd Serve %", percentage: vm.stats.serveStats.secondServeInRate)
                        ProgressViewTemplatePercentage(title: "Points Won", percentage: vm.stats.rallyStats.rallyWinRate)
                    }
                } label: {
                    Label("Overall Performance", systemImage: "sport.tennis")
                        .foregroundStyle(.black)
                }
                .groupBoxStyle(statGroupBoxStyle())
                .padding(10)
                
                //Insert Serve View
                GroupBox{
                    ServeChart(stat: vm.stats)
                } label: {
                    Label("Serve", systemImage: "")
                        .font(Font.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(10)
                .groupBoxStyle(statGroupBoxStyle())
                
                GroupBox{
                    ReceiveChart(stat: vm.stats)
                } label: {
                    Label("Receive", systemImage: "")
                        .font(Font.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(10)
                .groupBoxStyle(statGroupBoxStyle())
                
                GroupBox{
                    RallyChart(stat: vm.stats)
                } label: {
                    Label("Rally", systemImage: "")
                        .font(Font.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(10)
                .groupBoxStyle(statGroupBoxStyle())
                // Receive View
                // Rally View
                
                //Finishing buttons
                Button(action: {
                    // 1. Generate the CSV text
                    let service = CSVExporter()
                    let csvString = service.generateCSV(match: vm.match)
                    
                    // 2. Wrap it in the document and trigger exporter
                    self.csvDocument = CSVDocument(text: csvString)
                    self.isExporting = true
                }) {
                    Text("Generate Match CSV")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                // 3. The modifier that "opens" the save dialog
                .fileExporter(
                    isPresented: $isExporting,
                    document: csvDocument,
                    contentType: .commaSeparatedText,
                    defaultFilename: "MatchResults.csv"
                ) { result in
                    switch result {
                    case .success(let url):
                        print("Saved to \(url)")
                    case .failure(let error):
                        print("Export failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var setsHistory: some View {
        if !vm.match.score.sets.isEmpty {
            GroupBox("Final Score"){

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 10) {
                        headerSpacer
                        playerNameLabel(vm.currPlayer, vm.match.winner == .curr)
                        playerNameLabel(vm.oppPlayer, vm.match.winner == .opp)
                    }
                    
                    Spacer()
                    
                    ForEach(Array(vm.match.score.sets.enumerated()), id: \.offset) { index, set in
                        setRow(index: index, set: set)
                    }
                }
            }
            .padding(10)
            .groupBoxStyle(statGroupBoxStyle())
        }
    }
    
    private func setRow(index: Int, set: SetScore) -> some View {
        // Set scores column
        VStack(spacing: 10) {
            Text("Set \(index + 1)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
//                .foregroundStyle(.black.opacity(0.6))
            
            if set.tieBreak != nil && set.tieBreak!.winAt == 10 {
                setSuperTieBreakLabel(set.tieBreak!.currPlayerPoints)
                setSuperTieBreakLabel(set.tieBreak!.oppPlayerPoints)
            } else{
                setScoreLabel(set.currPlayerGames, set.tieBreak, .curr)
                setScoreLabel(set.oppPlayerGames, set.tieBreak, .opp)
            }
            
        }
        .frame(width: Metrics.setColumnWidth)
    }
    
    private var headerSpacer: some View {
        Text("")
            .font(.subheadline)
    }
    
    private func playerNameLabel(_ name: String, _ isWinner: Bool) -> some View {
        HStack{
            Text(name)
                .font(.headline)
                .foregroundStyle(.black.opacity(0.9))
            Text("✅")
                .font(.system(size: Metrics.checkEmojiSize))
                .opacity(isWinner ? 1 : 0)
        }
    }
    
    private func setSuperTieBreakLabel(_ score: Int) -> some View {
        Text("\(score)")
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.black)
            .frame(width: Metrics.setColumnWidth)
    }
    
    private func setScoreLabel(_ score: Int, _ tieBreakScore: TieBreakScore? = nil, _ player: Player) -> some View {
        Text("\(score)")
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.black)
            .frame(width: Metrics.setColumnWidth)
            .overlay(alignment: .topTrailing) { // Use .overlay with alignment
                if tieBreakScore != nil{
                    if player == .curr {
                        Text("\(tieBreakScore!.currPlayerPoints)")
                            .font(.caption2) // Use a much smaller font for the tie break
                            .foregroundStyle(.black)
                            .padding([.top, .trailing], 2) // Add small padding to position it inside the frame
                    } else {
                        Text("\(tieBreakScore!.oppPlayerPoints)")
                            .font(.caption2) // Use a much smaller font for the tie break
                            .foregroundStyle(.black)
                            .padding([.top, .trailing], 2) // Add small padding to position it inside the frame
                    }
                }
            }
    }
}

struct statGroupBoxStyle: GroupBoxStyle{
    func makeBody(configuration: Configuration) -> some View {
        VStack{
            configuration.label
                .font(.headline)
                .foregroundColor(.primary)
            configuration.content
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white) // White background
                .stroke(Color.black.opacity(0.3), lineWidth: 1) // Darker stroke
        )
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)) // Ensure the shadow applies to the rounded shape
        // Add the shadow modifier to the entire view
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Subtle shadow
    }
}
#Preview{
    var vm = MatchViewModel(currPlayer: "Roger Federer", oppPlayer: "Rafael Nadal", server: .curr, selectedFormat: .defaultFormat)
    EndGameView(vm: vm)
}

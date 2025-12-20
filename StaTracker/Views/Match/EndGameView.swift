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
        static let mainSpacing: CGFloat = 20
        static let gameScoreSize: CGFloat = 100
        static let separatorWidth: CGFloat = 50
        static let separatorHeight: CGFloat = 2
        static let setColumnWidth: CGFloat = 40
        static let checkEmojiSize: CGFloat = 10
        static let cornerRadius: CGFloat = 25
    }
    
    
    var body: some View {
        ZStack{
            VStack(spacing: Metrics.mainSpacing) {
                
                //Header Match Complete
                Text("Match Complete")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.black)
                
                // Score display Module
                setsHistory
                
                //Match Stats Module
                Text("Match Stats")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.black)
                
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
            VStack{
                Text("Final Score")
                    .font(.title)
                
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
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: Metrics.cornerRadius)
                    .fill(.black.opacity(0.08))
                    .padding(.horizontal, 6)
            )
        }
    }
    
    private func setRow(index: Int, set: SetScore) -> some View {
        // Set scores column
        VStack(spacing: 10) {
            Text("Set \(index + 1)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black.opacity(0.6))
            
            setScoreLabel(set.currPlayerGames)
            setScoreLabel(set.oppPlayerGames)
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
    
    private func setScoreLabel(_ score: Int) -> some View {
        Text("\(score)")
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.black)
            .frame(width: Metrics.setColumnWidth)
    }

}

#Preview{
    var vm = MatchViewModel(currPlayer: "Roger Federer", oppPlayer: "Rafael Nadal", server: .curr, selectedFormat: .defaultFormat)
    EndGameView(vm: vm)
}

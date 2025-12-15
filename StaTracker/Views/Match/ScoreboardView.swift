//
//  ScoreboardView.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/9/25.
//

import Foundation
import SwiftUI

struct ScoreboardView: View {
    @ObservedObject var vm: MatchViewModel

    
    // MARK: - Constants
    
    private let scoreMap: [Int: String] = [
        0: "0",
        1: "15",
        2: "30",
        3: "40",
    ]
 
    
    private enum Metrics {
        static let mainSpacing: CGFloat = 20
        static let gameScoreSize: CGFloat = 100
        static let separatorWidth: CGFloat = 50
        static let separatorHeight: CGFloat = 2
        static let setColumnWidth: CGFloat = 40
        static let tennisEmojiSize: CGFloat = 20
        static let cornerRadius: CGFloat = 12
    }
    
    // MARK: - Body
    
    var body: some View {
         VStack(spacing: Metrics.mainSpacing) {
             currentGameScore
             setsHistory
         }
         .padding()
         .onAppear {
             initializeGameIfNeeded()
         }
     }
    
    private func initializeGameIfNeeded() {
         // Check if we need to create the first set and game
         if vm.match.score.sets.isEmpty {
             let newGame = GameScore(gameType: vm.selectedFormat.scoringType)
             var newSet = SetScore(format: vm.match.format)
             newSet.games.append(newGame)
             vm.match.score.sets.append(newSet)
         }
         
         // Check if the current set needs a game
         if let currentSet = vm.match.score.sets.last,
            currentSet.games.isEmpty {
             let newGame = GameScore(gameType: vm.selectedFormat.scoringType)
             vm.match.score.sets[vm.match.score.sets.count - 1].games.append(newGame)
         }
     }
     // MARK: - Current Game Score
     
     @ViewBuilder
     private var currentGameScore: some View {
         if let currentSet = vm.match.score.sets.last,
            let currentGame = currentSet.games.last {
             VStack(spacing: 16) {
                 sectionHeader(title: "Game Score")
                 
                 HStack(spacing: 24) {

                     if vm.selectedFormat.scoringType == .ad && currentGame.currPlayerPoints == 3 && currentGame.oppPlayerPoints == currentGame.currPlayerPoints {
                         setDeuce(difference: currentGame.currPlayerPoints - currentGame.oppPlayerPoints)
                     } else{
                         playerGameScore(
                            name: vm.currPlayer,
                            score: scoreMap[currentGame.currPlayerPoints] ?? "0",
                            isServing: vm.match.server == .curr
                         )
                         
                         scoreSeparator
                         
                         playerGameScore(
                            name: vm.oppPlayer,
                            score: scoreMap[currentGame.oppPlayerPoints] ?? "0",
                            isServing: vm.match.server == .opp
                         )
                     }
                     
                 }
             }
             .padding(.bottom, 8)
         }
         
     }
    
    private func getCurrentOrCreateSet() -> SetScore {
        if let lastSet = vm.match.score.sets.last {
            return lastSet
        } else {
            // Create first set
            let newSet = SetScore(format: vm.match.format)
            vm.match.score.sets.append(newSet)
            return newSet
        }
    }
    
    private func getCurrentOrCreateGame(in set: SetScore) -> GameScore {
        if let lastGame = set.games.last {
            return lastGame
        } else {
            // Create first game
            let newGame = GameScore(gameType: vm.selectedFormat.scoringType)
            if let index = vm.match.score.sets.firstIndex(where: { $0.id == set.id }) {
                vm.match.score.sets[index].games.append(newGame)
            }
            return newGame
        }
    }
     
    private func playerGameScore(name: String, score: String, isServing: Bool) -> some View {
         VStack(spacing: 8) {
             Text(name)
                 .font(.title3)
                 .fontWeight(.semibold)
                 .foregroundStyle(.white.opacity(0.8))
             
             Text(score)
                 .font(.system(size: Metrics.gameScoreSize, weight: .bold))
                 .foregroundStyle(.white)
             
             Text("🎾")
                 .font(.system(size: Metrics.tennisEmojiSize))
                 .opacity(isServing ? 1 : 0)
         }
     }
     
     private var scoreSeparator: some View {
         Rectangle()
             .fill(.white.opacity(0.3))
             .frame(width: Metrics.separatorWidth, height: Metrics.separatorHeight)
     }
    // MARK: - Sets History
    
    @ViewBuilder
    private var setsHistory: some View {
        if !vm.match.score.sets.isEmpty {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    headerSpacer
                    playerNameLabel(vm.currPlayer)
                    playerNameLabel(vm.oppPlayer)
                }
                
                Spacer()
                
                ForEach(Array(vm.match.score.sets.enumerated()), id: \.offset) { index, set in
                    setRow(index: index, set: set)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: Metrics.cornerRadius)
                    .fill(.white.opacity(0.08))
            )
        }
    }
    
    private func setRow(index: Int, set: SetScore) -> some View {
        // Set scores column
        VStack(spacing: 10) {
            Text("Set \(index + 1)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.6))
            
            setScoreLabel(set.currPlayerGames)
            setScoreLabel(set.oppPlayerGames)
        }
        .frame(width: Metrics.setColumnWidth)
        //        }
    }
    
    private var headerSpacer: some View {
        Text("")
            .font(.subheadline)
    }
    
    private func playerNameLabel(_ name: String) -> some View {
        Text(name)
            .font(.headline)
            .foregroundStyle(.white.opacity(0.9))
    }
    
    private func setScoreLabel(_ score: Int) -> some View {
        Text("\(score)")
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(width: Metrics.setColumnWidth)
    }
    
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.white.opacity(0.8))
    }
    
    private func setDeuce(difference: Int) -> some View{

        if difference == 1 { // curpplayer is up
            Text("Ad - In")
                .font(.system(size: Metrics.gameScoreSize, weight: .bold))
                .foregroundStyle(.white)
        } else if difference == -1 { // curpplayer is up
            Text("Ad - Out")
                .font(.system(size: Metrics.gameScoreSize, weight: .bold))
                .foregroundStyle(.white)
        } else {
            Text("Deuce")
                .font(.system(size: Metrics.gameScoreSize, weight: .bold))
                .foregroundStyle(.white)
        }
        
    }
}

// MARK: - Supporting Types

struct SetScores {
    let currPlayerGames: Int
    let oppPlayerGames: Int
}

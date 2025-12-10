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
    @State var server: ServingPlayer
    
    let scoreMap: [Int: String] = [0: "0", 1: "15", 2: "30", 3: "40"]

    var body: some View {
        VStack(spacing: 12) {
            
            if let currentSet = vm.match.score.sets.last,
               let currentGame = currentSet.games.last {
                VStack {
                    Text("Game Score")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.8))
                    HStack{
                        VStack(spacing: 0) {
                            Text("\(vm.currPlayer)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.8))
                            
                            //
                            Text("\(scoreMap[currentGame.currPlayerPoints] ?? "0")")
                                .font(.system(size: 100, weight: .bold))
                                .foregroundStyle(.white)
                            
                            Text("🎾")
                                .font(.system(size: 20))
                                .opacity(server == .curr ? 1 : 0)
                            
                        }
                        Rectangle()
                            .fill(.white.opacity(0.5))
                            .frame(height: 2)
                            .frame(maxWidth: 50)
                        VStack(spacing: 0) {
                            Text("\(vm.oppPlayer)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.8))
                            
                            //
                            Text("\(scoreMap[currentGame.oppPlayerPoints] ?? "0")")
                                .font(.system(size: 100, weight: .bold))
                                .foregroundStyle(.white)
                            
                            Text("🎾")
                                .font(.system(size: 20))
                                .opacity(server == .opp ? 1 : 0)
                            
                        }
                    }
                    
                }
            }
        }
        .padding()

            ForEach(Array(vm.match.score.sets.enumerated()), id: \.offset) { index, set in
                VStack {
//                    Text("Set \(index + 1)")
//                        .fontWeight(.semibold)
//                        .foregroundStyle(.white.opacity(0.8))
                    
                    // Display games inline, ensuring alignment
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text("")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.8))
                            Text("\(vm.currPlayer)")
                                .font(.headline)
//                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.8))
                            Text("\(vm.oppPlayer)")
                                .font(.headline)
//                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        Spacer()
                        VStack{
                            Text("Set \(index + 1)")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.8))
                            
                            Text("\(set.currPlayerGames)")
                                .font(.headline)
                                .frame(width: 30) // Aligns with the current player's name
                                .foregroundStyle(.white.opacity(0.8))
                            Text("\(set.oppPlayerGames)")
                                .font(.headline)
                                .frame(width: 30) // Aligns with the opponent's name
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }
                .padding(.horizontal)
            }
    }
}

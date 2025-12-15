//
//  MatchView.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import Foundation
import SwiftUI

struct MatchView: View {
    
    //privat states - owned by this matchview
    @State private var yourPlayer: String = ""
    @State private var yourOpponent: String = ""
    
    @State private var selectedFormat: String = ""
    
    //viewmodel vars
//    @State private var gameFormat: MatchFormat
    
    //state
    @State private var setFormat: setFormat = .fast4
    @State private var ad: ScoringType = .ad
    @State private var finale: FinalSetFormat = .regularSet
    @State private var server: Player = .curr
    
    //UI
    @State private var areAdsEnabled: Bool = true
    @State private var isFinalSet: Bool = true
    @State private var navigateToGame = false

    
    private var adTitle: String {areAdsEnabled ? "Ads" : "No Ads"}
    
    // Assuming finalSet is meant to be a string and its value depends on isFinalSet
    private var finalSet: String {isFinalSet ? "Regular Set" : "Tie Breaker"}
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.08, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Creating New Match")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    
                    Text("Set up your match details")
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                
                // Scrollable Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Your Player Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Player")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                            
                            TextField("Enter player name", text: $yourPlayer)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.15, green: 0.15, blue: 0.2))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .tint(.cyan)
                        }
                        
                        // Your Opponent Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Opponent")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                            
                            TextField("Enter opponent name", text: $yourOpponent)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.15, green: 0.15, blue: 0.2))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .tint(.cyan)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ads & Final Set Settings")
                                .font(.headline)
                                .foregroundColor(.white) // <-- Makes the title text white
                            // ✅ FIX: Ads and Final set now side-by-side in HStack
                            HStack(spacing: 20) { // Using HStack for horizontal layout
                                // 💡 Toggle 1: Ads
                                Toggle(adTitle, isOn: $areAdsEnabled)
                                    .toggleStyle(.switch)
                                    .tint(.purple)
                                    .foregroundColor(.white)
                                    .onChange(of: areAdsEnabled) { newValue in
                                        ad = newValue ? .ad : .noAd
                                    }
                                
                                // 💡 Toggle 2: Final set
                                Toggle(finalSet, isOn: $isFinalSet)
                                    .toggleStyle(.switch)
                                    .tint(.green)
                                    .foregroundColor(.white)
                                    .onChange(of: isFinalSet) { newValue in
                                        finale = newValue ? .regularSet : .matchTiebreak
                                    }
                                
                            }

                        }
                        // ⚠️ Removed the Text debugging view to avoid layout issues in the HStack
                        // If you need the debugging text, place it below this HStack inside the parent VStack
                        // Match Format Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Match Scoring")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 10) {
                                // Fast 4
                                MatchFormatButton(
                                    title: "Fast 4",
                                    isSelected: setFormat == .fast4,
                                    action: {  setFormat = .fast4 }
                                )
                                
                                // 6 Game Pro Set
                                MatchFormatButton(
                                    title: "6 Game Pro Set",
                                    isSelected: setFormat == .stdSet,
                                    action: { setFormat = .stdSet }
                                )
                                
                                // 8 Game Pro Set
                                MatchFormatButton(
                                    title: "8 Game Pro Set",
                                    isSelected: setFormat == .proSet,
                                    action: { setFormat = .proSet }
                                )
                                
                                // Best Out of 3
                                MatchFormatButton(
                                    title: "Best Out of 3",
                                    isSelected: setFormat == .bestOf3,
                                    action: { setFormat = .bestOf3 }
                                )
                                
                                // Best Out of 5
                                MatchFormatButton(
                                    title: "Best Out of 5",
                                    isSelected: setFormat == .bestOf5,
                                    action: { setFormat = .bestOf5 }
                                )
                            }
                        }
                        VStack(spacing: 20){
                            Text("Service")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                            HStack(spacing: 20){
                                
                                MatchFormatButton(
                                    title: "Your Player",
                                    isSelected: server == .curr,
                                    action:{ server = .curr}
                                )
                                MatchFormatButton(
                                    title: "Your Opponent",
                                    isSelected: server == .opp,
                                    action:{ server = .opp}
                                )
                            }
                        }
                        
                        //create match format first and pass in the match format into the VM
                        NavigationLink(
                            destination: InGameView(
                                vm: MatchViewModel( // Initialize the VM here with the final data
                                    currPlayer: yourPlayer,
                                    oppPlayer: yourOpponent,
                                    server: server,
                                    selectedFormat: MatchFormat(scoringType: ad, setFormat: setFormat, finalSetFormat: finale )),
                                fm: FlowViewModel(server: server),
                                server: server
                            ),
                            isActive: $navigateToGame,
                            label: { EmptyView() } // Hide the link
                        )
                        // Start Match Button
                        Button(action: {
                            navigateToGame = true
                        }) {
                            Text("Start Match")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.cyan,
                                            Color.blue
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
            }
        }
    }
}

// Match Format Button Component
struct MatchFormatButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.cyan)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                isSelected ?
                Color(red: 0.0, green: 0.5, blue: 0.7).opacity(0.2) :
                    Color(red: 0.15, green: 0.15, blue: 0.2)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.cyan : Color.clear,
                        lineWidth: 1.5
                    )
            )
        }
    }
}


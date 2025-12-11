//
//  MatchViewModel.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/1/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MatchViewModel: ObservableObject {
    @Published var match: Match
    @Published var server: ServingPlayer
    
    let currPlayer: String
    let oppPlayer: String
    let selectedFormat: MatchFormat

    
    init(currPlayer: String, oppPlayer: String, server: ServingPlayer, selectedFormat: MatchFormat) {
        self.currPlayer = currPlayer
        self.oppPlayer = oppPlayer
        self.selectedFormat = selectedFormat
        self.server = server
        self.match = Match(currPlayer: currPlayer, oppPlayer: oppPlayer, format: selectedFormat)
    }
    

    func savePoint(_ point: Point) {
        match.addPoint(point)
        print("Saved point!")
        processScoring(point)
    }
    
    func updateServer(server: ServingPlayer){
        self.server = server
    }
    
    private func processScoring(_ point: Point){
        //1. Identify winner
        let winner = point.playerWon
        
        //2. Get current Set
        var currentSet = match.score.sets.last!
        
        //3. get or create current game
        if currentSet.games.isEmpty {
            currentSet.games.append(GameScore(format: selectedFormat, server: server, currPlayerPoints: 0, oppPlayerPoints: 0))
        }
        
        var currentGame = currentSet.games.last!
        
        //4. Apply point to Game
        if winner == .currPlayer {
            currentGame.currPlayerScored()
        } else{
            currentGame.oppPlayerScored()
        }
        
        currentSet.games[currentSet.games.count - 1] = currentGame

        //5. Check if game is won
        if isGameOver(game: currentGame) {
            finalizeGame(wonBy: winner!, in: &currentSet)
        }
        
        //6. Replace Updated Set
        match.score.sets[match.score.sets.count - 1] = currentSet
    }
    
    
    //add the format to ensure sets follow rules
    private func finalizeGame(wonBy winner: Winner, in set: inout SetScore) {
        if winner == .currPlayer {
            set.currPlayerGames += 1
        } else {
            set.oppPlayerGames += 1
        }
        
        switchServerAfterGame()

        if set.isSetComplete(format: match.format) {
            // Set has a winner
            print("IN SET COMPLETE!!!")
            //check if Match is over
            if match.score.isMatchOver(){
                //display win?
                print("MATCH OVAAAA!")
            }
            else{
                match.score.createNewSet()
            }
            
//            if set.winner == .currPlayer || set.winner == .oppPlayer {
//                Move to next set if match not over
//                                        if !match.score.isMatchOver() {
//                    match.score.sets.append(SetScore(format: match.format))
//                }
//            }
        }

        // start new game
        set.games.append(GameScore(format: selectedFormat,
                                   server: server,
                                   currPlayerPoints: 0,
                                   oppPlayerPoints: 0))
    }
    
    private func isGameOver(game: GameScore) -> Bool {
        let p1 = game.currPlayerPoints
        let p2 = game.oppPlayerPoints
        
        switch match.format.scoringType {
        case .noAd:
            // At deuce → next point wins
            return p1 >= 4 || p2 >= 4
        case .ad:
            // Win by 2, but games essentially end at “Game Over”
            if p1 >= 4 || p2 >= 4 {
                return abs(p1 - p2) >= 2
            }
            return false
        }
    }
    
    private func switchServerAfterGame() {
        server = server == .curr ? .opp : .curr
    }
}





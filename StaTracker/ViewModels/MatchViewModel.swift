//
//  MatchViewModel.swift
//  StaTracker

// MANAGE THE FLOW OF THE MATCH STATE
// HOW TO  PRESENT THE MODEL DATA?
//
//  Created by Marshall Zhang on 12/1/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MatchViewModel: ObservableObject {
    @Published var match: Match
    @Published var server: Player
    
    let currPlayer: String
    let oppPlayer: String
    let selectedFormat: MatchFormat

    
    init(currPlayer: String, oppPlayer: String, server: Player, selectedFormat: MatchFormat) {
        self.currPlayer = currPlayer
        self.oppPlayer = oppPlayer
        self.selectedFormat = selectedFormat
        self.server = server
        self.match = Match(currPlayer: currPlayer, oppPlayer: oppPlayer, startingServer: server, format: selectedFormat)
    }
    
    func updateServer(server: Player){
        self.server = server
    }

    func savePoint(_ point: Point) {
//        match.addPoint(point)
        print("Saved point!")
        processScoring(point)
    }
    
    
    private func processScoring(_ point: Point){
        //1. Identify winner
        let winner = point.playerWon
        
        //2. Get current Set
        var currentSet = match.score.sets.last!
        
        //3. get or create current game
        if currentSet.games.isEmpty {
            currentSet.games.append(GameScore(gameType: selectedFormat.scoringType))
        }
        
        var currentGame = currentSet.games.last!
        
        //4. Apply point to Game
        if winner == .curr {
            currentGame.currPlayerScored()
        } else{
            currentGame.oppPlayerScored()
        }
        
        currentSet.games[currentSet.games.count - 1] = currentGame

        //5. Check if game is won
        if isGameOver(game: currentGame) {
            finalizeGame(wonBy: winner!, in: &currentSet)
        }
        
        
        if currentSet.isSetComplete(format: match.format) {
            currentSet.winner = winner
            match.score.sets[match.score.sets.count - 1] = currentSet
            
            //check if Match is over
            if match.score.isMatchOver(){
                //display win?
                print("MATCH OVAAAA!")
            }
            else{
//                match.score.createNewSet()
                print("Match not over")
            }
        }
        
        match.score.sets[match.score.sets.count - 1] = currentSet
    }
    
    //add the format to ensure sets follow rules
    private func finalizeGame(wonBy winner: Player, in set: inout SetScore) {
        if winner == .curr {
            set.currPlayerGames += 1
        } else {
            set.oppPlayerGames += 1
        }
        
        print("\(set.currPlayerGames) : \(set.oppPlayerGames)")
        
        switchServerAfterGame()
        
//        // start new game
//        set.games.append(GameScore(server: server,
//                                   ads: selectedFormat.scoringType,
//                                   currPlayerPoints: 0,
//                                   oppPlayerPoints: 0))
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





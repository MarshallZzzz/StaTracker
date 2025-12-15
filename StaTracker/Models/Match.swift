//
//  Match.swift
// SHOULD HANDLE GAME ENGINE LOGIC
//  StaTracker
//
//  Created by Marshall Zhang on 11/26/25.
//

import Foundation

struct Match: Identifiable, Codable {
    let id = UUID()

    //initializing variables
    let currPlayer: String
    let oppPlayer: String
    var server: Player
    let format: MatchFormat //the match format
    
    //defaulted variables
    var score: MatchScore //the collection of scores
    var points: [Point] //collection of all the points
    let date: Date//the date
    
    init(currPlayer: String, oppPlayer: String, startingServer: Player, format: MatchFormat) {
        //initialized
        self.currPlayer = currPlayer
        self.oppPlayer = oppPlayer
        self.server = startingServer
        self.format = format
        
        //defaulted variables
        self.score = MatchScore(format: format)
        self.points = []
        self.date = Date()
    }

    
//    -> processScoring
//        1. Identify Winner
//        2. Get Current Set
//        3. Get current Game or create new game for onAppear
//        4. Apply point to game w/ update
//        5.
    //    if game is won{
    //        add game to set
    //        if set is won{
    //            add set to match
    //            if match is won{
    //                break out
    //            }
    //            finalize set: create new Set
    //        }
    //        finalize game: switch serve and create new game
    //    }
    
    mutating func addPoint(_ point: Point) {
        points.append(point)
        
        let winner = point.playerWon
        
        //set current Set
        guard var currentSet = score.sets.last else {
            print("Error: Cannot find the current set to score in.")
            return
        }
        
//        //check if game is empty -> usually for first game
//        if currentSet.games.isEmpty{
//            //append game
//            currentSet.games.append(GameScore(gameType: format.scoringType))
//        }
        
        finalizeGame(wonBy: winner!, in: &currentSet)
        
    }
    
    //applying point & check if game is over
    /*
     1. Get current game
     2. Add a point to the player that won
     3. Check if game is over - isGameOver()
        if game is over
            append this game to set
        
            if set is over
                append the set to match
     
                if match IS over
                    get match winner
                if match NOT over
                    create new set with a new game
     
            if set not over
                create new game
     
            switch server - within isGameOver is true
     
     */
    mutating func finalizeGame(wonBy winner: Player, in currentSet: inout SetScore){
        //functiong game checker
        //applying point to game
        guard var currentGame = currentSet.games.last else{
            print("Error: No game found")
            return
        }
        
        if winner == .curr{
            currentGame.currPlayerScored()
        } else { currentGame.oppPlayerScored()}

        //update current game
        currentSet.games[currentSet.games.count - 1] = currentGame
        score.sets[score.sets.count - 1] = currentSet
        print("I'm here with: \(currentGame.currPlayerPoints)")
        print("Checing Match machine: \(score.sets[score.sets.count - 1])")
        
        //check if game is over
        if currentGame.isGameOver(){
            
            //apply game score to set
            if winner == .curr{
                currentSet.currGameWon()
            } else { currentSet.oppGameWon()}
            
            if currentSet.isSetComplete(format: format){        //check if set is over
                
                if score.isMatchOver(){                         //check if match is over
                    score.getMatchWinner()                      //get match winner
                }
                score.createNewSet(format: format)              //creates set and game
            } else {
                currentSet.games.append(GameScore(gameType: format.scoringType))    //create new game once game is over
            }
            switchServerAfterGame()
        }
    }
    
    mutating func switchServerAfterGame() {
        server = server == .curr ? .opp : .curr
    }
}

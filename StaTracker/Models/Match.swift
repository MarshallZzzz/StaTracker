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
    let date: Date//the date

    //initializing variables
    let currPlayer: String
    let oppPlayer: String
    var server: Player
    let format: MatchFormat //the match format
    
    //defaulted variables
    var score: MatchScore //the collection of scores
    var points: [Point] //collection of all the points
    var winner: Player? = nil
    
    //set's flag
    var inTieBreak: Bool = false
    var setComplete: Bool = false
    var matchComplete: Bool = false
    
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

    
/*
 Concept function flow - add point
 
 func add point
    1. append point to the match.points array
    2. save the winner of that point for updating scores
 
 func apply point to the correct player of the game
    4. update game
 
    5. check if game is over
        if game NOT over -> return out
        if IS over
            -> apply game to the set
            -> 6
 
 
    6. check if set is over
        if set Not over -> return out
        
    7. check if match is over
        if match Not over -> return out
        if IS over -> set complete flag and update winner
 */
    
    mutating func addPoint(_ point: Point) {
        points.append(point)
        print("CHecking Points: \(point)")
        
        /* <----------- Arranging variables -----------> */
        //Arranging winner, set index, and game index to update score
        guard let winner = point.playerWon else { return }
        
        //get the index of the current Set
        guard let currSetIdx = score.sets.indices.last else{
            print("Error: No set found")
            return
        }
        
        guard let currGameIdx = score.sets[currSetIdx].games.indices.last else{
            print("Cannot find game")
            return
        }
        
        /* <----------- Apply Game point -----------> */
        
        //apply game point
        winner == .curr ? score.sets[currSetIdx].games[currGameIdx].currPlayerScored() : score.sets[currSetIdx].games[currGameIdx].oppPlayerScored()
                
        //access the current game
        let currentGame = score.sets[currSetIdx].games[currGameIdx]
        
        /* <----------- Updating Point's game score -----------> */
        
        //access the current point and update the game score
        guard let currPointIdx = points.indices.last else{return}
        points[currPointIdx].setGameScore(gameScore: currentGame)
//        points[currPointIdx].setGameScore(currScore: currentGame.currPlayerPoints, oppScore: currentGame.oppPlayerPoints)
        
        
        /* <----------- Check if Game is over, updating set, and updating server -----------> */
        guard currentGame.isGameOver() else { return }
        
        //apply game to set
        winner == .curr ? score.sets[currSetIdx].currGameWon() : score.sets[currSetIdx].oppGameWon()
        
        //switch server after game over
        switchServerAfterGame()
        
        let currentSet = score.sets[currSetIdx]
        
        /* <----------- Checking if set is over -----------> */

        guard currentSet.isSetComplete() else {
            
            if currentSet.isSetInTieBreak() {
                inTieBreak = true
                score.sets[currSetIdx].tieBreak = TieBreakScore(winAt: 7)
            } else {
                score.sets[currSetIdx].games.append(GameScore(gameType: format.scoringType))
            }
            return
        }
        
        inTieBreak = false
        score.sets[currSetIdx].winner = winner
        
        /* <----------- Check if Match is over -----------> */
        //check if match complete
        
        if score.isMatchOver() {
            matchComplete = true
            self.winner = score.getMatchWinner()
        } else{
            if format.finalSetFormat == .matchTiebreak && score.inFinalSet(){
                inTieBreak = true
                
                //create tie break instance and seetting to set
                var superTieBreaker = TieBreakScore(winAt: 10)
                var lastSet = SetScore(format: format)
                lastSet.tieBreak = superTieBreaker
                
                
                score.sets.append(lastSet)
            } else{
                score.sets.append(SetScore(format: format))
            }
        }
    }
    
    mutating func addTieBreakPoint(_ point: Point){
        points.append(point)
        
        let winner = point.playerWon
        
        guard let currSetIdx = score.sets.indices.last else{
            print("Error: No set found")
            return
        }
        
        if winner == .curr{
            score.sets[currSetIdx].tieBreak?.currPlayerScored()
        } else{
            score.sets[currSetIdx].tieBreak?.oppPlayerScored()
        }
        
        guard let currSetTieBreaker = score.sets[currSetIdx].tieBreak else {
            return
        }
        
        //for serve switching
        if abs(currSetTieBreaker.currPlayerPoints - currSetTieBreaker.oppPlayerPoints) % 2 == 1{
            switchServerAfterGame()
        }
        
        //check if tie break is over
        if currSetTieBreaker.isTieBreakOver() == true {
            
            //add a point to set
            winner == .curr ? score.sets[currSetIdx].currGameWon() : score.sets[currSetIdx].oppGameWon() //add game score to set
            score.sets[currSetIdx].winner = winner
            inTieBreak = false
            
        } else{
            return
        }

        //if match is over
        if score.isMatchOver() {
            matchComplete = true
            self.winner = score.getMatchWinner()
        } else{
            score.sets.append(SetScore(format: format))
        }
        
    }

    //switching server
    mutating func switchServerAfterGame() {
        server = server == .curr ? .opp : .curr
    }
}

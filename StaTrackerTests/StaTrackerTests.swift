//
// TESTS:
// Scoring Engine
// Match Format
//
// Ads
// Sets to win
// Fast 4 & StdSets & ProSets
//
// Best out of 3 & Best out of 5
//
// Created by Marshall Zhang on 11/24/25.
//

import Testing
@testable import StaTracker

struct StaTrackerTests {
    var matchFormat = MatchFormat(scoringType: .ad, setFormat: .fast4, finalSetFormat: .regularSet)
    
    //ServeData
    var firstServe = ServeData(made: .made, type: .flat, madePosition: .T, misType: nil, missPosition: nil, outcome: .ace)
    //SecondServe
    
    //ReceiveData
    
    //Second Receive
    
    //RallyData
    
    @MainActor
    @Test func checkingTieBreak() async throws {
        //arrange
        var testSetOne = SetScore(format: matchFormat)
    
        testSetOne.currPlayerGames = 4
        testSetOne.oppPlayerGames = 2
        
        //act
        let finished = testSetOne.isSetComplete(format: matchFormat)
        
        //Assert
        #expect(finished == true, "Should not be a complete set")
        
    }
    
    //Test Game Complete
    @MainActor
    @Test func testGameComplete() async throws {
        //Arrange
        var match = Match(currPlayer: "Test 1", oppPlayer: "Test 2", startingServer: .curr, format: matchFormat)
        guard var currSet = match.score.sets.last else {
            print("Error: Cannot find the current set to score in.")
            return
        }
        guard var currGame = currSet.games.last else{
            print("Error: No game found")
            return
        }
        
        currGame.currPlayerPoints = 3
        currGame.oppPlayerPoints = 0
        currSet.games[currSet.games.count - 1] = currGame       //update the new game
        match.score.sets[match.score.sets.count - 1] = currSet
        
        var newPoint = Point(server: .curr, firstServe: firstServe, secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
        //Act
        match.addPoint(newPoint)
        
        //update the currentgame back
        currSet = match.score.sets[match.score.sets.count - 1]
        currGame = currSet.games[currSet.games.count - 1]


        //Assert
        //check if the current game is the right one
        #expect(currGame.isGameOver() == true, "game should be over")
        #expect(match.server == .opp, "serve should be switched")
        #expect(currSet.currPlayerGames == 1, "curr player should have won first game")
    }
//    
//    //Test Set Complete
//    @Test func testSetComplete() async throws {
//        //Arrange
//        //
//        
//        //Act
//        
//        //Assert
//    }
//    
//    //test match complete
//    @Test func testMatchComplete() async throws {
//        //Arrange
//        //
//        
//        //Act
//        
//        //Assert
//    }
    
    /**
     Testing Concept Map
        Create VM to run score machine
            VM
                create match with the format and player names
                functions for score machine
                    -> savePoint -> adds point to match -> processScoring
                    -> processScoring
                        1. Identify Winner
                        2. Get Current Set
                        3. Get current Game or create new game for onAppear
                        4. Apply point to game w/ update
                        5. Check if game is won
                        6. Once game is over -> finalize Game: add to player's game, switch serve, create new game
     
            VM Match Score
                will create and append a set automaticallly
                functions to check
                    -> isMatchOver?
                    -> getMatchWinner
                    
     */
}


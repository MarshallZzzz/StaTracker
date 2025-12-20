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
        let finished = testSetOne.isSetComplete()
        
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

        let setLastIdx = match.score.sets.indices.last
//        //update the currentgamex back
        currSet = match.score.sets[setLastIdx!]
        currGame = currSet.games.last!
        print("Set: \(currSet)")
        print("Game: \(currGame)")


        //Assert
        //check if the current game is the right one
        #expect(currGame.isGameOver() == true, "game should be over")
        #expect(match.server == .opp, "serve should be switched")
//        #expect(currSet.currPlayerGames == 1, "curr player should have won first game")
    }
    
    //Test Set Complete
    @MainActor
    @Test func testTieBreakWin() async throws {
        //Arrange
        var currTieB = TieBreakScore(winAt: 7)
        currTieB.currPlayerPoints = 9
        currTieB.oppPlayerPoints = 8
        
        //Act
//        currTieB.currPlayerScored()
//        currTieB.currPlayerScored()
        
        //Assert
        #expect(currTieB.isTieBreakOver() == false, "Curr player won the tie breaker")
    }
//
    //1. Test Set Complete
    //2. Test Set call to tie break
    @MainActor
    @Test func testSetComplete() async throws {
        //Arrange
        var match = Match(currPlayer: "Test 1", oppPlayer: "Test 2", startingServer: .curr, format: matchFormat)
        
        var currSet = SetScore(format: matchFormat)
        currSet.currPlayerGames = 3
        currSet.oppPlayerGames = 0
        
        var currGame = GameScore(gameType: matchFormat.scoringType)
        currGame.currPlayerPoints = 3
        currGame.oppPlayerPoints = 0
        
        var newPoint = Point(server: .curr, firstServe: firstServe, secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
        
        //Act
        //first update the set in match
        var lastSetIdx = match.score.sets.indices.last!
        
        var lastGameIdx = match.score.sets[lastSetIdx].games.indices.last!
        
        match.score.sets[lastSetIdx] = currSet
        match.score.sets[lastSetIdx].games[lastGameIdx] = currGame
        
        print("\(match.score.sets)")
        
        match.addPoint(newPoint)
        
        var testSet = match.score.sets.last!
        currGame = testSet.games.last!
        
        //Assert
        #expect(currGame.isGameOver() == true, "game should be over")
        #expect(testSet.isSetComplete() == true, "Set is complete")
        #expect(testSet.isSetInTieBreak() == false, "NO")
//        #expect(match.finalizeGame(wonBy: newPoint.playerWon, in: &lastSet), "game should be finalized")
    }
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


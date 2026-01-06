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
import XCTest
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
    
//    //Test Game Complete
//    @MainActor
//    @Test func testGameComplete() async throws {
//        //Arrange
//        var match = Match(currPlayer: "Test 1", oppPlayer: "Test 2", startingServer: .curr, format: matchFormat)
//        guard var currSet = match.score.sets.last else {
//            print("Error: Cannot find the current set to score in.")
//            return
//        }
//        guard var currGame = currSet.games.last else{
//            print("Error: No game found")
//            return
//        }
//        
//        currGame.currPlayerPoints = 3
//        currGame.oppPlayerPoints = 0
//        currSet.games[currSet.games.count - 1] = currGame       //update the new game
//        match.score.sets[match.score.sets.count - 1] = currSet
//        
//        var newPoint = Point(server: .curr, firstServe: firstServe, secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
//        //Act
//        match.addPoint(newPoint)
//
//        let setLastIdx = match.score.sets.indices.last
////        //update the currentgamex back
//        currSet = match.score.sets[setLastIdx!]
//        currGame = currSet.games.last!
//        print("Set: \(currSet)")
//        print("Game: \(currGame)")
//
//
//        //Assert
//        //check if the current game is the right one
//        #expect(currGame.isGameOver() == true, "game should be over")
//        #expect(match.server == .opp, "serve should be switched")
////        #expect(currSet.currPlayerGames == 1, "curr player should have won first game")
//    }
//    
    //1. Test Set Complete
    //2. Test Set call to tie break
//    @MainActor
//    @Test func testSetComplete() async throws {
//        //Arrange
//        var match = Match(currPlayer: "Test 1", oppPlayer: "Test 2", startingServer: .curr, format: matchFormat)
//        
//        var currSet = SetScore(format: matchFormat)
//        currSet.currPlayerGames = 3
//        currSet.oppPlayerGames = 0
//        
//        var currGame = GameScore(gameType: matchFormat.scoringType)
//        currGame.currPlayerPoints = 3
//        currGame.oppPlayerPoints = 0
//        
//        var newPoint = Point(server: .curr, firstServe: firstServe, secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
//        
//        //Act
//        //first update the set in match
//        var lastSetIdx = match.score.sets.indices.last!
//        
//        var lastGameIdx = match.score.sets[lastSetIdx].games.indices.last!
//        
//        match.score.sets[lastSetIdx] = currSet
//        match.score.sets[lastSetIdx].games[lastGameIdx] = currGame
//        
//        print("\(match.score.sets)")
//        
//        match.addPoint(newPoint)
//        
//        var testSet = match.score.sets.last!
//        currGame = testSet.games.last!
//        
//        //Assert
//        #expect(currGame.isGameOver() == true, "game should be over")
//        #expect(testSet.isSetComplete() == true, "Set is complete")
//        #expect(testSet.isSetInTieBreak() == false, "NO")
////        #expect(match.finalizeGame(wonBy: newPoint.playerWon, in: &lastSet), "game should be finalized")
//    }
    
//    @MainActor
//    @Test func testFirstServePercentage() async throws {
//        //initialize point
//        let point1 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
//        let point2 = Point(server: .curr, firstServe: ServeData(made: .miss), secondServe: ServeData(made: .miss), firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .opp)
//        let point3 = Point(server: .curr, firstServe: ServeData(made: .miss), secondServe: ServeData(made: .miss), firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .opp)
//        let point4 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
//        
//        //arrange
//        let engine = StatEngine(points: [point1, point2, point3])
//        let totalFirstServes = engine.totalFirstServes
//        let firstServePercentage = engine.firstServePercentage
//        
//        //assert
////        1st Serve % = # of made / # of serves
////        XCTAssertEqual(totalFirstServes, 4, "First serve percentage should be 4")
//        XCTAssertEqual(firstServePercentage, 2.0 / 4.0 , "First serve percentage should be 50%")
//        
//    }
    
// TEST CACHING
    /*
     1. cache should only compute once
     2. Cache invalidates when new point comes in
     3. Cache should not invalidate when points don't change
     4. Cached Stat should survive multiple reads
     5. Multiple different stats should cache separately
     */
//    
//    @MainActor
//    @Test func testComputeOnce() async throws {
//        let vm = StatsViewModel()
//        let point1 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
//        let point2 = Point(server: .curr, firstServe: ServeData(made: .miss), secondServe: ServeData(made: .miss), firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .opp)
//    
//        vm.update(point: point1)
//        vm.update(point: point2)
//        
//        
//        let _ = vm.totalFirstServes()
//        let _ = vm.totalFirstServes()
//        let _ = vm.totalFirstServes()
//        print("\(vm.cache)")
//        
//        XCTAssertEqual(vm.computeCountFor("totalFirstServes"), 1, "compute should only run once")
//    }
    
    //Invalidates when new point comes in
//    @MainActor
//    @Test func testInvalidatesCache() {
//        let vm = StatsViewModel()
////        let point1 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr)
////        let point2 = Point(server: .curr, firstServe: ServeData(made: .miss), secondServe: ServeData(made: .miss), firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .opp)
//        
//        vm.update(point: point1)
//        vm.update(point: point2)
//        
//        let beginning = vm.totalFirstServes()
//        print("\(beginning)")
//        
//        XCTAssertEqual(vm.computeCountFor("totalFirstServes"), 1, "compute should only run once")
//        
////        let p3 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .opp)
//        
//        vm.update(point: p3)
//        let output = vm.totalFirstServes()
//        
//        print("\(output)")
//        print("current cach: \(vm.cache)")
//        
//        
//        XCTAssertEqual(vm.computeCountFor("totalFirstServes"), 1, "compute should only run once")
//    }
//    
    @MainActor
    @Test func testingBreakPointStat(){
        let testScore1 = GameScore(gameType: .ad, currS: 0, oppS: 0)
        let testScore2 = GameScore(gameType: .ad, currS: 1, oppS: 0)
        let testScore3 = GameScore(gameType: .ad, currS: 2, oppS: 0)
        let testScore4 = GameScore(gameType: .ad, currS: 3, oppS: 0)
        let testScore5 = GameScore(gameType: .ad, currS: 3, oppS: 1)
        let testScore6 = GameScore(gameType: .ad, currS: 3, oppS: 2)
        let testScore7 = GameScore(gameType: .ad, currS: 3, oppS: 3)
        let p1 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr, gameScore: testScore1) // 0-0
        let p2 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr, gameScore: testScore2) // 15 - 0
        let p3 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr, gameScore: testScore3) // 30 - 0
        let p4 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr, gameScore: testScore4) // 40 - 0    1
        let p5 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr, gameScore: testScore5) // 40 - 15   2
        let p6 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr, gameScore: testScore6) // 40 - 30   3
        let p7 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr, gameScore: testScore7) // 40 - 40
//        let p1 = Point(server: .curr, firstServe: ServeData(made: .made), secondServe: nil, firstReceive: nil, secondReceive: nil, rally: nil, playerWon: .curr, gameScore: testScore)
        
        let points = [p1, p2, p3, p4, p5, p6, p7]
        
        let Engine = StatEngine(points: points)
        
        print("# of break point opportunities: \(Engine.breakPointOpportunities)")
        
        XCTAssertEqual(Engine.breakPointOpportunities, 3)
        
//
    }
}


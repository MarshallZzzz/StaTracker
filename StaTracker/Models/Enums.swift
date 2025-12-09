import Foundation
//Serve
enum ServeMade: String, CaseIterable, Codable {
    case made = "MADE"
    case miss = "MISS"
}

enum ServeType: String, CaseIterable, Codable {
    case flat = "FLAT"
    case slice = "SLICE"
    case kick = "KICK"
    case spin = "SPIN"
}

enum ServePosition: String, CaseIterable, Codable {
    case wide = "WIDE"
    case body = "BODY"
    case T = "T"
}

enum SROutcome: String, CaseIterable, Codable { //Serve or Receive Outcome - perspective of player
    case ace = "ACE"
    case forcedError = "FORCED ERROR"
    case unforcedError = "UNFORCED ERROR"
    case rally = "RALLY"
}

//Receive
enum ReceiveMade: String, CaseIterable, Codable {
    case made = "MADE"
    case miss = "MISS"
    case oppMiss = "OPPONENT MISS"
}

enum ReceiveOutcome: String, CaseIterable, Codable {
    case winner = "WINNER"
    case forcedError = "FORCED ERROR"
    case unforcedError = "UNFORCED ERROR"
    case rally = "RALLY"
}

//Rally
enum RallyOutcome: String, CaseIterable, Codable {
    case win = "WIN"
    case lose = "LOSE"
}

enum OutcomeType: String, CaseIterable, Codable {
    case winner = "WINNER"
    case forcedError = "FORCED ERROR"
    case unforcedError = "UNFORCED ERROR"
}

enum PlayerPosition: String, CaseIterable, Codable {
    case baseline = "BASELINE"
    case noMansLand = "NO MANS LAND"
    case net = "NET"
}

enum ShotType: String, CaseIterable, Codable {
    case groundstroke = "GROUNDSTROKE"
    case slice = "SLICE"
    case lob = "LOB"
    case approach = "APPROACH"
    case driveVolley = "DRIVE VOLLEY"
    case halfVolley = "HALF VOLLEY"
    case volley = "VOLLEY"
    case smash = "SMASH"
    case dropShot = "DROP SHOT"
}

enum ShotTrajectory: String, CaseIterable, Codable {
    case crosscourt = "CROSSCOURT"
    case downtheline = "DOWN THE LINE"
}

//Universal cases
enum MissedPosition: String, CaseIterable, Codable {
    case net = "NET"
    case long = "LONG"
    case wide = "WIDE"
}

enum PlayerShotSide: String, CaseIterable, Codable {
    case forehand = "FOREHAND"
    case backhand = "BACKHAND"
}

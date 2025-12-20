//
//  FlowEnums.swift
//  StaTracker
//
//  Created by Marshall Zhang on 12/7/25.
//

import Foundation

enum servingPrompts: Int {
    case serveMade = 1
    case serveType
    case servePosition
    case missedType
    case missedPosition
    case SROutcome
    case notes
    case null
}

extension servingPrompts {
    var progressIndex: CGFloat { CGFloat(self.rawValue) }
}

enum receivingPrompts: Int {
    case receiveMade = 1
    case playerShotSide
    case receivePosition
    case missedPosition
    case receiveOutcome
    case notes
    case null
}

extension receivingPrompts {
    var progressIndex: CGFloat { CGFloat(self.rawValue) }
}

enum rallyPrompts: Int {
    case rallyOutcome = 1   //Win or Lose
    case outComeType        // Winner, Forced Error, Unforced Error
    case playerShotSide     // Forehand, backhand
    case playerPosition     // Baseline, Mid-court, net
    case shotType           // Groundstroke, slice, lob, approach, drive volley, volley, smash
    case shotTrajectory     // XCourt, Down the line, Drop Shot, Lob
    case missedPosition     // Net, Long, Down the Line wide, XCourt Wide
    case notes
    case null               //Done
}

extension rallyPrompts {
    var progressIndex: CGFloat { CGFloat(self.rawValue) }
}

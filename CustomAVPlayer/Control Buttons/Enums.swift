//
//  Enums.swift
//  CustomAVPlayer
//
//  Created by Chicmic on 26/07/23.
//

import Foundation

public enum ButtonSize: Int {
    case small  = 50
    case medium = 70
    case large  = 100
}

public enum PlayButtonImage: String {
    case play                = "play"
    case playFill            = "play.fill"
    case playCircle          = "play.circle"
    case playCircleFill      = "play.circle.fill"
    case playSquare          = "play.square"
    case playSquareFill      = "play.square.fill"
    case playRectangle       = "play.rectangle"
    case playRectangleFill   = "play.rectangle.fill"
}

public enum PauseButtonImage: String {
    case pause                = "pause"
    case pauseFill            = "pause.fill"
    case pauseCircle          = "pause.circle"
    case pauseCircleFill      = "pause.circle.fill"
    case pauseSquare          = "pause.square"
    case pauseSquareFill      = "pause.square.fill"
    case pauseRectangle       = "pause.rectangle"
    case pauseRectangleFill   = "pause.rectangle.fill"
}

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

public enum ReplayButtonImage: String {
    case goforward            = "goforward"
}

public enum MuteButtonImage: String {
    case speakerSlash           = "speaker.slash"
    case speakerSlashFill       = "speaker.slash.fill"
    case speakerSlashCircle     = "speaker.slash.circle"
    case speakerSlashCircleFill = "speaker.slash.circle.fill"
}

public enum UnmuteButtonImage: String {
    case speaker                = "speaker.wave.2"
    case speakerFill            = "speaker.wave.2.fill"
    case speakerCircle          = "speaker.wave.2.circle"
    case speakerCircleFill      = "speaker.wave.2.circle.fill"
}

public enum ForwardButtonImage: String {
    case forwardButton          = "forward"
}

public enum BackwardButtonImage: String {
    case backwardButton         = "backward"
}

//
//  CommonMethods.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/26/23.
//

import Foundation

class Helper {
    
    static func getTimeString(seconds: Float64) -> String {
        let secondString = String(format: "%02d", Int(seconds) % 60)
        let minutString = String(format: "%02d", Int(seconds) / 60)
        return "\(minutString):\(secondString)"
    }
}

//
//  MotionDnaManager.swift
//  iOS-helloworld-swift
//
//  Created by James Grantham on 9/14/18.
//  Copyright © 2018 Navisens. All rights reserved.
//

import Foundation
import MotionDnaSDK

class MotionDnaManager: MotionDnaSDK {
    var receiver:ViewController?
    
    override func receive(_ motionDna: MotionDna!) {
        receiver?.receive(motionDna)
    }

    override func reportError(_ error: ErrorCode, withMessage message: String!) {
        switch error {
        case SENSOR_TIMING:
            print("Error: Sensor Timing "  + message)
        case AUTHENTICATION_FAILED:
            print("Error: Authentication Failed " + message)
        case SENSOR_MISSING:
            print("Error: Sensor Missing " + message)
        case SDK_EXPIRED:
            print("Error: SDK Expired " + message)
        case WRONG_FLOOR_INPUT:
            print("Error: Wrong Floor Input " + message)
        default:
            print("Error: Unknown Cause")
        }
    }
    
    override func receiveNetworkData(_ motionDna: MotionDna!) {
        receiver?.receiveNetworkData(motionDna)
    }
    
    override func receiveNetworkData(_ opcode: NetworkCode, withPayload payload: [AnyHashable : Any]!) {
        receiver?.receiveNetworkData(opcode, withPayload: payload)
    }
}

//
//  ViewController.swift
//  iOS-helloworld-swift
//
//  Created by James Grantham on 9/14/18.
//  Copyright © 2018 Navisens. All rights reserved.
//

import UIKit
import MotionDnaSDK


struct MotionData {
    var id:String
    var deviceName:String
    var location:Location
}

class ViewController: UIViewController, MotionDnaSDKDelegate {
    var motionDnaSDK : MotionDnaSDK!
    
    @IBOutlet weak var receiveMotionDnaTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDemo();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func receive(motionDna: MotionDna) {
        
        
        let location = motionDna.location!
        let localLocation = location.cartesian!
        let globalLocation = location.global!
        let motion = motionDna.classifiers["motion"]?.prediction.label

        let motionDnaLocalString = String(format:"Local XYZ Coordinates (meters) \n(%.2f,%.2f,%.2f)",localLocation.x,localLocation.y,localLocation.z)
        let motionDnaHeadingString = String(format:"Current Heading: %.2f",location.global.heading)
        let motionDnaGlobalString = String(format:"Global Position: \n(Lat: %.6f, Lon: %.6f)",globalLocation.latitude,globalLocation.longitude)
        let motionDnaMotionTypeString = String(format:"Motion Type: %@",motion!)

        guard let classifiers = motionDna.classifiers else {
            return;
        }
        var motionDnaPredictionString = "Predictions (BETA):\n"
        var classifierNames = [String]()
        for (classifierName, _) in classifiers {
            classifierNames.append(classifierName);
        }
        classifierNames.sort()
        
        for classifierName in classifierNames {
            guard let classifier = classifiers[classifierName] else {
                break;
            }
            motionDnaPredictionString.append(String(format: "Classifier: %@\n", classifierName))
            motionDnaPredictionString.append(String(format: "\t prediction: %@ confidence: %.2f\n", classifier.prediction.label,classifier.prediction.confidence))
            
            var predictionLabels = [String]()
            for (predictionLabel, _) in classifier.statistics {
                predictionLabels.append(predictionLabel);
            }
            predictionLabels.sort()
            for predictionLabel in predictionLabels {
                guard let predictionStats = classifier.statistics[predictionLabel] else {
                    break;
                }
                motionDnaPredictionString.append(String(format: "\t%@\n", predictionLabel))
                motionDnaPredictionString.append(String(format: "\t duration: %.2f\n", predictionStats.duration))
                motionDnaPredictionString.append(String(format: "\t distance: %.2f\n", predictionStats.distance))
            }
            motionDnaPredictionString.append("\n")
        }
        
        let motionDnaString = String(format:"%@\n MotionDna Location:\n%@\n%@\n%@\n%@\n%@",MotionDnaSDK.sdkBuild(),motionDnaLocalString,
                                     motionDnaHeadingString,
                                     motionDnaGlobalString,
                                     motionDnaMotionTypeString,
                                     motionDnaPredictionString)
        DispatchQueue.main.async {
            self.receiveMotionDnaTextField.text = motionDnaString
        }
    }

    

    func report( status: MotionDnaSDK.Status, message: String) {
        switch status {
        case .sensorTimingIssue:
            print("Error: Sensor Timing "  + message)
        case .authenticationFailure:
            print("Error: Authentication Failed " + message)
        case .missingSensor:
            print("Error: Sensor Missing " + message)
        case .expiredSDK:
            print("Error: SDK Expired " + message)
        case .authenticationSuccess:
            print("Status Authenticated: " + message)
        case .permissionsFailure:
            print("Status Permissions: " + message)
        case .none:
            print("Status None: " + message)
        default:
            print("Error Unknown: " + message)
        }
    }
    

    
    func startDemo() {
        motionDnaSDK = MotionDnaSDK(delegate: self)
        let developerKey = "<--DEVELOPER-KEY-HERE-->"
        motionDnaSDK.start(withDeveloperKey: developerKey)
    }
}


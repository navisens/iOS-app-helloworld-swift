# iOS-app-helloworld-swift
An example Swift iOS project using the Navisens MotionDNA SDK

___Note: This app is designed to run on iOS 9.1 or higher___

run ```pod install``` from the project folder to install necessary dependencies

## What it does
This project builds and runs a bare bones implementation of our SDK core. 

The core is initialized and activated on startup in the view controller triggering a call to the ```startMotionDna``` method in the view controller. After this occurs the controller checks for necessary location permission and if requirements are satisfied, begins to receive Navisens MotionDNA location estimates through the ```receiveMotionDna:``` callback method. The data received is used to update the appropriate label element with a user's relative x,y and z coordinated along with GPS data and motion categorizations.

Before attempting to run this project please be sure you have obtained a develepment key from Navisens. A key may be acquired free for testing purposes at [this link](https://navisens.com/index.html#contact)

For more complete documentation on our SDK please visit our [NaviDocs](https://github.com/navisens/NaviDocs)


### Implementation

The Navisens MotionDna SDK is implemented in your project by first subclassing the MotionDnaSDK class and then implementing select callbacks for receiving estimation data and other various pieces of information

The structure of this class should resemble the following code and implement a subset of the methods listed.

###### MotionDnaManager.swift
``` Swift
class MotionDnaManager: MotionDnaSDK {

  override func receive(_ motionDna: MotionDna!) {
    NSLog("%.8f %.8f %.8f %.8f\n", motionDna.getLocation().heading, motionDna.getLocation().localLocation.x, motionDna.getLocation().localLocation.y, motionDna.getLocation().localLocation.z)
  }

  override func receiveNetworkData(_ networkCode: NetworkCode, withPayload map: Dictionary<>) {
  }

  override func receiveNetworkData(_ motionDna: MotionDna) {
  }

  override func failure(toAuthenticate msg: String!) {
  }

  override func reportSensorTiming(_ dt: Double, msg: String!) {
  }
}
```

The ``` receive(_ motionDna: MotionDna!) ``` method is the key method in using the SDK. It will be responsible for passing location data from our core to your project. The MotionDna object contains your x,y,and z coordinates (in meters) with respect to your starting position, as well as a your current latitude and longitude and several other metrics of interest which you can read about in more detail in our [documentation](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#getters).

Our SDK also support location sharing through the use of a server and the startUDP() method calls. Data is received by the  ``` receiveNetworkData ``` methods. The base method is passed a MotionDna object that for each user that is also sharing with the same host, developer key, and room.

The ``` reportError ``` callback received information regarding any issue that may have arisen over the course of trying to run our SDK. This can range from authentication errors with your developer key, to missing permissions that are needed for our system to run. For a full list see our documentation [here](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#reporterror_-errorcode-errorcode-withmessage-s-string).

### Running the SDK

The ``` viewDidLoad ``` method of your view controller is a good place for initializing and could include the following object instantiation and method calls.

##### ViewController.swift
``` Swift
var manager = MotionDnaManager()

override func viewDidLoad() {
  manager.receiver = self
  manager.runMotionDna("<developer-key>")
}
```

Substitute ``` <developer-key> ``` with your own Navisens provided developer key. Again, if you do not yet have one then please navigate to our [developer sign up](https://www.navisens.com/index.html#contact) to request a free key.

Running this project will begin to show your location estimation on the phone screen. Walk around to see how it changes your x, y, and z coordinates.

If you have two or more phones running with the same developer key you will see their locations appear and update in realtime at the bottom on the opposite phone

## More Info

Additional configuration options are described in the project source and our iOS [documentation](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md). 

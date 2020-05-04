# iOS App Hello World (swift)
An example Swift iOS project using the Navisens MotionDNA SDK

___Note: This app is designed to run on iOS 12.0 or higher___

run ```pod install``` from the project folder to install necessary dependencies

## What it does
This project builds and runs a bare bones implementation of our SDK core.

The core is initialized and activated on startup in the view controller triggering a call to the ```startMotionDna``` method in the view controller. After this occurs the controller checks for necessary location permission and if requirements are satisfied, begins to receive Navisens MotionDNA location estimates through the ```receiveMotionDna:``` callback method. The data received is used to update the appropriate label element with a user's relative x,y and z coordinated along with GPS data and motion categorizations.

Before attempting to run this project please be sure you have obtained a develepment key from Navisens. A key may be acquired free for testing purposes at [this link](https://navisens.com/index.html#contact)

For more complete documentation on our SDK please visit our [NaviDocs](https://github.com/navisens/NaviDocs)

### Setup

Add the subclassed MotionDnaSDK as a property of your View Controller

``` Swift
manager.runMotionDna("<developer-key>")
```

Walk around to see your position update.


## How the SDK works

Please refer to our [NaviDoc](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#api) for full documentation.

### How you include (and update) the SDK

Add `pod 'MotionDnaSDK` to your podfile and run `pod install` to load the SDK. If there has been a version update to the SDK recently then run `pod update` from the project folder to update the repo.

### How you get your [estimated] position

In our SDK we provide `MotionDnaSDKDelegate` class which you implment in your viewcontroller or other class and and implement the required deegate methods.

``` Swift
class MotionDnaManager: MotionDnaSDK {
  override func receive(motionDna: MotionDna) {}
  override func report(status: MotionDnaSDK.Status, message: String) {}
}
```

The ``` receive(motionDna: MotionDna) ``` callback method returns a MotionDna estimation object containing [location, heading and motion classification](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#estimation-properties) among many other interesting data on a users current state. Here is how we might print it out.

``` swift
  override func receive(_ motionDna: MotionDna!) {
    NSLog("%.8f %.8f %.8f %.8f\n",  motionDna.location.cartesian.heading,
                                    motionDna.location.cartesian.x,
                                    motionDna.location.cartesian.y,
                                    motionDna.location.cartesian.z)
  }
```

### Running the SDK

Add the subclassed MotionDnaSDK as a property of your View Controller

``` Swift
var manager = MotionDnaSDK()
```

``` Swift
manager.start("<developer-key>")
```

## Common Configurations (with code examples)
### Startup
``` Swift
manager.start(withDeveloperKey:"<developer-key>")
```
### Startup with Configuration (Model Selection)
Additional configuration options will be added over time. Current configuration options are only for model seletion in motion estimation. Currently supported models are "standard", "headmount", and "chestmount".

``` Swift
var configuration = [String:Any]()
configuration["model"] = "standard"
manager.start(withDeveloperKey: "<developer-key>", configurations: configuration)
```

### Setting SDK Options
#### Common Task:

### _Assigning initial position Locally (Cartesian X and Y coordinates)_
#### Common Tasks:
You know that a users position should be shifted by 4 meters in the X direction and 9 in the Y direction. Heading should not change. If the current estimated position is (4,3) the updated position should be (8,12)

``` manager.setCartesianPosition(x:4, y: 9) ```


-------------

### _Assigning initial position Globally (Latitude and Longitude coordinates)_

#### Common Tasks:
 You need to update the latitude and longitude to (37.756581, -122.419155). Heading can be taken from the device's compass

``` manager.setGlobalPosition(37.756581, longitude:-122.419155) ```

 You know the users location is latitude and longitude of (37.756581, -122.419155) with a heading of 3 degrees and need to indicate that to the SDK

``` manager.setGlobalPositionAndHeading(37.756581, longitude:-122.419155, heading:3.0) ```

------------

### _Observations (EXPERIMENTAL)_
#### Common Task:
A user is indoors and revisits the same areas frequently. Through some outside mechanism the developer is aware of a return to certain landmarks and would like to indicate that the user has returned to a landmark with ID of 38 to aid in the estimation of a user's position. The developer also knows that this observation was made within 3 meters of the landmark 38

``` manager.recordObservation(withIdentifier: 38, uncertainty: 3.0) ```


## Additional configuration options are described in the project source and our [iOS Documentation](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md).

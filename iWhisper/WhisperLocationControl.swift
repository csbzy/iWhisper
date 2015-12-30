//
//  WhisperLocationControl.swift
//  iWhisper
//
//  Created by swift on 15/12/29.
//  Copyright © 2015年 chensb. All rights reserved.
//

import CoreLocation


class WhisperLocationControl:NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance: WhisperLocationControl {
        struct Singleton{
            static let instance = WhisperLocationControl()
        }
        return Singleton.instance
    }
    
    var location :CLLocation?
    var locationManager : CLLocationManager?
    
    func startUpdatingLocation(){
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        //        locationManager.requestWhenInUseAuthorization()
        self.locationManager!.requestAlwaysAuthorization()
        if #available(iOS 9.0, *) {
            self.locationManager!.requestLocation()
        } else {
            // Fallback on earlier versions
            self.locationManager!.startUpdatingLocation()
            print("start location")
        }
    }
    
    
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)
        self.location = locations.last
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

}

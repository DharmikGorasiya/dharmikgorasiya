//
//  LocationManager.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 15/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import CoreLocation
class LocationManager: NSObject,CLLocationManagerDelegate {
    let locManager = CLLocationManager()
    static let sharedManger = LocationManager()
    var latitude:Double = 0
    var longitude:Double = 0
    var currentLocation:CLLocation!
    var timer:Timer!
    var tempLatitude = 0.0
    var handlerLocation:((CLLocation)->())?
    var handlerDirection:((CLHeading)->())?
    
    override init() {
        super.init()
        self.startUpdating()
    }
    
    init(locationHander:@escaping(CLLocation)->(),directionHandler:@escaping(CLHeading)->())
    {
        super.init()
        locManager.allowsBackgroundLocationUpdates = true
        handlerLocation = locationHander
        handlerDirection = directionHandler
        if(timer != nil)
        {
            timer?.invalidate()
        }
        self.startUpdating()
        
    }
    
    @objc func startUpdating()
    {
        locManager.delegate = self
        self.locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locManager.startUpdatingLocation()
        if(timer != nil)
        {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 60*10, target: self, selector: #selector(startUpdating), userInfo: nil, repeats: true)
    }
    
    //MARK: - Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0
        {
            return;
        }
        let newLocation: CLLocation? = locations.last
        currentLocation = newLocation;
        if(tempLatitude == 0.0)
        {
            tempLatitude = (newLocation?.coordinate.latitude)!
            self.getCountryName(location: newLocation!)
            //locManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if handlerDirection != nil{
            handlerDirection?(newHeading)
        }
    }
    func getCurrentLocation(completion:@escaping ((CLLocation) -> ()))
    {
        if(currentLocation != nil)
        {
            locManager.startUpdatingLocation()
            completion(currentLocation)
        }
    }
    func getCountryName(location:CLLocation)
    {
        if handlerLocation != nil{
            
            handlerLocation!(location)
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if(placeMark == nil)
            {
                return
            }
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
            }
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
            }
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
            }
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
            }
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
        })
        USERDEFAULTS.synchronize()
        locManager.stopUpdatingLocation()
        locManager.stopUpdatingHeading()
    }
}

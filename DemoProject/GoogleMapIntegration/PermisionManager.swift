//
//  PermisionManager.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 15/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import CoreLocation
class PermisionManager: NSObject {

   class func checkForLocationService() -> Bool {
        var isAccess:Bool = false
        let topView = UIApplication.topViewController()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                isAccess = false
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "Access Location", message: "Give permition location to access location", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Setting", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                        print("")
                        //UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
                        if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/com.app.GlobalDemoProject") {
                            //UIApplication.shared.openURL(url)
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction!) in
                       isAccess = PermisionManager.checkForLocationService()
                    }))
                    
                    topView?.present(alert, animated: true, completion: nil)
                })
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                isAccess = true
            }
        } else {
            print("Location services are not enabled")
            isAccess = false
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Access Location", message: "Give permition location to access location", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Setting", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    print("")
                    //UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
                    if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/com.app.GlobalDemoProject") {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction!) in
                    isAccess = PermisionManager.checkForLocationService()
                }))
                topView?.present(alert, animated: true, completion: nil)
            })
        }
        return isAccess
    }
    
}

//
//  GoogleMapManager.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 15/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Alamofire
class GoogleMapManager: NSObject {

    class func drawRoute(CLLatitude:String,CLLongitude:String,DLLatitude:String,DLLongitude:String,isProgress:Bool = true, completion:@escaping(_ isSucess:Bool,_ response:String) -> ())
    {
        if(isProgress)
        {
            Utility.showProgress("")
        }
        var directionURL =  "https://maps.googleapis.com/maps/api/directions/json?origin=\(CLLatitude),\(CLLongitude)&destination=\(DLLatitude),\(DLLongitude)&key=\(GoogleMapAPIKey.MapAPIkey)"
        //AIzaSyARoB09HGFjDy3IKfLpZq-ZQd3YwUT-3_E
        //AIzaSyDxSgGQX6jrn4iq6dyIWAKEOTneZ3Z8PtU
        directionURL += "&mode=" + "driving"
        APIManager.getRouteData(url: directionURL) { (isSuccess, response) in
            Utility.dismissProgress()
            completion(isSuccess,response!)
        }
    }
    
    class func placeIdToLatLong(placeId:String,isProgress:Bool = true,completion:@escaping(_ isSuccess:Bool, _ Response:NSDictionary?) -> ())
    {
        if(isProgress)
        {
            Utility.showProgress("")
        }
        let url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(GoogleMapAPIKey.WebAPIKey)"
        APIManager.placeIdToLatlong(url: url) { (isSuccess, response) in
            if let result = response!["result"] as? NSDictionary   {
                print(result)
                Utility.dismissProgress()
                if let geomatrix = result["geometry"] as? NSDictionary
                {
                    if let location = geomatrix["location"] as? NSDictionary
                    {
                        completion(true,location)
                    }
                    else
                    {
                       completion(false,["error":"Address not found..!!"])
                    }
                }
                else
                {
                    completion(false,["error":"Address not found..!!"])
                }
                
            }
            else
            {
                Utility.dismissProgress()
                completion(false,["error":"Request limit out"])
            }
        }
    }
    
    class func getDistanceAndDuration(CLLatitude:String,CLLongitude:String,DLLatitude:String,DLLongitude:String,isProgress:Bool = true, completion:@escaping(_ isSucess:Bool,_ response:NSDictionary?) -> ())
    {
          let url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(CLLatitude),\(CLLongitude)&destinations=\(DLLatitude),\(DLLongitude)&key=\(GoogleMapAPIKey.MapAPIkey)"
        if(isProgress)
        {
            Utility.showProgress("")
        }
        APIManager.getDuratioAndDistance(url: url) { (isSuccess, response) in
            Utility.dismissProgress()
            let arrTemp = response!["origin_addresses"] as? NSArray
            if(arrTemp?.count != 0)
            {
                Utility.dismissProgress()
                let arrRows:NSArray = (response!["rows"] as? NSArray)!
                if(arrRows.count != 0)
                {
                    let dic:NSDictionary = arrRows[0] as! NSDictionary
                    let arrElement:NSArray = dic["elements"] as! NSArray
                    if(arrElement.count != 0)
                    {
                        let dicElement:NSDictionary = arrElement[0] as! NSDictionary
                        completion(true,dicElement)
                    }
                    else
                    {
                        completion(false,["error":"Not fount result"])
                    }
                }
                else
                {
                    completion(false,["error":"Not distance found"])
                }
            }
            else
            {
                Utility.dismissProgress()
                completion(false,["error":"Not distance found"])
            }
        }
    }
    
}

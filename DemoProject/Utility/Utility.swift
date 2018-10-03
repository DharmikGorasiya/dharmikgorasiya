//
//  Utility.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 14/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import SDWebImage
import SVProgressHUD
import AVFoundation
import Alamofire

class Utility: NSObject {
    
    
    // Sound Method

    class func playSound(songname:String){
        player?.stop()
        let sound = Bundle.main.url(forResource: songname, withExtension: "wav")
        do {
            player = try AVAudioPlayer(contentsOf: sound!)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
            player.volume = 1.0
            player.numberOfLoops = -1
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func playSoundSingle(songname:String){
        player?.stop()
        let sound = Bundle.main.url(forResource: songname, withExtension: "wav")
        do {
            player = try AVAudioPlayer(contentsOf: sound!)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
            player.volume = 1.0
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // Display Alert Message
    class func showAlert(_ title: String,
                         message: String,
                         actions:[UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)]) {
        if checkAlertExist() == false {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            for action in actions {
                alert.addAction(action)
            }
            let tab =  UIApplication.shared.delegate?.window!?.rootViewController as? UITabBarController
            
            if tab != nil {
                let nav = tab?.selectedViewController as? UINavigationController
                nav?.present(alert, animated: true, completion: nil)
            }else{
                
                let nav =  UIApplication.shared.delegate?.window!?.rootViewController as? UINavigationController
                nav?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    class func showAlertScreen(_ title: String,
                               message: String,
                               actions:[UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)],viewController:UIViewController) {
        if checkAlertExist() == false {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            for action in actions {
                alert.addAction(action)
            }
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func textfieldBorder(txtViewName:UIView,isSelected:Bool = false)
    {
        txtViewName.layer.borderWidth = 1
        if(isSelected)
        {
            txtViewName.layer.borderColor = Constant.Color.GreenMedium.cgColor
        }
        else
        {
            txtViewName.layer.borderColor = Constant.Color.GrayLight.cgColor
        }
    }
    class func checkAlertExist() -> Bool {
        for window: UIWindow in UIApplication.shared.windows {
            if (window.rootViewController?.presentedViewController is UIAlertController) {
                return true
            }
        }
        return false
    }
    
    // Set UserDefault Value
    
    class func saveValueInNSUserDefaults(_ value:AnyObject?, forKey key:String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // Find Color From Hex Value
    
    class func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    // Display ProgressHUD
    class func showProgress(_ message: String) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        if(message == "") {
            SVProgressHUD.show()
        }
        else {
            SVProgressHUD.show(withStatus: message)
        }
    }
    
    class func dismissProgress() {
        SVProgressHUD.dismiss()
    }
    
    // Date Convert
    class  func convertDateFormate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM yy"
        return dateFormatter.string(from: dateObj!).capitalized//timeStamp
    }
    
    class  func convertDateFormate(date: String,currentFormate:String,convertFormate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormate
        let dateObj = dateFormatter.date(from: date)
        dateFormatter.dateFormat = convertFormate
        return dateFormatter.string(from: dateObj!)//.capitalized//timeStamp
    }
    
    class func dayDifference(msgDate:Date) -> String
    {
        let calendar = NSCalendar.current
        let date = msgDate//Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return "STR_Yesterday".localized }
        else if calendar.isDateInToday(date) { return "STR_Today".localized }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let now = dateFormatter.string(from: msgDate)
            return now
            
            //            let startOfNow = calendar.startOfDay(for: Date())
            //            let startOfTimeStamp = calendar.startOfDay(for: date)
            //            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            //            let day = components.day!
            //            if day < 1 { return "\(abs(day)) days ago" }
            //            else { return "In \(day) days" }
        }
    }
    
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

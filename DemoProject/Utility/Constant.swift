//
//  Constant.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 14/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import Firebase
// MARK:- Device Idiom
enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}

// MARK:- Screen Size
struct ScreenSize {
    static let SCREEN_WIDTH             =   UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT            =   UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH        =   max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH        =   min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

// MARK:- Device Type
struct DeviceType {
    static let IS_IPHONE_4_OR_LESS      =   UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5              =   UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_8              =   UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_8P             =   UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X              =   UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD                  =   UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO              =   UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}


@available(iOS 10.0, *)
let kAppDelegate                =   UIApplication.shared.delegate as! AppDelegate
@available(iOS 10.0, *)
let kRootViewController         =   kAppDelegate.window?.rootViewController
let kMainStoryBoard             =   UIStoryboard(name: "Main", bundle: nil)
let USERDEFAULTS                =   UserDefaults.standard

var player: AVAudioPlayer?

class Constant: NSObject {

    
    // MARK:- Color Code
    struct Color {
        static let White                    =   Utility.UIColorFromHex(rgbValue: 0xFFFFFF)
        static let GrayDark                 =   Utility.UIColorFromHex(rgbValue: 0x6d6d6d)
        static let GrayMeddium              =   Utility.UIColorFromHex(rgbValue: 0x888888)
        static let TextFieldBorder          =   Utility.UIColorFromHex(rgbValue: 0xEAEAEA)
        static let TextFieldPlaceholder     =   Utility.UIColorFromHex(rgbValue: 0x656565)
        static let ThemeColor               =   Utility.UIColorFromHex(rgbValue: 0x2DAEEF)
        static let BlueDark                 =   Utility.UIColorFromHex(rgbValue: 0x0A76A9)
        static let GrayLight                =   Utility.UIColorFromHex(rgbValue: 0xDDDDDD)
        static let RedColor                 =   Utility.UIColorFromHex(rgbValue: 0xF32100)
        static let GreenDark                =   Utility.UIColorFromHex(rgbValue: 0x32BF29)
        static let GreenMedium              =   Utility.UIColorFromHex(rgbValue: 0xAAF02F)
        static let GreenLight               =   Utility.UIColorFromHex(rgbValue: 0xC1F961)
        static let BlueLight                =   Utility.UIColorFromHex(rgbValue: 0xCEE4EE)
        static let WhiteLight               =   Utility.UIColorFromHex(rgbValue: 0xF8F8F8)
        
    }
    // MARK:- API Constant
    struct ServerAPI {
        
        // Base URL & Image Upload URL
        static let kBaseURL                     =   "http://www.example.com/api/"
        static let kImgUploadURL                =   "http://www.example.com/upload/upload1.php"
        
        // Login, Register & Logout URL
        static let kSignUpURL                   =   kBaseURL + "Registration/UserRegistration/"
        static let kLogInURL                    =   kBaseURL + "Registration/Login"
        static let kLogOutURL                   =   kBaseURL + "Registration/Logout"
        
    }
    
    // MARK:- Pop Up Error Message
    struct ErrorMessage {
        static let kTitle                       =   "Message"
        static let kNoInternetConnection        =   "Please check your internet connection."
        static let kCommanError                 =   "We had an unexpected error, please try again!"
        static let kServerError                 =   "There seems to be a problem with the connection. Please try again soon."
    }
    
    
}
struct UDKey {
    static let decodableStructureStoreData = "DataStorage"
    static let decodableClassStoreData     = "ClassDataStorage"
}

struct FIRRefrence
{
    static let userID      = "9016161562"
    static let senderID    = "8866339596"
    static let tblChat     = "Chat"
    static let messageList = "Messages"
    static let refChat = Database.database().reference().child(tblChat)
}

struct GoogleMapAPIKey
{
    static let MapAPIkey  =  "AIzaSyBkT_oyJlDvE4u3zXuHUp2gYdfSGcAaOOE"//"AIzaSyAgZYXoqvHFKle2DXoVszv-K7Luo9AkoHY"//"AIzaSyC5tLLVvtuC9U5ep3JGtbjaIug6Gw7tgm8"
    static let WebAPIKey  =  "AIzaSyBkT_oyJlDvE4u3zXuHUp2gYdfSGcAaOOE"//"AIzaSyC5tLLVvtuC9U5ep3JGtbjaIug6Gw7tgm8"
}
enum MethodType{
    case POST
    case GET
}

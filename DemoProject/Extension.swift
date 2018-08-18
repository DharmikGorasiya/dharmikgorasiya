//
//  Extension.swift
//  My2 Property
//
//  Created by Developer on 13/03/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Constant

let kAppDelegate                =   UIApplication.shared.delegate as! AppDelegate
let kMainStoryBoard             =   UIStoryboard(name: "Main", bundle: nil)
let USERDEFAULTS                =   UserDefaults.standard
let kImgPlaceHolder             =   UIImage(named: "default-image")

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

class Constant: NSObject {
    // MARK:- Color Code
    struct Color {
        static let ThemeColor               =   Utility.UIColorFromHex(hex: "74D4CB") // light green color
    }
    
    // MARK:- API Constant
    struct ServerAPI {
        // Base URL & Image Upload URL
        static let kBaseURL                     =   "http://example.com/api_2_7/"
        // Login, Register & Logout URL
        static let kLogInURL                    =   kBaseURL + "user/userLogin"
    }
    
    // MARK:- Pop Up Error Message
    struct ErrorMessage {
        static let kTitle                       =   "STR_ALERT_TITLE".localized
        static let kNoInternetConnection        =   "STR_ALERT_NO_INTERNET_CONNECT".localized
        static let kCommanError                 =   "STR_ALERT_UNEXPECTED_ERROR".localized
        static let kServerError                 =   "STR_ALERT_SERVER_ERROR".localized
    }
}

enum MessageType: String, Decodable {
    case unknown    =   "0"
    case text       =   "1"
    case image      =   "2"
    case audio      =   "3"
    case video      =   "4"
    case property   =   "5"
}

//--------------------------------------------------------------------------------------------------

// MARK:- UIApplication Extension
extension UIApplication {
    
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
    
    // Get Current View
    class func topViewController(base: UIViewController? = kAppDelegate.window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController?.childViewControllers.last {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
}

// MARK:- UIImageView Extension
extension UIImageView {
    // Set Web Image
    func setImageFromURL(_ urlString: String,_ placeholder: UIImage) {
        //self.sd_setImage(with: URL(string: urlString), placeholderImage: placeholder)
    }
    
}

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


// MARK:- UIView Extension
@IBDesignable
extension UIView {
    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
            //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    /// Size of view.
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    /// Width of view.
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    /// Height of view.
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
    }
    
    public typealias Configuration = (UIView) -> Swift.Void
    
    public func config(configurate: Configuration?) {
        configurate?(self)
    }
    
    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }
    
    /// This is the function to get subViews of a view of a particular type
    /// https://stackoverflow.com/a/45297466/5321670
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
    /// https://stackoverflow.com/a/45297466/5321670
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}


// MARK:- String Extension
extension String {
    // Check String is valid email
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    // encode emoji's message
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    // decode emoji's message
    func decode() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
}

// MARK:- UItextfield Extension
extension UITextField {
    
    func setPadding(_ amount:CGFloat) {
        self.setLeftPaddingPoints(amount)
        self.setRightPaddingPoints(amount)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

// MARK:- UIScrollView Extension
extension UIScrollView {
    
    func scrollToBottom(animated: Bool) {
        let rect = CGRect(x: 0, y: self.contentSize.height - self.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height)
        self.scrollRectToVisible(rect, animated: animated)
    }
}

extension FileManager {
    
    class func documentsDirectory () -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//----------------------------------------------------------------------------------------------------------------------------

class Utility {
    
    // Display Alert Message
    class func showAlert(_ title: String,
                         message: String,
                         actions:[UIAlertAction] = [UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil)]) {
        if checkAlertExist() == false {
            
            //let topView = UIApplication.topViewController()
            
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
    
    class func checkAlertExist() -> Bool {
        for window: UIWindow in UIApplication.shared.windows {
            if (window.rootViewController?.presentedViewController is UIAlertController) {
                return true
            }
        }
        return false
    }
    
    // Find Color From Hex Value
    class func UIColorFromHex(hex:String, alpha:Double = 1.0) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // Get Country Code & Name
    class func getCountryNames() -> NSArray
    {
        let arrCountry = NSArray()
        /*
         if let path = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
         do {
         let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
         do {
         let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) //as! NSDictionary
         arrCountry = (jsonResult as! NSArray)
         return arrCountry
         } catch {}
         } catch {}
         }
         */
        return arrCountry
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
    
    // MARK: convert local date & time to UTC
    class func localToUTC(date:String, fromFormat: String, toFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.date
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    // MARK: Convert UTC date & time to local
    class func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    class func convertDateFormate(forStringDate strDate: String, currentFormate: String, newFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormate
        let dateObj = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = newFormate
        return dateFormatter.string(from: dateObj!)
    }
    
    class func getDateFromString(strDate: String, currentFormate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormate
        let dateObj = dateFormatter.date(from: strDate)
        return dateObj!
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
        }
    }
    
    // Log Out
    class func logOut() {
        
        USERDEFAULTS.set("", forKey: "")
        
        let vc = kMainStoryBoard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
        //kAppDelegate.window?.rootViewController = vc
        //kAppDelegate.window?.makeKeyAndVisible()
        
    }
    
}



/******************************************************************************************************
                                        Model Class
******************************************************************************************************
 
 
 class loginData: NSObject,NSCoding {
 
 var currency_code:String = ""
 var city:String = ""
 var email:String = ""
 var emailverify:Int = 0
 var first_name:String = ""
 var last_name:String = ""
 
 override init() {
 
 }
 
 init(dic: NSDictionary){
 currency_code = dic["currency_code"] as? String ?? ""
 cancel_penalty = dic["cancel_penalty"] as? String ?? ""
 cancel_penalty_label = dic["cancel_penalty_label"] as? String ?? ""
 profile_image = dic["profile_image"] as? String ?? ""
 city = dic["city"] as? String ?? ""
 }
 required init(coder decoder: NSCoder) {
 self.currency_code = decoder.decodeObject(forKey: "currency_code") as? String ?? ""
 self.cancel_penalty = decoder.decodeObject(forKey: "cancel_penalty") as? String ?? ""
 self.cancel_penalty_label = decoder.decodeObject(forKey: "cancel_penalty_label") as? String ?? ""
 self.profile_image = decoder.decodeObject(forKey: "profile_image") as? String ?? ""
 self.city = decoder.decodeObject(forKey: "city") as? String ?? ""
 }
 
 func encode(with coder: NSCoder) {
 coder.encode(currency_code, forKey: "currency_code")
 coder.encode(cancel_penalty, forKey: "cancel_penalty")
 coder.encode(cancel_penalty_label, forKey: "cancel_penalty_label")
 coder.encode(profile_image, forKey: "profile_image")
 coder.encode(city, forKey: "city")
 }
 }
 
 
 
 self.user = loginData(dic:jsonDict["data"] as! NSDictionary)
 let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.user)
 UserDefaults.standard.set(encodedData, forKey: "LoginDetail")
 if let data = UserDefaults.standard.data(forKey: "LoginDetail"),
 let ud = NSKeyedUnarchiver.unarchiveObject(with: data) as? loginData{
 userDetails = ud
 CommonData.Alert(title: KAlertSuccessTitle, message: jsonDict["message"] as! String, viewController: self)
 _ = self.navigationController?.popViewController(animated: true)
 }
 
******************************************************************************************************/




/******************************************************************************************************
                                            Google & Facebook Login
 ******************************************************************************************************
// in app delegate
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
 GMSServices.provideAPIKey(Constant.googleAPIKey)
 // Initialize Google sign-in
 GIDSignIn.sharedInstance().clientID = Constant.kGoogleClientID
 
 }
 
 func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
 
 if url.scheme == Constant.kFBURLScheme {
 
 return FBSDKApplicationDelegate.sharedInstance().application(
 app,
 open: url as URL!,
 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
 annotation: nil)
 
 } else if url.scheme == Constant.kGoogleURLScheme {
 
 return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
 
 } else {
 
 return true
 
 }
 }
 
 
 func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
 
 // pass the url to the handle deep link call
 let branchHandled = Branch.getInstance().application(application,
 open: url,
 sourceApplication: sourceApplication,
 annotation: annotation
 )
 if (!branchHandled) {
 // If not handled by Branch, do other deep link routing for the Facebook SDK, Pinterest SDK, etc
 }
 
 // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
 if url.scheme == Constant.kFBURLScheme {
 
 return FBSDKApplicationDelegate.sharedInstance().application(
 application,
 open: url as URL!,
 sourceApplication: sourceApplication,
 annotation: annotation)
 
 } else if url.scheme == Constant.kGoogleURLScheme {

 return GIDSignIn.sharedInstance().handle(url,
 sourceApplication: sourceApplication,
 annotation: annotation)
 
 }
 
 
 return true
 
 }
 
 // in view controller
 
 import FBSDKCoreKit
 import FBSDKLoginKit
 import GoogleSignIn
 
 Required delegate GIDSignInDelegate, GIDSignInUIDelegate
 
override func viewDidLoad() {
    super.viewDidLoad()
    
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
 }
 
 
 @IBAction func btnGoogleLoginAction(_ sender: UIButton) {
 GIDSignIn.sharedInstance().signIn()
 }
 
 
 @IBAction func btnFBLoginAction(_ sender: UIButton) {
 let loginManager = FBSDKLoginManager()
 loginManager.loginBehavior = .native
 loginManager.logIn(withReadPermissions: [ "email" ], from: self) { (loginResult, error) in
 if error != nil {
 Utility.showAlert(Constant.ErrorMessage.kTitle, message: error!.localizedDescription)
 print(error!)
 } else {
 if loginResult!.grantedPermissions != nil &&
 loginResult!.grantedPermissions.contains("email") {
 self.getFBUserData()
 print("Logged in!")
 }
 }
 }
 }
 
 //function is fetching the user data
 func getFBUserData(){
 if FBSDKAccessToken.current() != nil {
 FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
 if (error == nil){
 print(result!)
 
 let dict = result as! [String : Any]
 let fullName = dict["name"] as! String
 //let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
 let fullNameArr = fullName.split(separator: " ").map(String.init)
 self.firstName = fullNameArr.first!
 self.lastName = fullNameArr.last ?? ""
 self.authID = dict["id"] as! String
 self.gender = dict["gender"] as? String ?? ""
 self.loginType = "facebook"
 self.callAPIForLoginUser()
 }
 })
 }
 }
 
 
 // MARK:- GIDSignIn Delegate Methods
 // Present a view that prompts the user to sign in with Google
 func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
 self.present(viewController, animated: true, completion: nil)
 }
 
 // Dismiss the "Sign in with Google" view
 func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
 self.dismiss(animated: true, completion: nil)
 }
 
 // MARK:- GIDSignIn Delegate Methods
 func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
 if let error = error {
 print("\(error.localizedDescription)")
 } else {
 // Perform any operations on signed in user here.
 print(user)
 /*
 let userId = user.userID                  // For client-side use only!
 let idToken = user.authentication.idToken // Safe to send to the server
 let fullName = user.profile.name
 let givenName = user.profile.givenName
 let familyName = user.profile.familyName
 let email = user.profile.email
 // ...
 print(userId, idToken, fullName, givenName, familyName, email)
 */
 
 self.firstName = user.profile.givenName
 self.lastName = user.profile.familyName
 self.authID = user.userID
 self.loginType = "google"
 self.callAPIForLoginUser()
 }
 }
 
******************************************************************************************************/



/******************************************************************************************************
                                            Notification error
 ******************************************************************************************************
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // application.isIdleTimerDisabled = true
    
    if #available(iOS 10, *) {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()
    }
        // iOS 9 support
    else if #available(iOS 9, *) {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }
        // iOS 8 support
        //        else if #available(iOS 8, *) {
        //            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        //            UIApplication.shared.registerForRemoteNotifications()
        //        }
        // iOS 7 support
    else {
        application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
    }
    deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    Fabric.with([Crashlytics.self])
    FirebaseApp.configure()
    // Override point for customization after application launch.
    IQKeyboardManager.sharedManager().enable = true
    IQKeyboardManager.sharedManager().enableAutoToolbar = true
    //IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
    GMSServices.provideAPIKey(GoogleAPIkey)
    GMSPlacesClient.provideAPIKey(GoogleAPIkey)
    locationManager.startMonitoringSignificantLocationChanges()
    if let data = UserDefaults.standard.data(forKey: "rideDetail"),let ud = NSKeyedUnarchiver.unarchiveObject(with: data) as? rideRequestModel
    {
        rideDetails = ud
    }
    if let data = UserDefaults.standard.data(forKey: "DriverLoginDetail"),let ud = NSKeyedUnarchiver.unarchiveObject(with: data) as? driverLoginData
    {
        driverDetails = ud
        print(ud)
    }
    if let data = UserDefaults.standard.data(forKey: "LoginDetail"),let ud = NSKeyedUnarchiver.unarchiveObject(with: data) as? loginData
    {
        userDetails = ud
    }
    else
    {
        //            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //            let rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        //            let navigationController = UINavigationController(rootViewController: rootViewController!)
        //            navigationController.isNavigationBarHidden = true
        //            self.window!.rootViewController = navigationController
        //            self.window!.makeKeyAndVisible()
    }
    
    
    return true
}
 
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 // Convert token to string
 let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
 
 
 let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
 print("APNs device token: \(deviceTokenString)")
 print(token)
 if deviceTokenString == ""{
 }
 else{
 device_token = deviceTokenString
 }
 }
 
 // Called when APNs failed to register the device for push notifications
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
 // Print the error to console (you should alert the user that registration failed)
 print("APNs registration failed: \(error)")
 }
 
 // Push notification received
 func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
 // Print notification payload data
 print("Push notification received: \(data)")
 if let aps = data[AnyHashable("aps")] as? NSDictionary
 {
 rideRequestNotification(aps:aps)
 }
 }
 func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
 if let aps = userInfo[AnyHashable("aps")] as? NSDictionary
 {
 rideRequestNotification(aps:aps)
 }
 }

 ******************************************************************************************************/

//
//  APIManager.swift
//
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Alamofire


class APIManager: NSObject {
    
    // Check internet connection
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // API Call Manager
    class func APICalling(_ url: String,_ parameters:NSMutableDictionary,isShowProgress:Bool = true, success:@escaping (NSDictionary)->()) {
        
        if isShowProgress {
            
            Utility.showProgress("")
        }
        
        //let jsonObject : NSMutableDictionary = NSMutableDictionary()
        //jsonObject.setObject(parameters, forKey: "data" as NSCopying)
        
        let headers = [ "Content-Type": "application/json" ]
        var request =  URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.allHTTPHeaderFields = headers
        
        if Utility.checkInternetConnection() {
            Alamofire.request(request).responseJSON { (response) in
                print("\n\n\nRequest URL :- \(request)\nParameters :- \(parameters)")
                
                if isShowProgress {
                    
                    Utility.dismissProgress()
                }
                
                if let jsonDict = response.result.value as? NSDictionary{
                    print("Response :- \(jsonDict)\n\n\n")
                    
                    let message  = jsonDict.value(forKey: "message") as! String
                    let status  = jsonDict.value(forKey: "status") as! String
                    
                    if status == "2"{
                        let okAction = UIAlertAction(title: "STR_OK".localized, style: .default, handler: { (action) in
                            Utility.logOut()
                        })
                        Utility.showAlert(Constant.ErrorMessage.kTitle, message: message, actions: [okAction])
                    } else {
                        success(jsonDict)
                    }
                    
                } else if response.error != nil {
                    print("Error :- \(response.error?.localizedDescription ?? Constant.ErrorMessage.kCommanError)\n\n\n")
                    Utility.showAlert(Constant.ErrorMessage.kTitle, message: Constant.ErrorMessage.kCommanError)
                } else {
                    Utility.showAlert(Constant.ErrorMessage.kTitle, message: Constant.ErrorMessage.kCommanError)
                }
            }
            
        } else {
            if isShowProgress {
                Utility.dismissProgress()
            }
            Utility.showAlert(Constant.ErrorMessage.kTitle, message: Constant.ErrorMessage.kNoInternetConnection)
        }
    }
    
    
    // Image Uploading
    class func fileUpload(images:NSMutableArray, videoURL:URL?, audioURL:URL? = nil, parameters:NSMutableDictionary, success:@escaping (NSDictionary)->(),progressHandler:@escaping(_ progress: Double)->Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerBackgroundTask()
        
        if Utility.checkInternetConnection() {
            Alamofire.upload(multipartFormData: { multipartFormData in
                for i in 0..<images.count {
                    
                    let rotatedImage = images[i] as! UIImage
                    /*
                    if let imgData = UIImageJPEGRepresentation(rotatedImage.fixOrientation(), 0.8) {
                        multipartFormData.append(imgData, withName: "image[]",fileName: "0\(i).jpg", mimeType: "image/jpg")
                    }
                    */
                    if let imgData = UIImagePNGRepresentation(rotatedImage) {
                        multipartFormData.append(imgData, withName: "image[]",fileName: "0\(i).png", mimeType: "image/jpg")
                    }
                }
                if videoURL != nil {
                    multipartFormData.append(videoURL!, withName: "video",fileName: "SelfIntroVideo.mp4", mimeType: "video/mp4")
                }
                if audioURL != nil {
                    multipartFormData.append(audioURL!, withName: "audio", fileName: "audio.m4a", mimeType: "audio/m4a")
                }
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                }
            }, to: Constant.ServerAPI.kImgUploadURL) { (result) in
                print("\n\n\nRequest URL :- \(Constant.ServerAPI.kImgUploadURL)\nParameters :- \(parameters)")
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        
                        //print("Upload Progress: \(progress.fractionCompleted)")
                        progressHandler(progress.fractionCompleted)
                        
                    })
                    
                    upload.responseJSON { response in
                        
                        if let jsonDict = response.result.value as? NSDictionary {
                            print("Response :- \(jsonDict)\n\n\n")
                            
                            let status  = jsonDict.value(forKey: "status") as! String
                            if status == "1"{

                                success(jsonDict)
                                
                            } else {
                                KVNProgress.dismiss()
                                let msg  = jsonDict.value(forKey: "message") as! String
                                Utility.showAlert(Constant.ErrorMessage.kTitle, message: msg)
                            }
                            
                        } else {
                            print("Error :- \(Constant.ErrorMessage.kCommanError)\n\n\n")
                            KVNProgress.dismiss()
                            Utility.showAlert(Constant.ErrorMessage.kTitle, message: Constant.ErrorMessage.kCommanError)
                        }
                        if response.error != nil {
                            print("Error :- \((response.error?.localizedDescription)!)\n\n\n")
                            KVNProgress.dismiss()
                            Utility.showAlert(Constant.ErrorMessage.kTitle, message: Constant.ErrorMessage.kCommanError)
                        }
                    }
                case .failure(let encodingError):
                    print("Error :- \(encodingError.localizedDescription)\n\n\n")
                    KVNProgress.dismiss()
                    Utility.showAlert(Constant.ErrorMessage.kTitle, message: Constant.ErrorMessage.kCommanError)
                }
                
            }
        } else {
            KVNProgress.dismiss()
            Utility.showAlert(Constant.ErrorMessage.kTitle, message: Constant.ErrorMessage.kNoInternetConnection)
        }
    }
    
    
    class func callWebServiceWithPOST(_ url: String, parameters: NSMutableDictionary?, isShowProgress:Bool = true, success:@escaping APIManagerResponseHandler, failure: APIManagerErrorHandler? = nil) {
        
        if  isShowProgress  {   Utility.showProgress(Constant.localization.alert_loading)   }
        
        DispatchQueue.main.async {
            
            if APIManager.isConnectedToNetwork() {
                
                let headers = [ "Content-Type": "application/json; charset=utf-8",
                                "Accept": "application/json",
                                /*"Authorization": "Bearer \(loginDetail.api_token)"*/
                    "Authorization": String(format: "Bearer %@", USERDEFAULT.value(forKey: "apiToken")as? String ?? "") ]// "Authorization": "Bearer \(loginDetail.api_token)"
                
                
                // create post request
                let request = NSMutableURLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                if let param = parameters {
                    request.httpBody = try? JSONSerialization.data(withJSONObject: param.mutableCopy())
                }
                
                let task = URLSession.shared.dataTask(with: request.mutableCopy() as! URLRequest, completionHandler: { (data, response, error) in
                    
                    if isShowProgress { Utility.dismissProgress() }
                    print("\n\n\nRequest URL :- \(url)\nParameters :- \(String(describing: parameters))")
                    
                    let httpResponse = response as? HTTPURLResponse
                    
                    if error != nil {
                        Utility.showAlertWithAction(Appname, message: Constant.ErrorMessage.kCommanError)
                        if failure != nil {
                            failure!(error?.localizedDescription ?? Constant.ErrorMessage.kCommanError)
                        }
                        print("Error :- \(error?.localizedDescription ?? Constant.ErrorMessage.kCommanError)\n\n\n")
                    } else if httpResponse?.statusCode == 500 {
                        Utility.showAlertWithAction(Appname, message: Constant.ErrorMessage.kCommanError)
                        if failure != nil {
                            failure!(Constant.ErrorMessage.kCommanError)
                        }
                        print("Error :- \(Constant.ErrorMessage.kCommanError)\n\n\n")
                        
                    } else if httpResponse?.statusCode == 401  || httpResponse?.statusCode == 403 {
                        print("Forbidden")
                        
                        let LogoutAction = UIAlertAction(title: Constant.localization.alert_ok, style: .default) { (action) in
                            //Utility.logOut()
                        }
                        Utility.showAlertWithAction(Appname, message: "ALERT_SESSION_EXPIRE".localized, actions: [LogoutAction])
                    } else
                        
                        if let data = data {
                            do {
                                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? Any {
                                    //print(jsonResult)
                                    
                                    if let dic = jsonResult as? NSDictionary {
                                        if httpResponse?.statusCode == 200
                                        {
                                            success(jsonResult)
                                        }
                                        else {
                                            let message = dic.value(forKey: "message") as? String ?? ""
                                            print("Error :- \(message)\n\n\n")
                                            Utility.showAlertWithAction(Appname, message: message)
                                            if failure != nil {
                                                failure!(message)
                                            }
                                        }
                                    } else if jsonResult is NSArray {
                                        success(jsonResult)
                                    } else {
                                        if isShowProgress {
                                            Utility.showAlertWithAction(Appname, message: Constant.ErrorMessage.kCommanError)
                                        }
                                        if failure != nil {
                                            failure!(Constant.ErrorMessage.kCommanError)
                                        }
                                        print("Error :- \(Constant.ErrorMessage.kCommanError)\n\n\n")
                                    }
                                } else {
                                    Utility.showAlertWithAction(Appname, message: Constant.ErrorMessage.kCommanError)
                                    if failure != nil {
                                        failure!(Constant.ErrorMessage.kCommanError)
                                    }
                                    print("Error :- \(Constant.ErrorMessage.kCommanError)\n\n\n")
                                }
                            } catch let error as NSError {
                                Utility.showAlertWithAction(Appname, message: Constant.ErrorMessage.kCommanError)
                                if failure != nil {
                                    failure!(error.localizedDescription)
                                }
                                print("Error :- \(error.localizedDescription)\n\n\n")
                            }
                    }
                })
                task.resume()
            } else {
                Utility.dismissProgress()
                // No Internet Connection
                if isShowProgress {
                    Utility.showAlertWithAction(Appname, message: Constant.ErrorMessage.kNoInternetConnection)
                }
                if failure != nil {
                    failure!(Constant.ErrorMessage.kNoInternetConnection)
                }
            }
        }
    }
    
    
    //MARK: - API Call
    func imageUpload()
    {
        if currentReachabilityStatus != .notReachable
        {
            CommonData.showProgress("")
            let imgData = UIImageJPEGRepresentation(imgProfile.image!, 0.7)!
            let parameters = ["image_type": "1"]
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "name",fileName: "\(userDetails.user_id).jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            },to:"\(ApiImageUploadStart)/upload1.php")
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        print(response.result.value ?? "")
                        if let jsonResponse = response.result.value as? [String: Any] {
                            //CommonData.dismissProgress()
                            print(jsonResponse)
                            //let dataDic = jsonResponse["data"] as! NSDictionary
                            //let temparr = dataDic["image"] as! NSArray
                            //self.imagename = temparr[0] as! String
                        }
                    }
                case .failure(let encodingError):
                    CommonData.dismissProgress()
                    print(encodingError)
                }
            }
        }
        else
        {
            CommonData.Alert(title: Kno_Internet, message: "", viewController: self)
        }
        
    }
    
}


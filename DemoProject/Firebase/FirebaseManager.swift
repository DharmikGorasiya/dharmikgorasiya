//
//  FirebaseManager.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 16/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Foundation

var reference: DatabaseReference!
protocol FBMessageDelegate{
    func receivedNewMessage(message:Message)
}

class FirebaseManager: NSObject {
    
    var delegate:FBMessageDelegate?
    var shared = FirebaseManager()
    private override init()
    {
    }
    //Mobile Authentication
    func SendOTP(phoneNo:String,completion:@escaping ((_ isSuccess:Bool, _ verificationID:String) -> ()))
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNo, uiDelegate: nil) { (verificationID, error) in
            if let error = error
            {
                Utility.showAlert("ALERT_TITLE".localized, message: error.localizedDescription)
                return
            }
            completion(true,verificationID!)
        }
    }
    
    func verificationOTP(verificationCode:String,verificationID:String, completion: @escaping(_ isSuccess:Bool, _ result: AuthDataResult) -> ())
    {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
           
            if(error == nil && result?.user != nil)
            {
                Utility.dismissProgress()
                completion(true,result!)
                //self.loginOnQuickblox(result!.user)
            }
            else{
                Utility.dismissProgress()
                if let error = error {
                    print(error)
                    Utility.showAlert("ALERT_TITLE".localized, message: error.localizedDescription)
                    return
                }
            }
        }
    }
    
    func getAllMessage(completion: @escaping (([Message]?) -> Void)) {
        
        FIRRefrence.refChat.child(FIRRefrence.messageList).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            if let arrChat = snapshot.value as?  [NSDictionary]
            {
                completion(arrChat.map(Message.init))
                self.getMessages()
            }
            else
            {
                completion(nil)
            }
        }
    }
    
    func sendMessage(dicMessage:NSDictionary,completion: @escaping (_ isSuccess:Bool)->())
    {
        FIRRefrence.refChat.child(FIRRefrence.messageList).updateChildValues(dicMessage as! [String : Any])
        completion(true)
    }
    
    func getMessages()
    {
        FIRRefrence.refChat.child(FIRRefrence.messageList).removeAllObservers()
        FIRRefrence.refChat.child(FIRRefrence.messageList).observe(.value) { (snapshot) in
            print(snapshot)
            if let dic = snapshot.value as? NSDictionary {
                self.delegate?.receivedNewMessage(message: Message.init(dictionary: dic))
            }
        }
    }
}

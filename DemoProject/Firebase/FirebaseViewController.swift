//
//  FirebaseViewController.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 16/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class FirebaseViewController: UIViewController {

    @IBOutlet weak var verifyOTPOuterview: UIView!
    @IBOutlet weak var sendOTPOuterview: UIView!
    @IBOutlet weak var txtMobileNumer: UITextField!
    @IBOutlet weak var txtOTP: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private Method
    func setDefault()
    {
        verifyOTPOuterview.isHidden = true
        sendOTPOuterview.isHidden = false
    }
    
    //MARK: - Button Action
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        firebaseMobileAuthentication()
    }
    @IBAction func btnResendOTP(_ sender: Any) {
        sendOtp()
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        verifyOTPOuterview.isHidden = true
    }
    @IBAction func btnSendOTPTapped(_ sender: Any) {
        sendOtp()
    }
    
    func firebaseMobileAuthentication()
   {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
      /*  FirebaseManager.verificationOTP(verificationCode: txtOTP.text!, verificationID: verificationID!) { (isSuccess, result) in
            print(result)
            print("Login success")
        }*/
    }
    
    func sendOtp()
    {
        if txtMobileNumer.text == ""
        {
            Utility.showAlert("ALERT_TITLE".localized, message: "ALERT_MSG_BLANK_PHONE".localized)
        }
        else
        {
            let phoneNumber = "\(+91)" + txtMobileNumer.text!
            /*FirebaseManager.SendOTP(phoneNo: phoneNumber) { (isSuccess, verificationCode) in
                if(isSuccess)
                {
                    UserDefaults.standard.set(verificationCode, forKey: "authVerificationID")
                    self.verifyOTPOuterview.isHidden = false
                    self.sendOTPOuterview.isHidden = true
                }
            }*/
        }
    }

}

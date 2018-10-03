//
//  ViewController.swift
//  DemoProject
//
//  Created by Dharmik on 18/08/18.
//  Copyright © 2018 Foursense. All rights reserved.
//

import UIKit
import Alamofire
protocol myCustomeDelegate {
    func selectedHobbie(arrHobbie: NSMutableArray)
}

class ViewController1: UIViewController, myCustomeDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextController() {
        let vc2 = kMainStoryBoard.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        vc2.dataReturnBlock = { (_ param1: String,_ param2: String) in
            print("")
        }
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    func returnData(_ param1: String,_ param2: String) {
        print("")
    }
    
   /* func nextController() {
        let vc2 = kMainStoryBoard.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        vc2.delegate = self
        self.navigationController?.pushViewController(vc2, animated: true)
    }*/
    
    func selectedHobbie(arrHobbie: NSMutableArray) {
        print(arrHobbie)
    }

}
class ViewController2: UIViewController {
    
    var dataReturnBlock: ((String,String)->())?
    var delegate: myCustomeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "") as! ViewController3
        vc.completeReturnBlock = { (data)  in
            print(data)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoReturn() {
        if dataReturnBlock != nil {
            dataReturnBlock!("","")
        }
        
    }
    
    func submit() {
        delegate?.selectedHobbie(arrHobbie: ["",""])
    }
}
class ViewController3: UIViewController {
    
    var completeReturnBlock: ((String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returndata()
    {
        if completeReturnBlock != nil
        {
            completeReturnBlock!("Hello")
        }
    }
    func nextController() {
        let vc2 = kMainStoryBoard.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    func returnData(_ param1: String,_ param2: String) {
        
    }
    
}
////////
//MARK:- Custom Delegate

protocol recordChangeDelegate {
    func selectedHobbie(str:String)
}

class DisplayVC : UIViewController,recordChangeDelegate
{
    func btnUpdateVC()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeVC") as! ChangeVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func selectedHobbie(str:String)
    {
        print(str)
    }
}

class ChangeVC:UIViewController
{
    var delegate:recordChangeDelegate?
    
    func btnChangeClick()
    {
        delegate?.selectedHobbie(str: "Hello")
    }
}

//MARK:- BLock

class DisplayVC : UIViewController
{
    func btnUpdateVC()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeVC") as! ChangeVC
        vc.blockName = {(str) in
            print(str)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
}

class ChangeVC:UIViewController
{
    var blockName:((String)->())?
    
    func btnChangeClick()
    {
        if(blockName != nil)
        {
            return blockName("Hello")
        }
    }
}
////////////
class myApiCalling:NSObject
{
    class func apiCalling(url:String,Parameter:NSMutableDictionary,isProgress:Bool = true, success:@escaping (NSDictionary) -> (), error:@escaping (String) -> ())
    {
        let header = ["Content-Type":"Application/json"]
        Utility.showProgress("")
        var request = URLRequest(url: URL(string: "")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: Parameter)
        request.allHTTPHeaderFields = header
        
        Alamofire.request(request).responseJSON { (response) in
            
            if let data = response.result.value as? NSDictionary
            {
                success(data)
            }
            else if(response.error != nil)
            {
                myApiCalling.showAlert(message: "gfgf", title: "fdfd")
            }
        }
        
    
        
    }
    
    class func showAlert(message:String,title:String,action: [UIAlertAction] = [UIAlertAction(title: "ok", style: .cancel, handler: nil)])
    {
        var alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        for actions in action
        {
            alert.addAction(actions)
        }
        
        let vc = UIApplication.shared.delegate?.window!?.rootViewController as! UINavigationController
        vc.present(alert, animated: true, completion: nil)
    }
}


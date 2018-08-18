//
//  ViewController.swift
//  DemoProject
//
//  Created by Dharmik on 18/08/18.
//  Copyright © 2018 Foursense. All rights reserved.
//

import UIKit

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
    
    func nextController() {
        let vc2 = kMainStoryBoard.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        vc2.delegate = self
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    func selectedHobbie(arrHobbie: NSMutableArray) {
        print(arrHobbie)
    }

}
class ViewController2: UIViewController {
    
    var dataReturnBlock: ((String,String)->())?
    var delegate: myCustomeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    func returnData(_ param1: String,_ param2: String) {
        
    }
    
}

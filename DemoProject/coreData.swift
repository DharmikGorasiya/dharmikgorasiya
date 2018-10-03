//
//  coreData.swift
//  DemoProject
//
//  Created by Dharmik on 03/10/18.
//  Copyright © 2018 Foursense. All rights reserved.
//

import UIKit
import CoreData
let managedContext = appDelegate.persistentContainer.viewContext
class coreData: NSObject {

    var arrData = [Registration]()
    var arrRegisterData = [Registration]()
    var editDicRegisterData: Registration?
    var path:Array=NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let directory:String=path[0]
    
    
    func UpdateRecord()
    {
        if let data = editDicRegisterData
        {
            data.name = txtName.text
            data.mobile = txtMobile.text
            data.password = txtPassword.text
            data.email = txtEmail.text
            appDelegate.saveContext()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func InsertRecord()
    {
        let registration_in = Registration(context: managedContext)
        registration_in.email = txtEmail.text
        registration_in.id = 5
        registration_in.password = txtPassword.text
        registration_in.mobile = txtMobile.text
        registration_in.name = txtName.text
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectRecord()
    {
        do {
            self.arrData =  try managedContext.fetch(Registration.fetchRequest())
            tblRegistrationDataDisplay.reloadData()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func deleteRecord()
    {
        managedContext.delete(self.arrData[indexPath.row])
        appDelegate.saveContext()
        self.fetchData()
    }
}



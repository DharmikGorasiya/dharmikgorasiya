//
//  SQLLite.swift
//  DemoProject
//
//  Created by Dharmik on 03/10/18.
//  Copyright © 2018 Foursense. All rights reserved.
//

import UIKit
import SQLite3
var stmt:OpaquePointer?
var db: OpaquePointer?

class SQLLite: NSObject {
    static let shared = SQLLite()
    
    private override init() {
        super.init()
    }
    
    func createDataBase()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("UserDetail.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            print(fileURL)
        }
        else
        {
            createTable()
            print(fileURL)
        }
        
    }
    
    func createTable()
    {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS \(Registration_tbl.UserDetail) (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, mobile TEXT, address TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        else
        {
            print("UserDetail Table Created Success..!!")
        }
    }

    
    func update()
    {
        stmt = nil
        let name:NSString = txtName.text! as NSString
        let mobile:NSString = txtMobile.text! as NSString
        let email:NSString = txtEmail.text! as NSString
        let address:NSString = txtAddress.text! as NSString
        
        if let data = editDicRegisterData
        {
            let queryString = "UPDATE UserDetail SET name = '\(name)', email = '\(email)', address = '\(address)', mobile = '\(mobile)'  WHERE id = \(data.id);" //"UPDATE \(Registration_tbl.UserDetail) SET name = '\(name)', email = '\(email)', address = '\(address)', mobile = '\(mobile)' WHERE id = \(data.id) ;"
            
            
            print(queryString)
            var updateStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, queryString, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Successfully updated row.")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Could not update row.")
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                }
            } else {
                print("UPDATE statement could not be prepared")
            }
            sqlite3_finalize(updateStatement)
        }
    }
    
    func insert()
    {
        let queryString = "INSERT INTO \(Registration_tbl.UserDetail) (name,email,mobile,address) VALUES (?,?,?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        sqlite3_bind_text(stmt, 1, name.utf8String, -1, nil)
        sqlite3_bind_text(stmt, 2, email.utf8String, -1, nil)
        sqlite3_bind_text(stmt, 4, address.utf8String, -1, nil)
        sqlite3_bind_text(stmt, 3, mobile.utf8String, -1, nil)
        //sqlite3_bind_int(stmt, 1, id)
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        sqlite3_finalize(stmt)
    }
    
    func QueryExecution(queryString:String, Success:@escaping (OpaquePointer) -> ())
    {
        print(queryString)
        stmt = nil
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        else
        {
            Success(stmt!)
        }
        sqlite3_finalize(stmt)
    }
}

struct Registration_tbl {
    static let UserDetail = "UserDetail"
    static let tblRegistration = "Registration"
    static let name = "name"
    static let password = "password"
    static let email = "email"
    static let mobile = "mobile"
    static let id = "id"
    static let address = "address"
}
class RegisterModel:NSObject
{
    var name = ""
    var email = ""
    var address = ""
    var mobile = ""
    var id = 0
    
    init(data:NSMutableDictionary) {
        /* let id = sqlite3_column_int(stmt, 0)
         let name = String(cString: sqlite3_column_text(stmt, 1))
         let email = String(cString: sqlite3_column_text(stmt, 2))
         let mobile = String(cString: sqlite3_column_text(stmt, 3))
         let address = String(cString: sqlite3_column_text(stmt, 4))*/
        id = data[Registration_tbl.id] as? Int ?? 0
        name =  data[Registration_tbl.name] as? String ?? ""//String(cString: sqlite3_column_text(data, 1))
        email = data[Registration_tbl.email] as? String ?? ""//String(cString: sqlite3_column_text(data, 2))
        mobile =  data[Registration_tbl.mobile] as? String ?? ""//String(cString: sqlite3_column_text(data, 3))
        address = data[Registration_tbl.address] as? String ?? ""//String(cString: sqlite3_column_text(data, 4))
    }
}

/**
 * Class BasicFunctions.swift
 * @package     Application
 * @author      Arslan Ali
 * @email       marslan.ali@gmail.com
 */


import UIKit
import MBProgressHUD
import SQLite3

class BasicFunctions: NSObject {
    
    // Display Alert on App.
    class func showAlert(vc:UIViewController!, msg:String!)
    {
        let alertController = UIAlertController(title:nil , message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        vc.present(alertController, animated: true, completion: nil)
        
    }
    
    // Display Activity Indicator
    class func showActivityIndicator(vu : UIView) -> Void
    {
        _ = MBProgressHUD.showAdded(to: vu, animated: true)
        
    }
    class func stopActivityIndicator(vu : UIView) -> Void
    {
        MBProgressHUD.hide(for: vu, animated: true)
        
        
    }
    
//    class func pushVCinNCwithName(_ vcName: String?, popTop: Bool) {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        var navController = appDelegate?.window?.rootViewController as! UINavigationController
//        let topVC : UIViewController?  = navController.visibleViewController
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc: UIViewController? = storyboard.instantiateViewController(withIdentifier: vcName ?? "")
//        //  if (popTop) [navController popViewControllerAnimated:NO];
//        if let aVc = vc {
//            navController.pushViewController(aVc, animated: true)
//        }
//        if popTop {
//            var navigationArray = navController.viewControllers
//
//            for i in 0...navigationArray.count {
//                if (navigationArray[i].isKind(of: (topVC?.classForCoder)!)) {
//                    navigationArray.remove(at: i)
//                    break
//                }
//            }
//            if let anArray = navigationArray {
//                navController?.setViewControllers(anArray, animated: false)
//            }
//        }
//
//    }
//
//    class func pushVCinNCwithObject(vc: UIViewController?, popTop: Bool) {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        var navController = appDelegate?.window?.rootViewController as? UINavigationController
//        if navController == nil
//        {
//            navController = (appDelegate?.window?.rootViewController as? PGSideMenu)?.contentController as? UINavigationController
//        }
//        let topVC : UIViewController?  = navController?.visibleViewController
//        if (topVC?.className == vc?.className) {
//            return
//        }
//
//        navController?.pushViewController(vc!, animated: true)
//
//        if popTop {
//            var navigationArray = navController?.viewControllers
//
//            for i in 0...navigationArray!.count {
//                if (navigationArray![i].isKind(of: (topVC?.classForCoder)!)) {
//                    navigationArray?.remove(at: i)
//                    break
//                }
//            }
//            if let anArray = navigationArray {
//                navController?.setViewControllers(anArray, animated: false)
//            }
//        }
//
//    }
    
    // Open Database
    class func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("RouteData.sqlite")
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(fileURL.path)")
            return db
        } else {
            print("Unable to open database.")
            
        }
        return nil
    }
    
    // Create Table
    class func createTable(db : OpaquePointer?) {
        
        
        let createTableString = """
                                CREATE TABLE IF NOT EXISTS Routes(Id INT PRIMARY KEY NOT NULL,
                                Name CHAR(255), Vehicle CHAR(255), Distance CHAR(255), Routine CHAR(255), StartTime CHAR(255), EndTime CHAR(255), Price CHAR(255), Coordinates CHAR(255));
                                """
        
        
        
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Routes table created.")
            } else {
                print("Routes table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
        
    }
    
    // Insert Data
    class func insert(id : Int32 , name : NSString , vehicle : NSString, distance : NSString, routine : NSString, startTime : NSString , endTime : NSString, price : NSString, coordinates : NSString, db : OpaquePointer?) {
        
        
        let insertStatementString = "INSERT INTO Routes (Id, Name, Vehicle, Distance, Routine, StartTime, EndTime, Price, Coordinates) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_reset(insertStatement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error resetting prepared statement: \(errmsg)")
        }
        
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, vehicle.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, distance.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, routine.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, startTime.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, endTime.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, price.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, coordinates.utf8String, -1, nil)
            
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    // Delete Data
    class func delete()
    {
        
        let db = self.openDatabase()
        
        let deleteStatementStirng = "DELETE FROM Routes;"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    // Make query
    class func query()
    {
        
        kRouteList.removeAll()
        
        
        let db = self.openDatabase()
        
        let queryStatementString = "SELECT * FROM Routes;"
        
        
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while(sqlite3_step(queryStatement) == SQLITE_ROW){
                
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                let vehicle = String(cString: queryResultCol2!)
                
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                let distance = String(cString: queryResultCol3!)
                
                let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                let routine = String(cString: queryResultCol4!)
                
                let queryResultCol5 = sqlite3_column_text(queryStatement, 5)
                let startTime = String(cString: queryResultCol5!)
                
                let queryResultCol6 = sqlite3_column_text(queryStatement, 6)
                let endTime = String(cString: queryResultCol6!)
                
                let queryResultCol7 = sqlite3_column_text(queryStatement, 7)
                let price = String(cString: queryResultCol7!)
                
                let queryResultCol8 = sqlite3_column_text(queryStatement, 8)
                let coordinates = String(cString: queryResultCol8!)
                
                
                let routeData = RouteData()
                routeData.name = name
                routeData.vehicle = vehicle
                routeData.distance = distance
                routeData.routine = routine
                routeData.startTime = startTime
                routeData.endTime = endTime
                routeData.price = price
                routeData.coordinates = coordinates
                
                kRouteList.append(routeData)
                
                
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        
    }
    
    // Delete specific roe
    class func deleteSpecificRow(rowId: Int32)
    {
        let db = self.openDatabase()
        
        let deleteStatementStirng = "DELETE FROM Routes WHERE id = ?;"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteStatement, 1, rowId)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        
        
        
        sqlite3_finalize(deleteStatement)
    }

    
    

}

//
//  AppDelegate.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-01-28.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // Override point for customization after application launch.
        do {
            _ =  try Realm()
        } catch {
            print("there was an error, \(error)")
        }
        
        
        return true
    }

    
}


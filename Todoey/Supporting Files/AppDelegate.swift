//
//  AppDelegate.swift
//  Todoey
//
//  Created by Dustin Prevatt on 12/8/18.
//  Copyright © 2018 Dustin Prevatt. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Realm DB Location
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        do {
            _ = try Realm()
        } catch {
            print("An error occurred initializing realm: \(error)")
        }
        
        
        return true
    }

    

}


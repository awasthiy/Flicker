//
//  AppDelegate.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 19/06/20.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mode = NaiveDarkAndLightMode.current()
        NaiveDarkAndLightMode.applyMode(mode: mode)
        
        return true
    }
}


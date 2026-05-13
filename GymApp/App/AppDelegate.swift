//
//  AppDelegate.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 29/07/25.
//

import Foundation
import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAppCheck


class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
}

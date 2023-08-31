//
//  FBRealTimeDemoApp.swift
//  FBRealTimeDemo
//
//  Created by Saheem Hussain on 24/08/23.
//

import SwiftUI
import FirebaseCore

@main
struct FBRealTimeDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        FirebaseApp.configure()
        return true
    }
}

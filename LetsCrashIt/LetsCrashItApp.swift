//
//  LetsCrashItApp.swift
//  LetsCrashIt
//
//  Created by Pavankumar Arepu on 25/05/24.
//

import SwiftUI

@main
struct LetsCrashItApp: App {
    // Integrate AppDelegate
      @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

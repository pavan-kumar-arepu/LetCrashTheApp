//
//  AppDelegate.swift
//  LetsCrashIt
//
//  Created by Pavankumar Arepu on 25/05/24.
//

import Foundation
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NSSetUncaughtExceptionHandler(handleUncaughtException)
        return true
    }
}

func handleUncaughtException(_ exception: NSException) {
    let crashReport = """
    Name: \(exception.name.rawValue)
    Reason: \(exception.reason ?? "No reason provided")
    UserInfo: \(exception.userInfo ?? [:])
    CallStack: \(exception.callStackSymbols)
    """
    UserDefaults.standard.set(crashReport, forKey: "crashReport")
    UserDefaults.standard.synchronize()
}

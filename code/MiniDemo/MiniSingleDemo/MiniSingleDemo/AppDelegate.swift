//
//  AppDelegate.swift
//  MiniSingleDemo
//
//  Created by EzioChan on 2025/11/24.
//

import UIKit
import JLLogHelper
import JL_OTALib
import JL_AdvParse
import JL_HashPair

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        JLLogManager.clearLog()
        JLLogManager.setLog(true, isMore: false, level: .DEBUG)
        JLLogManager.saveLog(asFile: true)
        JLLogManager.log(withTimestamp: true)
        JL_OTAManager.logSDKVersion()
        JLAdvParse.sdkVersion()
        JLHashHandler.sdkVersion()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


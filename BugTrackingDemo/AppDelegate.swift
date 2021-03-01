//
//  AppDelegate.swift
//  BugTrackingDemo
//
//  Created by Sean Wong on 25/2/2021.
//

import UIKit
import raygun4apple
import Sentry
import Bugsee

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    initRaygun()
    initSentry()
    initBugsee()
    
    return true
  }
  
  private func initRaygun() {
    let raygunClient = RaygunClient.sharedInstance(apiKey:"NKzUE4DFQNCgCZG31vQdQ")
    raygunClient.enableCrashReporting()
    raygunClient.enableRealUserMonitoring()
    raygunClient.enableNetworkPerformanceMonitoring()
    
    raygunClient.beforeSendMessage = { (message) in
      if (message.details.error.className == "NotImplementedException") {
        return false // Don't send the report
      }
      return true
    }
  }
  
  private func initSentry() {
    SentrySDK.start { options in
        options.dsn = "https://e3dffd0aa62f466da187f5b4767fc8fd@o531073.ingest.sentry.io/5651308"
        options.debug = true // Enabled debug when first installing is always helpful
    }
  }
  
  private func initBugsee() {
    Bugsee.launch(token:"fb806c3c-9016-402e-bbaa-d229117f74d7")
  }
}


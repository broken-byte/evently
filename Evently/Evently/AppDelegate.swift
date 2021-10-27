//
//  AppDelegate.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/9/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        guard let eventsTableVC = UIStoryboard(
//            name: Constants.mainStoryBoardIdentifier,
//            bundle: Bundle.main
//        ).instantiateInitialViewController() as? EventsTableViewController
//        else {
//            fatalError("Unable to Instantiate Root View Controller")
//        }
//
//        let dateTimeFormatter = DateTimeFormatter()
//        let urlSession = URLSession(configuration: .default)
//        let eventApiManager = EventAPIManager(
//            urlSession: urlSession,
//            dateTimeFormatter: dateTimeFormatter
//        )
//
//        let imageLoader = ImageLoader(urlSession: urlSession)
//        let uiImageLoadingOrchestrator = UiImageViewLoadingOrchestrator(
//            imageLoader: imageLoader,
//            dispatchQueue: DispatchQueue.main
//        )
//
//        eventsTableVC.eventApiManager = eventApiManager
//        eventsTableVC.uiImageLoadingOrchestrator = uiImageLoadingOrchestrator
//
//        window?.rootViewController = eventsTableVC
//
//        // Make Key and Visible
//        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


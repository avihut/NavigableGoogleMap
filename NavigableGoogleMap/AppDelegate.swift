//
//  AppDelegate.swift
//  NavigableGoogleMap
//
//  Created by Avihu Turzion on 10/03/2018.
//  Copyright © 2018 Avihu Turzion. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

struct APIKeys {
    static let googleMaps = "AIzaSyDhrKrefOK_d1xGS745rM4UoT-ik7D1xf4"
    
    private init() {}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(APIKeys.googleMaps)   
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NavigableGoogleMap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

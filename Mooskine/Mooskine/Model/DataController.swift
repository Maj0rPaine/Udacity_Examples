//
//  DataController.swift
//  Mooskine
//
//  Created by Chris Paine on 1/29/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persisentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persisentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persisentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        backgroundContext = persisentContainer.newBackgroundContext()
        
        // Set merge changes and policies
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        // Background context has authority over foreground
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        // Foreground context will follow what's in store
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persisentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError()
            }

            self.autoSaveViewContext()
            self.configureContexts()

            completion?()
        }
    }
}

extension DataController {

    /**
     Auto save view context. Default time interval is 30 seconds.
     
     Parameters:
        - interval: The time interval to save view context
    */
    func autoSaveViewContext(interval: TimeInterval = 30) {
        print("autosaving")

        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }

        viewContext.saveChanges()

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}

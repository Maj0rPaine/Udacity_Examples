//
//  ManagedContext+NSManagedContext.swift
//  Mooskine
//
//  Created by Chris Paine on 1/29/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func saveChanges() {
        // Only save if there are uncommitted changes
        if self.hasChanges {
            // TODO: Handle errors
            try? save()
        }
    }
}

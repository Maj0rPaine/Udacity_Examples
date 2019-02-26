//
// Created by Chris Paine on 2019-02-01.
// Copyright (c) 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListDataSource<EntityType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    var tableView: UITableView!
    
    var manageObjectContext: NSManagedObjectContext!
    
    var fetchRequest: NSFetchRequest<EntityType>!

    var fetchedResultsController: NSFetchedResultsController<EntityType>!
    
    var cacheName: String!

    var configure: ((CellType, EntityType) -> Void)!
    
    var selectedObject: EntityType? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return fetchedResultsController.object(at: indexPath)
    }

    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<EntityType>, cacheName: String = "", configure: @escaping (CellType, EntityType) -> Void) {
        super.init()
        self.tableView = tableView
        self.manageObjectContext = managedObjectContext
        self.fetchRequest = fetchRequest
        self.cacheName = cacheName
        self.configure = configure
        
        tableView.dataSource = self
        
        fetchedResultsController = NSFetchedResultsController<EntityType>(fetchRequest: fetchRequest, managedObjectContext:manageObjectContext, sectionNameKeyPath: nil, cacheName: cacheName)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    deinit {
        fetchedResultsController = nil
    }
    
    func deleteEntity(at indexPath: IndexPath) {
        let entityToDelete = fetchedResultsController.object(at: indexPath)
        manageObjectContext.delete(entityToDelete)
        manageObjectContext.saveChanges()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.defaultReuseIdentifier, for: indexPath) as! CellType
        configure(cell, entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteEntity(at: indexPath)
        default: () // Unsupported
        }
    }
    
    // MARK: NSFetchedResultsController

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

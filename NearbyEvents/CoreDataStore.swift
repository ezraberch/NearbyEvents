//
//  CoreDataStore.swift
//  NearbyEvents
//
//  Created by Ezra Berch on 1/1/19.
//  Copyright © 2019 Ezra Berch. All rights reserved.
//

//
//  CoreDataStore.swift
//  Virtual Tourist
//
//  Created by Ezra Berch on 8/12/18.
//  Copyright © 2018 Ezra Berch. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStore {
    
    // MARK: - Core Data stack
    static let shared = CoreDataStore()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchEvents(completionHandler: @escaping ([SavedEvent], Error?) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            do {
                let fetchRequest = NSFetchRequest<SavedEvent>(entityName: "SavedEvent")
                let results = try context.fetch(fetchRequest)
                completionHandler(results, nil)
            } catch {
                completionHandler([], NSError(domain: "fetchEvents", code: 1, userInfo: [:]))
            }
        }
    }
    
    func checkID(id: String, completionHandler:@escaping (SavedEvent?) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            do {
                let fetchRequest = NSFetchRequest<SavedEvent>(entityName: "SavedEvent")
                fetchRequest.predicate = NSPredicate(format: "id = %@", id)
                let results = try context.fetch(fetchRequest)
                completionHandler(results.count>0 ? results[0] : nil)
            } catch {
                completionHandler(nil)
            }
        }
    }
    
    func toggleEvent(event: Event, completionHandler: @escaping (Bool) -> Void) {
        let context = persistentContainer.viewContext
        
        self.checkID(id: event.id) {result in
            if let result = result {
                context.perform {
                    context.delete(result)
                    self.saveContext()
                    completionHandler(false)
                }
            } else {
                context.perform {
                    let savedEvent = SavedEvent(context: context)
                    savedEvent.id = event.id
                    savedEvent.eventDescription = event.description
                    savedEvent.title = event.title
                    savedEvent.url = event.url
                    savedEvent.latittude = event.latitude
                    savedEvent.longitude = event.longitude
                    savedEvent.start_time = event.start_time
                    savedEvent.stop_time = event.stop_time
                    self.saveContext()
                    completionHandler(true)
                }
            }
        }
    }
    
    func deleteEvent(event: SavedEvent, completionHandler: @escaping ([SavedEvent], Error?) -> Void) {
        let context = persistentContainer.viewContext

        context.perform {
            context.delete(event)
            self.saveContext()
            self.fetchEvents(completionHandler: completionHandler)
        }
    }
}

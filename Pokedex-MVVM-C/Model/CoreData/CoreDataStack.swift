//
//  CoreDataStack.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import CoreData
import Foundation

class CoreDataStack {
	static let modelName = "FavoritePokemon"
	static let shared = CoreDataStack()
	public static let model: NSManagedObjectModel = {
		let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}()
	
	private init() { }
	
	lazy var mainContext: NSManagedObjectContext = {
		self.storeContainer.viewContext
	}()
	
	lazy var storeContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error: \(error), \(error.userInfo)")
			}
		}
		container.viewContext.automaticallyMergesChangesFromParent = true
		return container
	}()
	
	func newDerivedContext() -> NSManagedObjectContext {
		storeContainer.newBackgroundContext()
	}
	
	func saveContext() {
		saveContext(mainContext)
	}
	
	func saveContext(_ context: NSManagedObjectContext) {
		if context != mainContext {
			saveDerivedContext(context)
			return
		}
		
		context.perform {
			do {
				try context.save()
			} catch let error as NSError {
				fatalError("Unresolved error: \(error), \(error.userInfo)")
			}
		}
	}
	
	func saveDerivedContext(_ context: NSManagedObjectContext) {
		context.perform {
			do {
				try context.save()
			} catch let error as NSError {
				fatalError("Unresolved error: \(error), \(error.userInfo)")
			}
			self.saveContext(self.mainContext)
		}
	}
}

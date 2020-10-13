//
//  CoreDataTests.swift
//  Pokedex-MVVM-CTests
//
//  Created by Chad Rutherford on 10/12/20.
//

import CoreData
@testable import Pokedex_MVVM_C
import XCTest

class CoreDataTests: XCTestCase {
	
	var favoriteService: FavoriteService!
	var coreDataStack: TestCoreDataStack!
	
    override func setUp() {
		super.setUp()
		coreDataStack = TestCoreDataStack()
		favoriteService = FavoriteService(
			managedObjectContext: coreDataStack.mainContext,
			coreDataStack: coreDataStack
		)
    }
	
	func testAddFavorite() {
		let favorite = favoriteService.add(
			"Pikachu",
			imageURL: URL(string: "https://image.example.com")!)
		XCTAssertNotNil(favorite, "Favorite should not be nil")
		XCTAssertEqual(favorite.name, "Pikachu")
		XCTAssertEqual(favorite.imageURL, URL(string: "https://image.example.com"))
		XCTAssertNotNil(favorite.name, "Name should never be nil")
		XCTAssertNotNil(favorite.imageURL, "ImageURL should never be nil")
	}
	
	func testRootContextIsSavedAfterAddingFavorite() {
		let derivedContext = coreDataStack.newDerivedContext()
		favoriteService = FavoriteService(managedObjectContext: derivedContext, coreDataStack: coreDataStack)
		XCTAssertNotEqual(favoriteService.managedObjectContext, coreDataStack.mainContext)
		expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.mainContext) { _ in
			return true
		}
		
		derivedContext.perform {
			let favorite = self.favoriteService.add(
				"Mew-Two",
				imageURL: URL(string: "https://image.example.com")!
			)
			XCTAssertNotNil(favorite)
		}
		
		waitForExpectations(timeout: 2.0) { error in
			XCTAssertNil(error, "Save error did not occur")
		}
	}
	
	func testStoreContainerNotNil() {
		XCTAssertNotNil(coreDataStack.storeContainer)
	}
	
	func testDeleteFavorite() {
		let newFavorite = favoriteService.add(
			"Bulbasuar",
			imageURL: URL(string: "https://images.example.com")!
		)
		var fetchFavorites = favoriteService.getFavorites()
		XCTAssertTrue(fetchFavorites?.count == 1)
		XCTAssertEqual(newFavorite.name, fetchFavorites?.first?.name)
		favoriteService.delete(newFavorite)
		fetchFavorites = favoriteService.getFavorites()
		XCTAssertTrue(fetchFavorites?.isEmpty ?? false)
	}

    override func tearDown() {
        favoriteService = nil
		coreDataStack = nil
		super.tearDown()
    }
}

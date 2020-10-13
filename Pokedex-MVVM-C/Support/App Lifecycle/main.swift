//
//  main.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/12/20.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self
UIApplicationMain(
	CommandLine.argc,
	CommandLine.unsafeArgv,
	nil,
	NSStringFromClass(appDelegateClass)
)

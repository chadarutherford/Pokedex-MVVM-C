//
//  XCTAssert+Ext.swift
//  Pokedex-MVVM-CTests
//
//  Created by Chad Rutherford on 10/9/20.
//

import XCTest

public func XCTAssertEqualToAny<T: Equatable>(_ actual: @autoclosure () throws -> T,
											  _ expected: @autoclosure () throws -> Any?,
											  file: StaticString = #file,
											  line: UInt = #line) throws {
  let actual = try actual()
  let expected = try XCTUnwrap(expected() as? T)
  XCTAssertEqual(actual, expected, file: file, line: line)
}

public func XCTAssertEqualToNSArray(_ actual: @autoclosure () throws -> NSArray,
											  _ expected: @autoclosure () throws -> NSArray,
											  file: StaticString = #file,
											  line: UInt = #line) throws {
  let actual = try actual()
  let expected = try XCTUnwrap(expected() as NSArray)
  XCTAssertEqual(actual, expected, file: file, line: line)
}

public func XCTAssertEqualToURL(_ actual: @autoclosure () throws -> URL,
								_ expected: @autoclosure () throws -> Any?,
								file: StaticString = #file,
								line: UInt = #line) throws {

  let actual = try actual()
  let value = try XCTUnwrap(expected() as? String)
  let expected = try XCTUnwrap(URL(string: value))
  XCTAssertEqual(actual, expected, file: file, line: line)
}

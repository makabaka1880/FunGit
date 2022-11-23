//
//  GitLogInterpreterTests.swift
//  GitLogInterpreterTests
//
//  Created by SeanLi on 2022/11/14.
//

import XCTest
import RegexBuilder
@testable import GitLogInterpreter

final class GitLogInterpreterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    func testInterpreter() throws {
        let sample = """
        commit e0755129e8b6325c0e500ff7115867ff1cb03811
        Author: makabaka1880 <makabaka1880@outlook.com>
        Date:   Mon Nov 14 23:56:12 2022 +0800

            Updated App

        commit 672684aef49b8eca7ce84bf8e2b4e0c740002657
        Author: makabaka1880 <makabaka1880@outlook.com>
        Date:   Mon Nov 14 23:52:25 2022 +0800
        
            Test
        """
        print("---")
        let entries = matchWithEntries(for: sample)
        for entry in entries {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let raw = try encoder.encode(entry)
            print(raw)
        }
        print("----")
    }
    func testDate() throws {
        let sample = "Mon Nov 17 23:52:25 2022 +0800"
        let regex = Regex {
            Capture {
                ChoiceOf {
                    "Mon"
                    "Tue"
                    "Wed"
                    "Thu"
                    "Fri"
                    "Sat"
                    "Sun"
                }
            }
            " "
            Capture {
                ChoiceOf {
                    "Jan"
                    "Feb"
                    "Mar"
                    "Apr"
                    "Mar"
                    "May"
                    "Jun"
                    "Jul"
                    "Aug"
                    "Sep"
                    "Oct"
                    "Nov"
                    "Dec"
                }
            }
            /(\d\d)/
            " "
            /(\d\d):(\d\d):(\d\d)/
            " "
            /\d+/
            " "
            Capture {
                ChoiceOf {
                    "+"
                    "-"
                }
            }
            /{\d\d\d\d}/
        }
        let test = sample.firstMatch(of: regex)
        
        print(test)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

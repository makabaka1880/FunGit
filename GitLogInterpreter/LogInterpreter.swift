//
//  LogInterpreter.swift
//  GitLogInterpreter
//
//  Created by SeanLi on 2022/11/14.
//

import Foundation
import RegexBuilder

let regex = Regex {
    /commit (\*){40}/
    /Author:\s+(\*+)/
    /Date:\s+/
    Capture {
        One(.iso8601(timeZone: .current, dateTimeSeparator: .space))
    }
    /\n/
    /\t(\*+)/
}



let sample = """
commit e0755129e8b6325c0e500ff7115867ff1cb03811
Author: makabaka1880 <makabaka1880@outlook.com>
Date:   Mon Nov 14 23:56:12 2022 +0800

    Updated App
"""

func matchWithEntries(for entries: String) -> [LogEntry] {
    var logEntries: [LogEntry] = []
    let samples = entries.matches(of: regex)
    for i in samples {
        let (whole, id, author, date, message) = i.output
        let entry = LogEntry(id: String(id), author: String(author), date: date, message: String(message), whole: String(whole))
        logEntries.append(entry)
    }
    return logEntries
}

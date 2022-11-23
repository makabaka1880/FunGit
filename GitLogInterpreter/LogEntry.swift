//
//  LogEntry.swift
//  GitLogInterpreter
//
//  Created by SeanLi on 2022/11/21.
//

import Foundation

struct LogEntry: Codable, Hashable, Identifiable {
    var id: String
    var author: String
    var date: Date
    var message: String
    
    var whole: String
}

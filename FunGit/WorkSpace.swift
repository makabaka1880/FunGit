//
//  WorkSpace.swift
//  FunGit
//
//  Created by SeanLi on 2022/11/13.
//

import Foundation

struct WorkSpace: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var path: String
    
    var displayPath: String {
        if path.last != "/" {
            return path + "/"
        } else {
            return path
        }
    }
    var displayName: String {
        let getGit = run("cd \(path); find .git").0
        let name = run("cd \(path); basename $(git remote get-url origin)").0
        if getGit == "" {
            return name
        } else {
            return String(path.split(separator: "/").last!)
        }
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}


//
//  File.swift
//  FunGit
//
//  Created by SeanLi on 2022/11/13.
//

import Foundation

class GitDelegate {
    init(dir: String) {
        self.dir = dir
    }
    var dir: String
    var displayPath: String {
        if dir.last != "/" {
            return dir
        } else {
            var _d = dir
            _d.removeLast()
            return _d
        }
    }
    func initialize(_ remote: String) -> (String, String) {
        return run("cd \(dir); git init; git remote add origin \(remote);")
    }
    func pull() -> (String, String) {
        return run("cd \(dir); git pull;")
    }
    func push() -> (String, String) {
        return run("cd \(dir); git push;")
    }
    func commit(_ message: String) -> (String, String) {
        return run("cd \(dir); git commit -m \"\(message)\";")
    }
    func add(_ url: String) -> (String, String) {
        return run("cd \(dir); git add \(url);")
    }
    func remove(_ url: String) -> (String, String) {
        return run("cd \(dir); git rm \(url);")
    }
    func log() -> (String, String) {
        return run("cd \(displayPath)/.git; git log;")
    }
    
}



func run(_ command: String) -> (String, String) {
    let pro = Process()
    pro.launchPath = "/bin/zsh"
    pro.arguments = ["-c", command]
    let pipe = Pipe()
    let err = Pipe()
    pro.standardOutput = pipe
    pro.standardError = err
    try! pro.run()
    return (
        String(
            data: (
                try? pipe.fileHandleForReading.readToEnd() ?? "".data(using: .utf8)
            )!,
            encoding: .utf8
        )!,
        String(
            data: (
                try? err.fileHandleForReading.readToEnd() ?? "".data(using: .utf8)
            )!,
            encoding: .utf8
        )!
    )
}

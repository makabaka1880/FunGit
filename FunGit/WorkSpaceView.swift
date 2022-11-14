//
//  WorkSpaceView.swift
//  FunGit
//
//  Created by SeanLi on 2022/11/13.
//

import SwiftUI

struct WorkSpaceView: View {
    @Binding var workspace: WorkSpace
    @State var pull: Bool = false
    @State var push: Bool = false
    @State var commit: Bool = false
    @State var add: Bool = false
    @State var remove: Bool = false
    @State var initialize: Bool = false
    @State private var showCopyButton: Bool = false
    @State var gitLog: (String, String) = ("Loading...", "")
    @State private var logFileCache: (String, String) = ("Loading", "")
    @State private var messageCache: String = ""
    var delegate = GitDelegate(dir: "")
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                Text(workspace.displayName)
                    .font(.title.bold())
                    .padding(.leading, 30.0)
                    .offset(y: 20)
                Spacer()
            }
            Form {
                Section("Repo Settings") {
                    TextField("Path", text: $workspace.path)
                        .textFieldStyle(.plain)
                    Button("Pick...") {
                        let picker = NSOpenPanel()
                        picker.canChooseFiles = false
                        picker.canChooseDirectories = true
                        picker.allowsMultipleSelection = false
                        if picker.runModal() == .OK {
                            let url = picker.url!
                            workspace.path = url.relativePath
                        }
                    }
                }
                Section("Basic Actions") {
                    HStack {
                        Button("Pull") {
                            logFileCache = ("Fetching...", "")
                            Task {
                                logFileCache = delegate.pull()
                            }
                            pull.toggle()
                        }
                        Spacer()
                        Text("git pull;")
                            .font(.body.monospaced())
                    }
                    .sheet(isPresented: $pull) {
                        LogFileView(logFileCache: logFileCache)
                    }
                    HStack {
                        Button("Push") {
                            logFileCache = ("Pushing...", "")
                            Task {
                                logFileCache = delegate.push()
                            }
                            pull.toggle()
                        }
                        Spacer()
                        Text("git push;")
                            .font(.body.monospaced())
                    }
                    .sheet(isPresented: $pull) {
                        LogFileView(logFileCache: logFileCache)
                    }
                    HStack {
                        Button("Commit") {
                            logFileCache = ("", "")
                            messageCache = "Commit Message Here"
                            commit.toggle()
                        }
                        Spacer()
                        Text("git commit -m \"Commit Message\";")
                            .font(.body.monospaced())
                    }
                    .sheet(isPresented: $commit) {
                        VStack {
                            Form {
                                Section("Details") {
                                    TextField("Commit Message", text: $messageCache)
                                    Button("Commit") {
                                        Task {
                                            logFileCache = delegate.commit(messageCache)
                                        }
                                    }
                                }
                                Section("Log") {
                                    VStack(alignment: .leading) {
                                        Text(logFileCache.0)
                                            .font(.body.monospaced())
                                        Text(logFileCache.1)
                                            .font(.body.monospaced())
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .formStyle(.grouped)
                            HStack {
                                Spacer()
                                Button("OK") {
                                    commit.toggle()
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                }
                Section("Repo Actions") {
                    HStack {
                        Button("Add") {
                            let panel = NSOpenPanel()
                            panel.allowsMultipleSelection = false
                            if panel.runModal() == .OK {
                                let url = panel.url!
                                messageCache = url.relativePath
                            }
                            Task {
                                logFileCache = delegate.add(messageCache)
                            }
                            add.toggle()
                        }
                        Spacer()
                        Text("git add <filepath>;")
                            .font(.body.monospaced())
                    }
                    HStack {
                        Button("Remove") {
                            let panel = NSOpenPanel()
                            panel.allowsMultipleSelection = false
                            if panel.runModal() == .OK {
                                let url = panel.url!
                                messageCache = url.relativePath
                            }
                            Task {
                                logFileCache = delegate.remove(messageCache)
                            }
                            remove.toggle()
                        }
                        Spacer()
                        Text("git rm <filepath>;")
                            .font(.body.monospaced())
                    }
                    .sheet(isPresented: $remove) {
                        LogFileView(logFileCache: logFileCache)
                    }
                    HStack {
                        Button("Init/Reinit") {
                            logFileCache = ("", "")
                            messageCache = "git@github.com:userName/RepoNameHere"
                            initialize.toggle()
                        }
                        Spacer()
                        Text("git init; git remote add origin <origin>;")
                            .font(.body.monospaced())
                    }
                    .sheet(isPresented: $initialize) {
                        VStack {
                            Form {
                                Section("Details") {
                                    TextField("Repo Origin(ssh)", text: $messageCache)
                                    Button("Init/Reinit") {
                                        Task {
                                            logFileCache = delegate.initialize(messageCache)
                                        }
                                    }
                                }
                                Section("Log") {
                                    VStack(alignment: .leading) {
                                        Text(logFileCache.0)
                                            .font(.body.monospaced())
                                        Text(logFileCache.1)
                                            .font(.body.monospaced())
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .formStyle(.grouped)
                            HStack {
                                Spacer()
                                Button("OK") {
                                    initialize.toggle()
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                }
                Section("Log") {
                    Button("Copy") {
                        let _ = NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(gitLog.0 + "\n" + gitLog.1, forType: .string)
                    }
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .leading) {
                            Text(gitLog.0)
                                .font(.body.monospaced())
                            Text(gitLog.1)
                                .font(.body.monospaced())
                                .foregroundColor(.red)
                        }
                        .onAppear {
                            Task {
                                gitLog = delegate.log()
                            }
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("FunGit")
            .onAppear {
                refreshDir()
            }
            .onChange(of: workspace.path) { val in
                refreshDir()
            }
        }
    }
    func refreshDir() {
        delegate.dir = workspace.path
        print(delegate.dir, workspace.path)
    }
}

struct WorkSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceView(workspace: .constant(.init(path: "~/Desktop/Archived/PhysicsNinja/PhysicsNinja")))
    }
}

//
//  ContentView.swift
//  FunGit
//
//  Created by SeanLi on 2022/11/13.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("workspaces") var workspaces: [WorkSpace] = []
    @State var path: String = "~/"
    var body: some View {
        NavigationView {
            List {
                ForEach($workspaces) { $item in
                    NavigationLink {
                        WorkSpaceView(workspace: $item)
                    } label: {
                        Text(item.path.split(separator: "/").last!)
                    }
                }
            }
            .toolbar {
                Button {
                    let picker = NSOpenPanel()
                    picker.canChooseFiles = false
                    picker.canChooseDirectories = true
                    picker.allowsMultipleSelection = false
                    if picker.runModal() == .OK {
                        let url = picker.url!
                        workspaces.append(.init(path: url.relativePath))
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

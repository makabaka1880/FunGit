//
//  LogFileView.swift
//  FunGit
//
//  Created by SeanLi on 2022/11/14.
//

import SwiftUI

struct LogFileView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    var logFileCache: (String, String)
    var body: some View {
        VStack {
            Form {
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
                    dismiss()
                }
                .padding()
            }
        }
    }
}

struct LogFileView_Previews: PreviewProvider {
    static var previews: some View {
        LogFileView(logFileCache: ("TestTestTest", "TestTestTest"))
    }
}

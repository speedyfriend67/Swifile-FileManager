//
//  SwifileApp.swift
//  Swifile
//
//  Created by Nguyen Bao on 04/02/2024.
//

import SwiftUI

@main
struct Main {
    static func main() {
        let Args = CommandLine.arguments
        let Argc = CommandLine.argc
        if Argc >= 2 {
            // Your app is being used as RootHelper
            // Here are some commands it can do
            switch Args[1] {
            case "kill":
                if Argc >= 3 {
                    kill(Int32(Args[2])!, SIGTERM)
                    print("Killed PID \(Args[2])")
                } else {
                    print("Missing PID To Kill!")
                    return
                }
            }
        } else {
            // Not being used as RootHelper
            SwifileApp.main()
        }
    }
}

struct SwifileApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(folderURL: URL(fileURLWithPath: "/var/"), folderName: "Root")
                    .navigationViewStyle(StackNavigationViewStyle()) // Prevent automatic navigation
            }
        }
    }
}

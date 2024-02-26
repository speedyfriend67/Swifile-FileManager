//
//  SwifileApp.swift
//  Swifile
//
//  Created by Nguyen Bao on 04/02/2024.
//

import SwiftUI

@main
struct SwifileApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .navigationViewStyle(StackNavigationViewStyle()) // Prevent automatic navigation
            }
        }
    }
}

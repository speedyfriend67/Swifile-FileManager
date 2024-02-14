//
// ItemActions.swift
// Swifile
//
// Created by Nguyen Bao on 07/02/2024.
//
//

import SwiftUI

struct AboutPage: View {
	// for developers/translators:
	// as this project only accepts devs with a GitHub account,
	// so sections below will use their GitHub as well
	// complete this list by adding your GitHub user name
	// for translators: your user name + flag of the country you translate this app to
    let Credits: [String] = ["lebao3105", "speedyfriend67", "AppInstalleriOSGH"].sorted()
    let Translators: [String] = [].sorted()
	let shortBuild: String
	let version: String
	
	init() {
		let test1 = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
		let test2 = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
		shortBuild = test1 ?? "Unknown"
		version = test2 ?? "Unknown"
	}
	
    var body: some View {
        List {
            Section(header: Text("This app")) {
				Text("Version: \(version)")
				Text("Release version number: \(shortBuild)")
            }

            Section(header: Text("Developers")) {
                ForEach(Credits, id:\.self) { Name in
					Link(Name, destination: URL(string: "https://github.com/\(Name)")!)
                }
            }

            Section(header: Text("Translators")) {
                ForEach(Translators, id:\.self) { Name in
					Link(Name, destination: URL(string: "https://github.com/\(Name)")!)
                }
            }
        }
        .navigationBarTitle("About")
    }
}

struct SettingsView: View {
	@AppStorage("skipHiddenFiles") var skipHiddenFiles: Bool = true
	@AppStorage("defaultPath") var defaultPath: String = "/var"
	@AppStorage("sortBy") var sortBy: SortOption = .name
	
	@Binding var isPresented: Bool
	
	var body: some View {
		NavigationView {
			VStack {
				List {
					Toggle("Skip hidden files", isOn: $skipHiddenFiles)
					
					HStack {
						Text("Default path")
						TextField("", text: $defaultPath)
					}
					
					HStack {
						Text("Sort by")
						
						Picker("...", selection: $sortBy, content: {
							ForEach(SortOption.allCases, id: \.self) { option in
								Text(option.rawValue).tag(option)
							}
						})
						.pickerStyle(MenuPickerStyle())
					}
					
					Section("This application") {
						NavigationLink {
							AboutPage()
						} label: {
							Label("About this app", systemImage: "person.2.circle")
						}
					}
				}
			}
			.navigationBarTitle("Settings")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Done") {
						isPresented = false
					}
				}
			}
		}
	}
}

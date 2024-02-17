//
// ItemActions.swift
// Swifile
//
// Created by Nguyen Bao on 07/02/2024.
//
//

import SwiftUI
import Foundation

struct AboutPage: View {
	// for developers/translators:
	// as this project only accepts devs with a GitHub account,
	// so sections below will use their GitHub as well
	// complete this list by adding your GitHub user name
	// for translators: your user name + flag of the country you translate this app to
    let Credits: [String] = ["lebao3105", "speedyfriend67", "AppInstalleriOSGH"].sorted()
    let Translators: [String] = [].sorted()
	let shortBuild: String
	
	init() {
		let test1 = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
		shortBuild = test1 ?? "Unknown"
	}
	
    var body: some View {
        List {
            makeTitleWithSecondary("App version", shortBuild)

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

enum FileSizeOptions: Int, CaseIterable {
	case MegaByte = 0
	case GigaByte = 1
	case KiloByte = 2
}

struct SettingsView: View {
	@AppStorage("skipHiddenFiles") var skipHiddenFiles: Bool = true
	@AppStorage("defaultPath") var defaultPath: String = "/var"
	@AppStorage("sortBy") var sortBy: SortOption = .name
	@AppStorage("useSize") var size: FileSizeOptions = .MegaByte
	@AppStorage("allowNonNumbericSize") var nonNumbericSize: Bool = true
	
	@Binding var isPresented: Bool
	
	var body: some View {
		NavigationView {
			VStack {
				List {
					Toggle("Skip hidden files", isOn: $skipHiddenFiles)
					
					HStack {
						Text("Default path")
						Spacer()
						TextField("", text: $defaultPath)
					}
											
					Picker("Sort by", selection: $sortBy, content: {
						ForEach(SortOption.allCases, id: \.self) { option in
							Text(option.rawValue).tag(option)
						}
					})
					
					Picker("File size", selection: $size, content: {
						ForEach(FileSizeOptions.allCases, id:\.self) { option in
							Text(String(describing: option)).tag(option)
						}
					})
					
					Toggle("Allow non-numberic file size", isOn: $nonNumbericSize)
					
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
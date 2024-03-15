//
// ItemActions.swift
// Swifile
//
// Created by Nguyen Bao on 07/02/2024.
//
//

import UIKit
import SwiftUI
import Foundation

class LogViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let textview = UITextView()
		textview.isEditable = false
		textview.isSelectable = true
		textview.textAlignment = NSTextAlignment.left
		textview.translatesAutoresizingMaskIntoConstraints = true
		view.addSubview(textview)
	}
}

// read-only, show only once and no new update for the log inside
struct LogView: UIViewControllerRepresentable {
	typealias UIViewControllerType = LogViewController
	let text: String

    func makeUIViewController(context: Context) -> LogViewController {
        LogViewController()
    }

    func updateUIViewController(_ uiViewController: LogViewController, context: Context) {
       // Update the ViewController here
    }
}

struct AboutPage: View {
	// for developers/translators:
	// as this project only accepts devs with a GitHub account,
	// so sections below will use their GitHub as well
	// complete this list by adding your GitHub user name
	// for translators: your user name + flag of the country you translate this app to
    let Credits: [String] = ["lebao3105", "speedyfriend67", "AppInstalleriOSGH"].sorted()
    let Translators: [String] = [].sorted()

	let shortBuild: String
	let gid: String
	let uid: String
	
	init() {
		let test1 = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
		shortBuild = test1 ?? "Unknown"

		var test_gid = runHelper(["gid"])
		var test_guid = runHelper(["guid"])

		if test_gid.status == 0 {
			test_gid.output.removeLast()
			gid = test_gid.output
		} else {
			gid = "GID: ??"
		}

		if test_guid.status == 0 {
			test_guid.output.removeLast()
			uid = test_guid.output
		} else {
			uid = "UID: ??"
		}
	}
	
    var body: some View {
        List {
            makeTitleWithSecondary("App version", shortBuild)
			
			Section(footer: Text("RootHelper processes file and folder operations. GID and UID should be 0.")) {
				makeTitleWithSecondary("RootHelper process", gid + ", " + uid)
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

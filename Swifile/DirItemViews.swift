//
// ItemActions.swift
// Swifile
//
// Created by Nguyen Bao on 07/02/2024.
//
//

import SwiftUI
import SimpleToast

struct DirListItemActions: View {
	@Environment(\.presentationMode) var presentationMode

	@State private var amIAbleToToast: Bool = false
	@State private var toastMessage: String = "No message provided (should not happend)"
	@State private var goToProperties: Bool = false
	
	@State private var item: ContentItem
	@Binding var isPresented: Bool
	@Binding var contents: [ContentItem]
	
	@AppStorage("queueMove") var moveList: [String] = []
	@AppStorage("queueCopy") var copyList: [String] = []
	@AppStorage("queueCut") var cutList: [String] = []
	
	init(item: ContentItem, isPresented: Binding<Bool>, contents: Binding<[ContentItem]>) {
		self._item = State(initialValue: item)
		self._isPresented = isPresented
		self._contents = contents
	}

	private let toastOptions = SimpleToastOptions(hideAfter: 5, modifierType: .skew)

	var body: some View {
		NavigationView {
			VStack {
				List {
					Button {
						withAnimation {
							if copyList.contains(item.url.path) {
								copyList.removeAll { $0 == item.url.path }
								toastMessage = "Removed from Queue"
							} else {
								toastMessage = "Added to Queue"
								copyList.append(item.url.path)
								moveList.removeAll { $0 == item.url.path }
								cutList.removeAll { $0 == item.url.path }
							}
							amIAbleToToast.toggle()
						}
					} label: {
						Label("Copy", systemImage: "doc.on.clipboard")
					}
					
					Button {
						withAnimation {
							if cutList.contains(item.url.path) {
								cutList.removeAll { $0 == item.url.path }
								toastMessage = "Removed from Queue"
							} else {
								copyList.removeAll { $0 == item.url.path }
								moveList.removeAll { $0 == item.url.path }
								cutList.append(item.url.path)
								toastMessage = "Added to Queue"
							}
							contents.removeAll { $0.id == item.id }
							amIAbleToToast.toggle()
						}
					} label: {
						Label("Cut", systemImage: "arrow.right.doc.on.clipboard")
					}
					
					Button {
						
					} label: {
						Label("Share", systemImage: "square.and.arrow.up")
					}
					
					Button {
						withAnimation {
							if moveList.contains(item.url.path) {
								moveList.removeAll { $0 == item.url.path }
								toastMessage = "Removed from Queue"
							} else {
								moveList.append(item.url.path)
								copyList.removeAll { $0 == item.url.path }
								cutList.removeAll { $0 == item.url.path }
								toastMessage = "Added to Queue"
							}
							amIAbleToToast.toggle()
						}
					} label: {
						Label("Move to...", systemImage: "folder")
					}
					
					Button {
						goToProperties = true // make a sheet, or navigate?
					} label: {
						Label("View properties", systemImage: "doc.badge.gearshape")
					}
				}
			}
			.navigationBarTitle("Actions")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Done") {
						isPresented = false
						presentationMode.wrappedValue.dismiss()
					}
				}
			}
		}
		.ignoresSafeArea(.all)
		.simpleToast(isPresented: $amIAbleToToast, options: toastOptions) {
			Label(toastMessage, systemImage: "info.circle")
				.padding()
				.background(Color.blue.opacity(0.8))
				.foregroundColor(Color.white)
				.cornerRadius(50)
				.padding(.top)
		}
		.sheet(isPresented: $goToProperties) {
			DirItemProperties(item: $item, isPresented: $goToProperties)
		}
	}
}

struct DirItemProperties: View {
	@Environment(\.presentationMode) var presentationMode
	
	@State private var amIAbleToToast: Bool = false
	@State private var toastMessage: String = ""
	
	@Binding var item: ContentItem
	@Binding var isPresented: Bool
	
	private let toastOptions = SimpleToastOptions(hideAfter: 5, modifierType: .skew)
	
	var body: some View {
		NavigationView {
			VStack {
				List {
					makeTitleWithSecondary("Full path", item.url.path)
					makeTitleWithSecondary("Is a folder?", String(item.isFolder))
					makeTitleWithSecondary("Is a symbolic link?", String(item.isSymbolicLink))
					makeTitleWithSecondary("Last modified", item.modificationDate.formatted())
					makeTitleWithSecondary("Size", String(item.fileSizeFormatted))
				}
			}
			.navigationBarTitle("Properties")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Close") {
						isPresented = false
						presentationMode.wrappedValue.dismiss()
					}
				}
			}
		}
		.simpleToast(isPresented: $amIAbleToToast, options: toastOptions) {
			Label(toastMessage, systemImage: "info.circle")
				.padding()
				.background(Color.blue.opacity(0.8))
				.foregroundColor(Color.white)
				.cornerRadius(50)
				.padding(.top)
		}
	}
}

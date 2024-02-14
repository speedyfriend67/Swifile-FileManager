//
// ItemActions.swift
// Swifile
//
// Created by Nguyen Bao on 07/02/2024.
//
//

import SwiftUI
import SimpleToast

enum QueueActions: Encodable, Decodable {
	case move
	case copy
	case cut
}

struct DirListItemActions: View {
	@Environment(\.presentationMode) var presentationMode

	@State private var amIAbleToToast: Bool = false
	@State private var toastMessage: String = "No message provided (should not happend)"

	@Binding var isPresented: Bool
	@Binding var contents: [ContentItem]
	
	@AppStorage("queueMove") var moveList: [String] = []
	@AppStorage("queueCopy") var copyList: [String] = []
	@AppStorage("queueCut") var cutList: [String] = []

	private let toastOptions = SimpleToastOptions(hideAfter: 5)
	private let urlPath: URL

	init(itemURL: URL, isPresented: Binding<Bool>, contents: Binding<[ContentItem]>) {
		self.urlPath = itemURL
		self._isPresented = isPresented
		self._contents = contents
	}

	var body: some View {
		NavigationView {
			VStack {
				List {
					Button {
						withAnimation {
							if copyList.contains(urlPath.path) {
								copyList.removeAll { $0 == urlPath.path }
								toastMessage = "Removed from Queue"
							} else {
								toastMessage = "Added to Queue"
								copyList.append(urlPath.path)
								moveList.removeAll { $0 == urlPath.path }
								cutList.removeAll { $0 == urlPath.path }
							}
							amIAbleToToast.toggle()
						}
					} label: {
						Label("Copy", systemImage: "doc.on.clipboard")
					}
					
					Button {
						withAnimation {
							if cutList.contains(urlPath.path) {
								cutList.removeAll { $0 == urlPath.path }
								toastMessage = "Removed from Queue"
							} else {
								copyList.removeAll { $0 == urlPath.path }
								moveList.removeAll { $0 == urlPath.path }
								cutList.append(urlPath.path)
								toastMessage = "Added to Queue"
							}
							contents.removeAll { $0.url == urlPath }
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
							if moveList.contains(urlPath.path) {
								moveList.removeAll { $0 == urlPath.path }
								toastMessage = "Removed from Queue"
							} else {
								moveList.append(urlPath.path)
								copyList.removeAll { $0 == urlPath.path }
								cutList.removeAll { $0 == urlPath.path }
								toastMessage = "Added to Queue"
							}							
							amIAbleToToast.toggle()
						}
					} label: {
						Label("Move to...", systemImage: "folder")
					}
					
					Button {
						
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

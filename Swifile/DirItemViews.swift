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

	@Binding var isPresented: Bool
	@Binding var contents: [ContentItem]

	private let toastOptions = SimpleToastOptions(hideAfter: 5)
	private let urlPath: URL

	init(itemURL: URL, isPresented: Binding<Bool>, contents: Binding<[ContentItem]>) {
		self.urlPath = itemURL
		self._isPresented = isPresented
		self._contents = contents
	}

	var body: some View {
		VStack {
			List {
				Button {
					withAnimation {
						toastMessage = "Added to Queue"
						amIAbleToToast.toggle()
					}
				} label: {
					Label("Copy", systemImage: "doc.on.clipboard")
				}
				
				Button {
					withAnimation {
						toastMessage = "Added to Queue"
						amIAbleToToast.toggle()
						contents.removeAll { $0.url == urlPath }
					}
				} label: {
					Label("Cut", systemImage: "arrow.right.doc.on.clipboard")
				}
				
				Button {
					
				} label: {
					Label("Share", systemImage: "square.and.arrow.up")
				}
				
				Button {
					
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

//
//  ContentView.swift
//  Swifile
//
//  Created by Nguyen Bao on 04/02/2024.
//  Views made by SpeedyFriend67.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var contents: [ContentItem] = []
    @State private var sortBy: SortOption = .name
    @State private var searchText: String = ""
    @State private var showFileSize: Bool = true
    
    @State private var gotErrors: Bool = false
    @State private var errorString: String = ""
    
    @State private var settingsCalled: Bool = false
    @State private var newItemCalled: Bool = false
    
    @State private var createType: Int = 0 // 1 = file, 2 = folder
    @State private var callCreateDialog: Bool = false
    @State private var targetCreate: String = ""
    
    @State private var deleteConfirm: Bool = false
    
    let folderURL: URL
    let folderName: String

    init(folderURL: URL) {
        self.folderURL = folderURL
        self.folderName = folderURL.lastPathComponent
    }

    var body: some View {
        VStack {
            List(filteredContents().sorted(by: sortBy.sortingComparator), id: \.id) { contentItem in                // add folder as a view controller item
                if contentItem.isFolder || contentItem.isSymbolicLink {
                    NavigationLink(destination: ContentView(folderURL: contentItem.url)) {
                        makeListEntry(item: contentItem)
                    }
                }
                
                else { // file
                    makeListEntry(item: contentItem)
                }
            }
            // navigation
            .navigationBarTitle(folderURL.path)
            .navigationBarItems(trailing:
                HStack {
                    Picker("Sort by", selection: $sortBy, content: {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    })
                    .pickerStyle(MenuPickerStyle())
                        
                    Button("Add", systemImage: "doc.badge.plus", action: { newItemCalled = true })
                        .labelStyle(.iconOnly)
                
                    Button("Settings", systemImage: "gear", action: {settingsCalled = true})
                        .labelStyle(.iconOnly)
                    }
            )
            // search bar
            .searchable(text: $searchText, prompt: Text("Find for an item"))
            // load contents on show
            .onAppear {
                loadContents()
            }
            // create file/folder sheets
            .actionSheet(isPresented: $newItemCalled) {
                ActionSheet(
                    title: Text("What kind of item do you want to create?"),
                    buttons: [
                        .default(Text("File"), action: { createType = 1; callCreateDialog = true }),
                        .default(Text("Folder"), action: { createType = 2; callCreateDialog = true }),
                        .cancel()
                    ]
                )
            }
            // error alert
            .alert(isPresented: $gotErrors, content: {
                Alert(
                    title: Text("An error occured!"),
                    message: Text(errorString),
                    dismissButton: .default(Text("Ok then")) {
                        gotErrors = false
                        errorString = ""
                    }
                )
            })
            // settings view
            .sheet(isPresented: $settingsCalled, content: {
                SettingsView(showFileSize: $showFileSize)
            })
            
        }
    }
    
    private func makeListEntry(item: ContentItem) -> some View {
        let url = item.url
        var icon: String = "doc"
        if item.isFolder {
            icon = "folder"
        }
        return Label(url.lastPathComponent, systemImage: icon)
            .padding(.vertical, 6)
            .swipeActions(allowsFullSwipe: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) {
                
                Button {
                    print("'Star' button clicked")
                } label: {
                    Label("Star", systemImage: "star")
                }
                
                Button {
                    print("'More' button clicked")
                } label: {
                    Label("More", systemImage: "option")
                }
                .tint(.indigo)
                
                Button(role: .destructive) {
                    deleteConfirm = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .alert(isPresented: $deleteConfirm, content: {
                    Alert(
                        title: Text("Delete confirmation"),
                        message: Text("Are you sure want to delete this? No revert!"),
                        primaryButton: .destructive(Text("Yes"), action: {
                            deleteConfirm = false
                            deleteItem(at: url)
                        }),
                        secondaryButton: .default(Text("No"), action: {
                            deleteConfirm = false
                        })
                    )
                })
                
            }

    }
    
    private func loadContents() {
        let fileManager = FileManager.default
        do {
            let urls = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey], options: [.skipsHiddenFiles])
            contents = urls.map { 
                url in let isDir = (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
                       let isSymLink = (try? url.resourceValues(forKeys: [.isSymbolicLinkKey]))?.isSymbolicLink ?? false
                       let fileSize = Int64((try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0)
                       let modificationDate = (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date()

                return ContentItem(url: url, isFolder: isDir, isSymbolicLink: isSymLink,
                            fileSize: fileSize, modificationDate: modificationDate)
            }
        } catch {
            errorString = error.localizedDescription
            gotErrors = true
        }
    }

    private func deleteItem(at url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            contents.removeAll { $0.url == url }
        } catch {
            errorString = error.localizedDescription
            gotErrors = true
        }
    }

    private func filteredContents() -> [ContentItem] {
        if searchText.isEmpty {
            return contents
        } else {
            return contents.filter { $0.url.lastPathComponent.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct SettingsView: View {
    @Binding var showFileSize: Bool

    var body: some View {
        VStack {
            List {
                Toggle("Show File Size", isOn: $showFileSize)
                    .padding()
            }
            Text("Made by speedyfriend67 and lebao3105")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ContentItem: Identifiable {
    let id = UUID()
    var url: URL
    let isFolder: Bool
    let isSymbolicLink: Bool
    let fileSize: Int64
    let modificationDate: Date
    
    var fileSizeFormatted: String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useMB, .useGB, .useKB]
        byteCountFormatter.countStyle = .file

        // If the file size is less than 1000 bytes, display it in bytes
        if fileSize < 1000 {
            byteCountFormatter.allowedUnits = [.useBytes]
            byteCountFormatter.countStyle = .file
        }

        return byteCountFormatter.string(fromByteCount: fileSize)
    }
}

enum SortOption: String, CaseIterable, Identifiable {
    case name = "Name"
    case size = "Size"
    case modificationDate = "Modification Date"

    var id: String { self.rawValue }

    func sortingComparator(_ item1: ContentItem, _ item2: ContentItem) -> Bool {
        switch self {
        case .name:
            return item1.url.lastPathComponent.localizedCaseInsensitiveCompare(item2.url.lastPathComponent) == .orderedAscending
        case .size:
            return item1.fileSize < item2.fileSize
        case .modificationDate:
            return item1.modificationDate < item2.modificationDate
        }
    }
}

// lebao3105: lol it never works properly here
// (used OCLP to get newer macOSes)
//#Preview {
//    ContentView(document: .constant(SwifileDocument()))
//}

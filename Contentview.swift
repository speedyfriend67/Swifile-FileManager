import SwiftUI

@main
struct FileManagerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(folderURL: URL(fileURLWithPath: "/var/"), folderName: "Root")
                    .navigationViewStyle(StackNavigationViewStyle()) // Prevent automatic navigation
            }
        }
    }
}

struct ContentView: View {
    @State private var contents: [ContentItem] = []
    @State private var sortBy: SortOption = .name
    @State private var searchText: String = ""
    @State private var showFileSize = true
    let folderURL: URL
    let folderName: String

    init(folderURL: URL, folderName: String) {
        self.folderURL = folderURL
        self.folderName = folderName
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List(filteredContents().sorted(by: sortBy.sortingComparator), id: \.id) { contentItem in
                if contentItem.isFolder {
                    NavigationLink(destination: ContentView(folderURL: contentItem.url, folderName: contentItem.url.lastPathComponent)) {
                        Label(contentItem.url.lastPathComponent, systemImage: "folder")
                            .padding(.vertical, 6)
                    }
                } else {
                    HStack {
                        Label(contentItem.url.lastPathComponent, systemImage: "doc")
                            .padding(.vertical, 6)
                        Spacer()
                        if showFileSize {
                            Text(contentItem.fileSizeFormatted)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        DeleteButton(contentItem: contentItem, onDelete: deleteFile)
                    }
                }
            }
            .navigationBarTitle(folderName)
            .navigationBarItems(trailing:
                HStack {
                    Picker("", selection: $sortBy) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    NavigationLink(destination: SettingsView(showFileSize: $showFileSize)) {
                        Image(systemName: "gear")
                    }
                }
            )
            .onAppear {
                loadContents()
            }
        }
    }

    private func loadContents() {
        let fileManager = FileManager.default
        do {
            let urls = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey], options: [.skipsHiddenFiles])
            contents = urls.map { url in
                let isDir = (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
                let fileSize = Int64((try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0)
                let modificationDate = (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date()

                return ContentItem(url: url, isFolder: isDir, fileSize: fileSize, modificationDate: modificationDate)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func deleteFile(at url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            contents.removeAll { $0.url == url }
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
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
            Toggle("Show File Size", isOn: $showFileSize)
                .padding()
            Text("Made by speedyfriend67")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ContentItem: Identifiable {
    let id = UUID()
    let url: URL
    let isFolder: Bool
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

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
                    .padding(.trailing, 8)
            }
        }
        .padding(.horizontal)
    }
}

struct DeleteButton: View {
    let contentItem: ContentItem
    let onDelete: (URL) -> Void
    @State private var isShowingDeleteAlert = false

    var body: some View {
        Button(action: {
            isShowingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        }
        .buttonStyle(BorderlessButtonStyle())
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(
                title: Text("Delete File"),
                message: Text("Are you sure you want to delete this file?"),
                primaryButton: .default(Text("Delete")) {
                    onDelete(contentItem.url)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

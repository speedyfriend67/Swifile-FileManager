import Foundation

func contentsOfDirectory(_ path: String) -> [String] {
    let test = runHelper(["l", path])
    return (test.status != 0 || test.output == "") ? [] : test.output.components(separatedBy: "\n")
}
func createFile(atPath path: String, contents: Data?, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
    return FileManager.default.createFile(atPath: path, contents: contents, attributes: attributes)
}

func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool = true, attributes: [FileAttributeKey : Any]? = nil) throws {
    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: createIntermediates, attributes: attributes)
}

func removeItem(atPath path: String) throws {
    try FileManager.default.removeItem(atPath: path)
}

func removeDirectory(atPath path: String) throws {
    try FileManager.default.removeItem(atPath: path)
}
func overwriteFile(atPath path: String, withContents contents: Data) -> Bool {
    if FileManager.default.fileExists(atPath: path) {
        do {
            try contents.write(to: URL(fileURLWithPath: path))
            return true
        } catch {
            print("Error overwriting file: \(error)")
            return false
        }
    } else {
        print("File does not exist at path: \(path)")
        return false
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

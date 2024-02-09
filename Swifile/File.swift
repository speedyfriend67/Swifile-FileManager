import Foundation

func contentsOfDirectory(_ Path: String) -> [String] {
    do {
        // Random path to store contents JSON
        let JSONPath = "\(NSHomeDirectory())/tmp/\(UUID().uuidString)"
        // Write contents of directory JSON to JSONPath
        RootHelper(["ls", Path, JSONPath])
        // Read contents of JSONPath
        let Contents: [String] = Array(rawValue: try String(contentsOfFile: JSONPath)) ?? []
        // Remove JSONPath
        try FileManager.default.removeItem(atPath: JSONPath)
        return Contents
    } catch {
        print(error)
        return []
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

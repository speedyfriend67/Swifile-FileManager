import Foundation

// TODO: Move + more cases
enum SwifileError: Error {
    case RootHelperError(String)
}

func contentsOfDirectory(_ Path: String) throws -> [String] {
    let commandOutput = runCommand(Bundle.main.bundlePath + "/RootHelper", ["l", Path], 501)
    if commandOutput.output == "" || commandOutput.status != 0 {
        throw SwifileError.RootHelperError("RootHelper run returned non-zero code: \(commandOutput.status)")
    }
    return commandOutput.output.components(separatedBy: "\n")
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

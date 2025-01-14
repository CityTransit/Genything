import Foundation

private class Class {}

protocol JsonResourceCodable: Codable {}

extension JsonResourceCodable {
    private static func getBundle() -> Bundle {
        #if SWIFT_PACKAGE
            Bundle.module
        #else
            let url = Bundle(for: Class.self)
                .url(forResource: "Trickery", withExtension: "bundle")!
            return Bundle(url: url)!
        #endif
    }

    static func loadJson() -> Self {
        getBundle()
            .url(forResource: String(describing: self),
                 withExtension: "json")
            .flatMap {
                try? Data(contentsOf: $0)
            }
            .flatMap {
                try? JSONDecoder().decode(Self.self, from: $0)
            }!
    }
}

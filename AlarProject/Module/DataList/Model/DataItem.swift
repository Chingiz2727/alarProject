import Core

struct DataItem: Codable {
    let status: String
    let page: Int
    let data: [Data]
}

// MARK: - Datum
struct Data: Codable {
    let id, name: String
    let country: String
    let lat, lon: Double
}

extension Data: Equatable, DiffAware, Identifiable {
    typealias DiffId = String

    var diffId: String {
        return id
    }
    
    static func compareContent(_ a: Data, _ b: Data) -> Bool {
        return a.id == b.id && a.name == b.name
    }
    
    
    static func == (a: Data, b: Data) -> Bool {
        return a.id == b.id && a.name == b.name
    }
}

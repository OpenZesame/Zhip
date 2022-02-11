//import KeychainSwift
import KeychainAccess
import Foundation

public final class KeychainManager<Key: Identifiable> where Key.ID == String {
//    private let wrapped: KeychainSwift
    private let wrapped: Keychain
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    public init() {
        self.wrapped = Keychain(service: "com.openzesame.zhip")
            .label("Zhip")
            .synchronizable(false)
            .accessibility(.whenPasscodeSetThisDeviceOnly)
    }
}

public extension KeychainManager {
    func saveCodable<C: Codable>(_ model: C, for key: Key) throws {
        let jsonData = try encoder.encode(model)
        try save(data: jsonData, key: key)
    }
    
    func loadCodable<C: Codable>(for key: Key) throws -> C? {
        try loadCodable(C.self, for: key)
    }
        
    func loadCodable<C: Codable>(_ modelType: C.Type, for key: Key) throws -> C? {
        guard let jsonData = try loadData(key: key) else { return nil }
        return try decoder.decode(C.self, from: jsonData)
    }
    
    func deleteValue(for key: Key) throws {
        try wrapped.remove(key.id, ignoringAttributeSynchronizable: false)
    }
}

private extension KeychainManager {
    
    func loadData(key: Key) throws -> Data? {
        try wrapped.getData(key.id, ignoringAttributeSynchronizable: false)
    }
    
    func save(data: Data, key: Key) throws {
        try wrapped.set(data, key: key.id, ignoringAttributeSynchronizable: false)
    }
}

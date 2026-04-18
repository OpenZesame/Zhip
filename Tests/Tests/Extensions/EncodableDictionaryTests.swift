import XCTest
@testable import Zhip

final class EncodableDictionaryTests: XCTestCase {

    private struct SimpleEncodable: Encodable {
        let name: String
        let count: Int
    }

    func test_dictionaryRepresentation_encodesStringAndIntFields() {
        let sut = SimpleEncodable(name: "alice", count: 3)
        let result = sut.dictionaryRepresentation
        XCTAssertEqual(result["name"] as? String, "alice")
        XCTAssertEqual(result["count"] as? Int, 3)
    }

    func test_dictionaryRepresentation_emptyEncodable_returnsEmptyOrExpectedKeys() {
        struct Empty: Encodable {}
        let sut = Empty()
        let result = sut.dictionaryRepresentation
        XCTAssertTrue(result.isEmpty)
    }
}

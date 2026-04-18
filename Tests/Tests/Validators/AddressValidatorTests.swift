import XCTest
@testable import Zhip

final class AddressValidatorTests: XCTestCase {
    private let sut = AddressValidator()

    func test_validate_emptyString_returnsInvalid() {
        guard case .invalid = sut.validate(input: "") else {
            return XCTFail("expected invalid")
        }
    }

    func test_validate_garbageString_returnsInvalid() {
        guard case .invalid = sut.validate(input: "this is not an address") else {
            return XCTFail("expected invalid")
        }
    }

    func test_validate_tooShortHex_returnsInvalid() {
        guard case .invalid = sut.validate(input: "0x123") else {
            return XCTFail("expected invalid")
        }
    }

    func test_errorMessage_incorrectLength_tooLong_hasMessage() {
        let error = AddressValidator.Error.incorrectLength(expectedLength: 20, butGot: 30)
        XCTAssertFalse(error.errorMessage.isEmpty)
    }

    func test_errorMessage_incorrectLength_tooShort_hasMessage() {
        let error = AddressValidator.Error.incorrectLength(expectedLength: 20, butGot: 10)
        XCTAssertFalse(error.errorMessage.isEmpty)
    }

    func test_errorMessage_notChecksummed_hasMessage() {
        let error = AddressValidator.Error.notChecksummed
        XCTAssertFalse(error.errorMessage.isEmpty)
    }

    func test_errorMessage_noBech32NorHexstring_hasMessage() {
        let error = AddressValidator.Error.noBech32NorHexstring
        XCTAssertFalse(error.errorMessage.isEmpty)
    }
}

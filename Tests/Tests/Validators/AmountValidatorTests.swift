import XCTest
import Zesame
@testable import Zhip

final class AmountValidatorTests: XCTestCase {

    func test_validate_validZilAmountString_returnsValid() {
        let sut = AmountValidator<Amount>()
        let result = sut.validate(input: (amountString: "5", unit: .zil))
        XCTAssertTrue(result.isValid)
    }

    func test_validate_nonNumericString_returnsInvalid() {
        let sut = AmountValidator<Amount>()
        let result = sut.validate(input: (amountString: "abc", unit: .zil))
        XCTAssertFalse(result.isValid)
    }

    func test_validate_emptyString_returnsInvalid() {
        let sut = AmountValidator<Amount>()
        let result = sut.validate(input: (amountString: "", unit: .zil))
        XCTAssertFalse(result.isValid)
    }

    func test_errorMessage_nonNumericString_hasMessage() {
        let error: Zhip.AmountError<Amount> = .nonNumericString
        XCTAssertFalse(error.errorMessage.isEmpty)
    }

    func test_errorMessage_tooLarge_hasMessage() {
        let error: Zhip.AmountError<Amount> = .tooLarge(max: "1000", unit: .zil)
        XCTAssertFalse(error.errorMessage.isEmpty)
    }

    func test_errorMessage_tooSmall_withUnit_hasMessage() {
        let error: Zhip.AmountError<Amount> = .tooSmall(min: "1", unit: .zil, showUnit: true)
        XCTAssertFalse(error.errorMessage.isEmpty)
    }

    func test_errorMessage_tooSmall_withoutUnit_hasMessage() {
        let error: Zhip.AmountError<Amount> = .tooSmall(min: "1", unit: .zil, showUnit: false)
        XCTAssertFalse(error.errorMessage.isEmpty)
    }

    func test_errorMessage_other_hasMessage() {
        struct DummyError: Swift.Error {}
        let error: Zhip.AmountError<Amount> = .other(DummyError())
        XCTAssertFalse(error.errorMessage.isEmpty)
    }
}

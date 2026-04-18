import XCTest
import Zesame
@testable import Zhip

final class SufficientFundsValidatorTests: XCTestCase {

    func test_validate_missingAmount_returnsEmpty() {
        let sut = SufficientFundsValidator()
        let result = sut.validate(input: (amount: nil, gasLimit: nil, gasPrice: nil, balance: nil))
        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.isError)
    }

    func test_errorMessage_insufficientFunds_hasMessage() {
        let error = SufficientFundsValidator.Error.insufficientFunds
        XCTAssertFalse(error.errorMessage.isEmpty)
    }

    func test_errorMessage_amountError_delegatesToInner() {
        let inner: Zhip.AmountError<Amount> = .nonNumericString
        let error = SufficientFundsValidator.Error.amountError(inner)
        XCTAssertEqual(error.errorMessage, inner.errorMessage)
    }
}

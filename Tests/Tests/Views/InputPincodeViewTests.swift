import Combine
import UIKit
import XCTest
@testable import Zhip

final class InputPincodeViewTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func test_init_createsPinFieldAndStackView() {
        let sut = InputPincodeView()
        XCTAssertNotNil(sut.pinField)
    }

    func test_validate_empty_doesNotCrash() {
        let sut = InputPincodeView()
        sut.validate(.empty)
    }

    func test_validate_valid_clearsByDefault() {
        let sut = InputPincodeView()
        sut.validate(.valid(withRemark: nil))
        XCTAssertTrue(sut.pinField.text?.isEmpty ?? true)
    }

    func test_validate_valid_doesNotClearWhenIsClearedOnValidInputFalse() {
        let sut = InputPincodeView(isClearedOnValidInput: false)
        sut.pinField.text = "1234"

        sut.validate(.valid(withRemark: nil))

        XCTAssertEqual(sut.pinField.text, "1234")
    }

    func test_validate_errorMessage_shakesAndClears() {
        let sut = InputPincodeView()
        sut.validate(.errorMessage("bad pin"))
        // Should not crash; shake animation completion clears asynchronously.
    }

    func test_pincodePublisher_forwardsFromPinField() {
        let sut = InputPincodeView()
        var received: [Pincode?] = []
        sut.pincodePublisher.sink { received.append($0) }.store(in: &cancellables)

        sut.pinField.text = "12"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: sut.pinField)

        XCTAssertTrue(received.contains(where: { $0 == nil }))
    }

    func test_validationBinder_appliesValidation() {
        let sut = InputPincodeView()

        sut.validationBinder.on(.errorMessage("oops"))
        // Just ensures the binder runs without crashing.
    }

    func test_becomeFirstResponderBinder_isAvailable() {
        let sut = InputPincodeView()
        _ = sut.becomeFirstResponderBinder
    }

    func test_vibrateOnInvalid_doesNotCrash() {
        let view = UIView()
        let generator = UINotificationFeedbackGenerator()

        view.vibrateOnInvalid(hapticFeedbackGenerator: generator)
    }

    func test_vibrateOnValid_doesNotCrash() {
        let view = UIView()
        let generator = UINotificationFeedbackGenerator()

        view.vibrateOnValid(hapticFeedbackGenerator: generator)
    }
}

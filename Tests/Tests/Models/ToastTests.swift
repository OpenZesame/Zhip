import XCTest
@testable import Zhip

final class ToastTests: XCTestCase {

    func test_initWithDefaults_createsAutoDismissToast() {
        let sut = Toast("hello")
        _ = sut // non-optional, simply verify init doesn't crash
    }

    func test_initWithStringLiteral_createsToast() {
        let sut: Toast = "literal"
        _ = sut
    }

    func test_initWithManualDismissing_createsToast() {
        let sut = Toast("bye", dismissing: .manual(dismissButtonTitle: "OK"))
        _ = sut
    }

    func test_initWithCompletion_createsToast() {
        let sut = Toast("done", dismissing: .after(duration: 0.1), completion: {})
        _ = sut
    }
}

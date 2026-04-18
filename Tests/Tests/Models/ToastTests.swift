import UIKit
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

    func test_presentAutoDismissing_presentsAnAlert() {
        let window = UIWindow(frame: .init(x: 0, y: 0, width: 320, height: 480))
        let host = UIViewController()
        window.rootViewController = host
        window.makeKeyAndVisible()

        let sut = Toast("auto", dismissing: .after(duration: 0.05))
        sut.present(using: host)

        let presented = expectation(description: "alert presented")
        DispatchQueue.main.async { presented.fulfill() }
        wait(for: [presented], timeout: 1.0)

        XCTAssertTrue(host.presentedViewController is UIAlertController)

        let dismissed = expectation(description: "alert dismissed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { dismissed.fulfill() }
        wait(for: [dismissed], timeout: 2.0)

        window.isHidden = true
    }

    func test_presentManualDismiss_addsDismissAction() throws {
        let window = UIWindow(frame: .init(x: 0, y: 0, width: 320, height: 480))
        let host = UIViewController()
        window.rootViewController = host
        window.makeKeyAndVisible()

        let sut = Toast("manual", dismissing: .manual(dismissButtonTitle: "Close"))
        sut.present(using: host)

        let presented = expectation(description: "alert presented")
        DispatchQueue.main.async { presented.fulfill() }
        wait(for: [presented], timeout: 1.0)

        let alert = try XCTUnwrap(host.presentedViewController as? UIAlertController)
        XCTAssertEqual(alert.actions.first?.title, "Close")

        let dismissed = expectation(description: "host dismissed")
        host.dismiss(animated: false) { dismissed.fulfill() }
        wait(for: [dismissed], timeout: 1.0)
        window.isHidden = true
    }
}

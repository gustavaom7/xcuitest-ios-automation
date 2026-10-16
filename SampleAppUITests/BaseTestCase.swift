import XCTest

class BaseTestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Stop at the first failure: later steps depend on earlier ones
        continueAfterFailure = false

        // Launch app fresh for each test
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    // MARK: - Wait Helpers

    func wait(for element: XCUIElement, timeout: TimeInterval = 5.0, expectation message: String) {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        if result == .timedOut {
            XCTFail("Timed out waiting for element: \(message)")
        }
    }

    func waitForElementToDisappear(_ element: XCUIElement, timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        if result == .timedOut {
            XCTFail("Timed out waiting for element to disappear")
        }
    }
}

import XCTest

extension XCUIElement {

    /// Checks if element exists without raising assertion
    var isVisible: Bool {
        self.exists && self.isHittable
    }

    /// Safely taps element if it exists
    func tapIfExists() {
        if self.exists {
            self.tap()
        }
    }

    /// Wait for element to disappear
    func waitForInvisibility(timeout: TimeInterval = 5.0) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
}

extension XCTestCase {

    /// Assert element exists with custom message
    func assertElementExists(_ element: XCUIElement, _ message: String = "Element should exist") {
        XCTAssertTrue(element.exists, message)
    }

    /// Assert element does not exist with custom message
    func assertElementNotExists(_ element: XCUIElement, _ message: String = "Element should not exist") {
        XCTAssertFalse(element.exists, message)
    }

    /// Assert element contains text
    func assertElementContainsText(_ element: XCUIElement, _ text: String, _ message: String? = nil) {
        let msg = message ?? "Element should contain text: '\(text)'"
        XCTAssertTrue(element.label.contains(text), msg)
    }

    /// Screenshot for debugging
    func takeScreenshot(name: String = "screenshot") {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        self.add(attachment)
    }
}

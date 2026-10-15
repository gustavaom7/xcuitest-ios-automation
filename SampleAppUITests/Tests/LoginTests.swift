import XCTest

class LoginTests: BaseTestCase {

    var loginPage: LoginPage!

    override func setUpWithError() throws {
        try super.setUpWithError()
        loginPage = LoginPage(app: app)
    }

    // MARK: - Positive Tests

    func testLoginPageLoadsSuccessfully() {
        loginPage.verifyLoginPageLoaded()
    }

    func testSuccessfulLoginWithValidCredentials() {
        // Arrange
        let email = TestData.ValidCredentials.email
        let password = TestData.ValidCredentials.password

        // Act
        loginPage.login(email: email, password: password)

        // Assert
        let homePage = HomePage(app: app)
        homePage.verifyHomePageLoaded()
        homePage.verifyWelcomeMessage("Welcome")
    }

    func testEmailFieldAcceptsInput() {
        // Act
        loginPage.enterEmail(TestData.ValidCredentials.email)

        // Assert
        XCTAssertTrue(loginPage.emailTextField.value as? String == TestData.ValidCredentials.email)
    }

    func testPasswordFieldHidesInput() {
        // Act
        loginPage.enterPassword(TestData.ValidCredentials.password)

        // Assert: a secure field never exposes what was typed
        XCTAssertTrue(loginPage.passwordTextField.exists)
        XCTAssertNotEqual(loginPage.passwordTextField.value as? String, TestData.ValidCredentials.password)
    }

    // MARK: - Negative Tests

    func testLoginFailsWithInvalidCredentials() {
        // Act
        loginPage.login(
            email: TestData.InvalidCredentials.nonExistentEmail,
            password: TestData.InvalidCredentials.wrongPassword
        )

        // Assert
        loginPage.verifyErrorMessageDisplayed(TestData.ErrorMessages.invalidCredentials)
    }

    func testLoginFailsWithEmptyEmail() {
        // Act
        loginPage.enterPassword(TestData.ValidCredentials.password)
        loginPage.tapLogin()

        // Assert
        loginPage.verifyErrorMessageDisplayed(TestData.ErrorMessages.emailRequired)
    }

    func testLoginFailsWithEmptyPassword() {
        // Act
        loginPage.enterEmail(TestData.ValidCredentials.email)
        loginPage.tapLogin()

        // Assert
        loginPage.verifyErrorMessageDisplayed(TestData.ErrorMessages.passwordRequired)
    }

    func testErrorMessageDisappearsWhenFixed() {
        // Arrange
        loginPage.enterEmail(TestData.InvalidCredentials.nonExistentEmail)
        loginPage.enterPassword(TestData.InvalidCredentials.wrongPassword)
        loginPage.tapLogin()
        loginPage.verifyErrorMessageDisplayed()

        // Act
        loginPage.clearEmailField()
        loginPage.enterEmail(TestData.ValidCredentials.email)
        loginPage.enterPassword(TestData.ValidCredentials.password)
        loginPage.tapLogin()

        // Assert
        let homePage = HomePage(app: app)
        homePage.verifyHomePageLoaded()
    }

    // MARK: - Edge Cases

    func testLoginWithVeryLongEmail() {
        // Act
        loginPage.login(
            email: TestData.EdgeCases.veryLongEmail,
            password: TestData.ValidCredentials.password
        )

        // Assert: an unknown long email is rejected like any other unknown account
        loginPage.verifyErrorMessageDisplayed(TestData.ErrorMessages.invalidCredentials)
    }

    func testLoginWithSpecialCharactersInPassword() {
        // Act
        loginPage.login(
            email: TestData.ValidCredentials.email,
            password: TestData.EdgeCases.specialCharPassword
        )

        // Assert: the password is compared as typed, so a near-miss is rejected
        loginPage.verifyErrorMessageDisplayed(TestData.ErrorMessages.invalidCredentials)
    }

    func testRememberMeToggle() {
        // Arrange
        loginPage.verifyLoginPageLoaded()
        XCTAssertFalse(loginPage.isRememberMeOn, "Remember me should start off")

        // Act
        loginPage.toggleRememberMe()

        // Assert
        XCTAssertTrue(loginPage.isRememberMeOn, "Remember me should be on after one tap")
    }

    // MARK: - UI State Tests

    func testLoginButtonEnabledWithValidInput() {
        // Act
        loginPage.enterEmail(TestData.ValidCredentials.email)
        loginPage.enterPassword(TestData.ValidCredentials.password)

        // Assert
        loginPage.verifyLoginButtonEnabled()
    }

    func testAllElementsVisibleOnLoginPage() {
        // Assert
        loginPage.verifyLoginPageLoaded()
        XCTAssertTrue(loginPage.rememberMeSwitch.exists, "Remember me switch should be visible")
        XCTAssertTrue(loginPage.errorMessage.exists == false, "Error message should not be visible initially")
    }
}

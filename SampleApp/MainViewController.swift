import UIKit

class MainViewController: UIViewController {

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let rememberMeLabel = UILabel()
    let rememberMeSwitch = UISwitch()
    let loginButton = UIButton(type: .system)
    let welcomeLabel = UILabel()
    let errorLabel = UILabel()
    let logoutButton = UIButton(type: .system)
    let settingsButton = UIButton(type: .system)
    let userNameLabel = UILabel()

    var isLoggedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        if isLoggedIn {
            setupHomeScreen()
        } else {
            setupLoginScreen()
        }
    }

    func setupLoginScreen() {
        emailTextField.accessibilityIdentifier = "loginEmailTextField"
        emailTextField.placeholder = "Email"
        emailTextField.text = ""
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        passwordTextField.accessibilityIdentifier = "loginPasswordTextField"
        passwordTextField.placeholder = "Password"
        passwordTextField.text = ""
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        // A retry starts from an empty password instead of appending to the old one.
        passwordTextField.clearsOnBeginEditing = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        rememberMeLabel.text = "Remember me"
        rememberMeLabel.translatesAutoresizingMaskIntoConstraints = false

        rememberMeSwitch.accessibilityIdentifier = "loginRememberMeSwitch"
        rememberMeSwitch.accessibilityLabel = "Remember me"
        rememberMeSwitch.isOn = false
        rememberMeSwitch.translatesAutoresizingMaskIntoConstraints = false

        loginButton.accessibilityIdentifier = "loginSubmitButton"
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        errorLabel.accessibilityIdentifier = "loginErrorMessage"
        errorLabel.textColor = .systemRed
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(rememberMeLabel)
        view.addSubview(rememberMeSwitch)
        view.addSubview(loginButton)
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            emailTextField.widthAnchor.constraint(equalToConstant: 260),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.widthAnchor.constraint(equalToConstant: 260),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            rememberMeLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            rememberMeLabel.centerYAnchor.constraint(equalTo: rememberMeSwitch.centerYAnchor),

            rememberMeSwitch.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            rememberMeSwitch.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: rememberMeSwitch.bottomAnchor, constant: 24),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
        ])
    }

    func setupHomeScreen() {
        welcomeLabel.accessibilityIdentifier = "homeWelcomeLabel"
        welcomeLabel.text = "Welcome"
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false

        userNameLabel.accessibilityIdentifier = "homeUserNameLabel"
        userNameLabel.text = "Test User"
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        logoutButton.accessibilityIdentifier = "homeLogoutButton"
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)

        settingsButton.accessibilityIdentifier = "homeSettingsButton"
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)

        view.addSubview(welcomeLabel)
        view.addSubview(userNameLabel)
        view.addSubview(logoutButton)
        view.addSubview(settingsButton)

        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),

            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 40),

            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
        ])
    }

    @objc func handleLogin() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if email.isEmpty {
            showError("Email is required")
            return
        }
        if password.isEmpty {
            showError("Password is required")
            return
        }

        if email == "test@example.com" && password == "Password123!" {
            isLoggedIn = true
            view.subviews.forEach { $0.removeFromSuperview() }
            setupHomeScreen()
        } else {
            showError("Invalid email or password")
        }
    }

    @objc func handleLogout() {
        isLoggedIn = false
        view.subviews.forEach { $0.removeFromSuperview() }
        setupLoginScreen()
    }

    @objc func handleSettings() {
        let settings = SettingsViewController()
        settings.modalPresentationStyle = .fullScreen
        present(settings, animated: false)
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

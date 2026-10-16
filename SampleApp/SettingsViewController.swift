import UIKit

class SettingsViewController: UIViewController {

    let backButton = UIButton(type: .system)
    let darkModeLabel = UILabel()
    let darkModeSwitch = UISwitch()
    let notificationsLabel = UILabel()
    let notificationsSwitch = UISwitch()
    let versionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        backButton.accessibilityIdentifier = "settingsBackButton"
        backButton.setTitle("Back", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)

        darkModeLabel.text = "Dark mode"
        darkModeLabel.translatesAutoresizingMaskIntoConstraints = false
        darkModeSwitch.accessibilityIdentifier = "settingsDarkModeSwitch"
        darkModeSwitch.accessibilityLabel = "Dark mode"
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        darkModeSwitch.addTarget(self, action: #selector(handleDarkMode), for: .valueChanged)

        notificationsLabel.text = "Notifications"
        notificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationsSwitch.accessibilityIdentifier = "settingsNotificationsSwitch"
        notificationsSwitch.accessibilityLabel = "Notifications"
        notificationsSwitch.isOn = true
        notificationsSwitch.translatesAutoresizingMaskIntoConstraints = false

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
        versionLabel.accessibilityIdentifier = "settingsVersionLabel"
        versionLabel.text = "Version \(version)"
        versionLabel.textColor = .secondaryLabel
        versionLabel.translatesAutoresizingMaskIntoConstraints = false

        [backButton, darkModeLabel, darkModeSwitch, notificationsLabel, notificationsSwitch, versionLabel]
            .forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),

            darkModeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            darkModeLabel.centerYAnchor.constraint(equalTo: darkModeSwitch.centerYAnchor),
            darkModeSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            darkModeSwitch.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),

            notificationsLabel.leadingAnchor.constraint(equalTo: darkModeLabel.leadingAnchor),
            notificationsLabel.centerYAnchor.constraint(equalTo: notificationsSwitch.centerYAnchor),
            notificationsSwitch.trailingAnchor.constraint(equalTo: darkModeSwitch.trailingAnchor),
            notificationsSwitch.topAnchor.constraint(equalTo: darkModeSwitch.bottomAnchor, constant: 24),

            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }

    @objc func handleBack() {
        dismiss(animated: false)
    }

    @objc func handleDarkMode() {
        view.window?.overrideUserInterfaceStyle = darkModeSwitch.isOn ? .dark : .light
    }
}

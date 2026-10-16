# iOS XCUITest Portfolio

[![XCUITest CI](https://github.com/gustavaom7/xcuitest-ios-automation/actions/workflows/xcode-tests.yml/badge.svg?branch=main)](https://github.com/gustavaom7/xcuitest-ios-automation/actions/workflows/xcode-tests.yml)

Native iOS UI tests in **Swift + XCUITest** against a small UIKit sample app that ships in this repo, with the Page Object pattern and CI on a GitHub-hosted macOS runner.

> Portfolio project. The app is deliberately small (login, home, settings): the point is the test code and the pipeline. For a real app on Android and iOS, see the [Appium repo](https://github.com/gustavaom7/appium-mobile-e2e-framework).

## What's here

| | Where |
|---|---|
| Sample app (UIKit, programmatic UI, accessibility identifiers on every control) | `SampleApp/` |
| Page Objects: `LoginPage`, `HomePage`, `SettingsPage` on a shared `BasePage` | `SampleAppUITests/Pages/` |
| 19 UI tests: login (positive, negative, edge cases, UI state) and navigation | `SampleAppUITests/Tests/` |
| One source of truth for accessibility identifiers | `SampleAppUITests/Utils/Accessible.swift` |
| Xcode project generated from a spec, not committed | `project.yml` (XcodeGen) |
| CI: build for testing, run on an available iPhone simulator, pass/fail table in the job summary, `.xcresult` artifact | `.github/workflows/xcode-tests.yml` |

## Project structure

```
project.yml                  XcodeGen spec (app + UI test target, shared scheme)
SampleApp/                   AppDelegate, MainViewController (login/home), SettingsViewController
SampleAppUITests/
  BaseTestCase.swift         fresh launch per test, wait helpers
  Pages/                     BasePage, LoginPage, HomePage, SettingsPage
  Tests/                     LoginTests (13), NavigationTests (6)
  Utils/                     Accessible (identifiers), TestData, XCTest extensions
docs/                        Page Objects, accessibility identifiers, async handling
```

## Running locally

Requires macOS with Xcode and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```bash
brew install xcodegen
xcodegen generate                 # writes SampleApp.xcodeproj (git-ignored)
open SampleApp.xcodeproj          # then ⌘U
# or from the command line:
xcodebuild test -scheme SampleApp -destination 'platform=iOS Simulator,name=iPhone 16'
```

Use any iPhone simulator installed with your Xcode.

## CI

Runs on push to `main`, on pull requests and on demand, on the standard `macos-15` runner (free for public repositories). It generates the project, picks the newest iPhone simulator the installed Xcode can target, builds for testing, runs the tests and uploads the `.xcresult`. The 19 tests take about 16 minutes on the hosted simulator, the whole job about 20.

## Design notes

- **Accessibility identifiers, not labels**, so tests survive copy changes. The app and `Accessible.swift` share the same strings.
- **No fixed sleeps.** Page Objects wait on element existence with `XCTNSPredicateExpectation`.
- **Generated project.** An earlier hand-edited `project.pbxproj` was rejected by Xcode ("The project is damaged"); generating it from `project.yml` keeps the repo reviewable and the build reproducible.

## Not covered yet

- Real devices or a device cloud
- Screenshot comparison, video on failure
- Network stubbing (the sample app has no backend)

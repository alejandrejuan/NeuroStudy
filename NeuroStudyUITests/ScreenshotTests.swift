import XCTest

// MARK: - App Store Screenshot Tests
//
// Captures the three key screens required for App Store submission.
// Run once per required simulator size then export PNGs from the .xcresult bundle.
//
// iPhone: tab bar navigation (portrait).
// iPad:   NavigationSplitView sidebar navigation (landscape so sidebar stays visible).

final class ScreenshotTests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()

        // Rotate iPad to landscape so the NavigationSplitView sidebar is always expanded.
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
        }

        sleep(4) // let entrance animations settle
    }

    override func tearDownWithError() throws {
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .portrait
        }
    }

    // MARK: - Main Test

    func testCaptureAllScreens() throws {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad

        // ?? 01  Brain Atlas ??????????????????????????????????????????????????
        navigate(to: "Explore", isPad: isIpad)
        sleep(2)
        attach(name: "01-BrainMap")

        // ?? 02  Quiz Home ????????????????????????????????????????????????????
        navigate(to: "Quiz", isPad: isIpad)
        sleep(2)
        attach(name: "02-Quiz")

        // ?? 03  Progress Dashboard ???????????????????????????????????????????
        navigate(to: "Progress", isPad: isIpad)
        sleep(2)
        attach(name: "03-Progress")
    }

    // MARK: - Navigation Helper

    /// Navigates to a top-level section.
    ///
    /// On iPhone uses the compact tab bar.
    /// On iPad in landscape the NavigationSplitView sidebar is visible; sidebar
    /// titles are "Explore Atlas", "Practice Quiz", "Your Progress" Ñ so a
    /// CONTAINS predicate on the short key finds them.
    private func navigate(to label: String, isPad: Bool) {
        if isPad {
            // 1. Try collectionView cells (SwiftUI List on iOS 16+)
            let colCell = app.collectionViews.firstMatch.cells
                .matching(NSPredicate(format: "label CONTAINS[c] %@", label))
                .firstMatch
            if colCell.waitForExistence(timeout: 5) {
                colCell.tap()
                sleep(1)
                return
            }

            // 2. Try tableView cells (fallback)
            let tableCell = app.tables.firstMatch.cells
                .matching(NSPredicate(format: "label CONTAINS[c] %@", label))
                .firstMatch
            if tableCell.waitForExistence(timeout: 3) {
                tableCell.tap()
                sleep(1)
                return
            }

            // 3. Try staticText directly
            let text = app.staticTexts
                .matching(NSPredicate(format: "label CONTAINS[c] %@", label))
                .firstMatch
            if text.waitForExistence(timeout: 3) {
                text.tap()
                sleep(1)
                return
            }

            // 4. Any descendant (last resort)
            let any = app.descendants(matching: .any)
                .matching(NSPredicate(format: "label CONTAINS[c] %@", label))
                .element(boundBy: 0)
            if any.waitForExistence(timeout: 3) {
                any.tap()
                sleep(1)
            }
        } else {
            // iPhone tab bar Ñ exact label match
            let tab = app.tabBars.buttons[label]
            if tab.waitForExistence(timeout: 5) { tab.tap() }
        }
    }

    // MARK: - Screenshot Helper

    private func attach(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

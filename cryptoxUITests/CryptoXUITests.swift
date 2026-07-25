//
//  CryptoXUITests.swift
//  cryptoxUITests
//

import XCTest

final class CryptoXUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Coin List

    func testCoinListLoads() throws {
        let list = app.scrollViews["coinList.list"]
        XCTAssertTrue(list.waitForExistence(timeout: 10), "Coin list should appear after loading completes")
    }

    func testCoinRowsAreVisible() throws {
        let list = app.scrollViews["coinList.list"]
        XCTAssertTrue(list.waitForExistence(timeout: 10))

        let bitcoinRow = app.otherElements["coinRow.bitcoin"]
        XCTAssertTrue(bitcoinRow.waitForExistence(timeout: 5), "Bitcoin row should be visible in the list")
    }

    // MARK: - Navigation

    func testTapRowNavigatesToDetails() throws {
        let list = app.scrollViews["coinList.list"]
        XCTAssertTrue(list.waitForExistence(timeout: 10))

        let bitcoinRow = app.otherElements["coinRow.bitcoin"]
        XCTAssertTrue(bitcoinRow.waitForExistence(timeout: 5))
        bitcoinRow.tap()

        let card = app.otherElements["coinDetails.card"]
        XCTAssertTrue(card.waitForExistence(timeout: 5), "Details card should appear after tapping a row")
    }

    func testBackNavigationReturnsToList() throws {
        let list = app.scrollViews["coinList.list"]
        XCTAssertTrue(list.waitForExistence(timeout: 10))

        app.otherElements["coinRow.bitcoin"].tap()
        XCTAssertTrue(app.otherElements["coinDetails.card"].waitForExistence(timeout: 5))

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertTrue(list.waitForExistence(timeout: 5), "Should navigate back to coin list")
    }

    // MARK: - Coin Details

    func testDetailsCardIsVisible() throws {
        let list = app.scrollViews["coinList.list"]
        XCTAssertTrue(list.waitForExistence(timeout: 10))

        app.otherElements["coinRow.bitcoin"].tap()

        let card = app.otherElements["coinDetails.card"]
        XCTAssertTrue(card.waitForExistence(timeout: 5), "Details card should be visible after navigation")
    }
}

//
//  LoginViewControllerTests.swift
//  CalculatorTest
//
//  Created by Dhanshree Nagre on 21/08/20.
//

import XCTest

@testable import Calculator

class LoginViewControllerTests: XCTestCase {

    var subject: LoginViewController!
    var navigationController = UINavigationController()

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        subject = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerID") as? LoginViewController
        subject.loadViewIfNeeded()
        navigationController = UINavigationController(rootViewController: subject)
    }

    /// `viewDidLoad` sets up the view.
    func testViewDidLoad() {
        XCTAssertNotNil(subject.view)
        XCTAssertNotNil(navigationController)
        XCTAssertEqual(navigationController.viewControllers, [subject])
    }

    func testLoginTappedAlert() {
        subject.userName.text = ""
        subject.password.text = ""

        subject.loginTapped(UIButton())
        
        let exp = expectation(description: "Test after 1.5 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(navigationController.visibleViewController is UIAlertController)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testLoginTappedInvalidAlert() {
        subject.userName.text = "test1"
        subject.password.text = "pass1"
        
        subject.loginTapped(UIButton())

        let exp = expectation(description: "Test after 1.5 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(navigationController.visibleViewController is UIAlertController)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testLoginTapped() {
        subject.userName.text = "testUser1"
        subject.password.text = "pass1"

        subject.loginTapped(UIButton())

        XCTAssertNotNil(navigationController.visibleViewController is ViewController)
    }
}

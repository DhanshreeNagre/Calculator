//
//  ViewControllerTests.swift
//  CalculatorTest
//
//  Created by Dhanshree Nagre on 21/08/20.
//

import XCTest

@testable import Calculator

class ViewControllerTests: XCTestCase {

    var subject: ViewController!
    var navigationController = UINavigationController()
    let operationState1 = OperationState(isOperator: false, operatorEntered: nil, number: 20, priority: nil)
    let operationState2 = OperationState(isOperator: true, operatorEntered: "+", number: nil, priority: 3)
    let operationState3 = OperationState(isOperator: false, operatorEntered: nil, number: 10, priority: nil)
    let operationState4 = OperationState(isOperator: true, operatorEntered: "*", number: nil, priority: 4)
    let operationState5 = OperationState(isOperator: false, operatorEntered: nil, number: 5, priority: nil)
    
    

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        subject = storyboard.instantiateViewController(withIdentifier: "ViewControllerID") as? ViewController
        subject.loadViewIfNeeded()
        navigationController = UINavigationController(rootViewController: subject)
    }

    /// `viewDidLoad` sets up the view.
    func testViewDidLoad() {
        XCTAssertNotNil(subject.view)
        XCTAssertNotNil(navigationController)
        XCTAssertEqual(navigationController.viewControllers, [subject])
    }
    

    func testGetOperations() {
        var operations = [operationState1, operationState2, operationState3]
        var expectedResult = subject.getOperations(opsArray: operations)
    
        XCTAssertEqual(expectedResult.opeation, "+")
        XCTAssertEqual(expectedResult.index, 1)
        XCTAssertEqual(expectedResult.priority, 3)
    
        // check for complex expression
        operations = [operationState1, operationState2, operationState3, operationState4, operationState5]
        expectedResult = subject.getOperations(opsArray: operations)
        XCTAssertEqual(expectedResult.opeation, "*")
        XCTAssertEqual(expectedResult.index, 3)
        XCTAssertEqual(expectedResult.priority, 4)
    }

    func testPerformMath() {
        subject.operationsArray = [operationState1, operationState2, operationState3, operationState4, operationState5]
        
        XCTAssertEqual(subject.operationsArray.count, 5)
        
        var operation = (opeation: "*", index: 3, priority: 4)
        subject.performMath(operation: operation)
        
        var expectedOperationState = OperationState(isOperator: false, operatorEntered: nil, number: 50, priority: nil)
    
        XCTAssertEqual(subject.operationsArray.count, 3)
        XCTAssertEqual(subject.operationsArray[2], expectedOperationState)
        XCTAssertEqual(subject.operationsArray[1], operationState2)
        XCTAssertEqual(subject.operationsArray[0], operationState1)
    
        operation = (opeation: "+", index: 1, priority: 3)
        subject.performMath(operation: operation)
    
        expectedOperationState = OperationState(isOperator: false, operatorEntered: nil, number: 70, priority: nil)
        XCTAssertEqual(subject.operationsArray.count, 1)
        XCTAssertEqual(subject.operationsArray[0], expectedOperationState)
    }

    func testClearTapped() {
        subject.totalOperators = 5
        subject.previousValue = "15"
        subject.calculatePanel.text = "Hello this is testing...!"
        subject.operationsArray = [operationState1, operationState2, operationState3]
        
        subject.clearTapped(UIButton())
        
        XCTAssertEqual(subject.operationsArray.count, 0)
        XCTAssertEqual(subject.operationsArray, [])
        XCTAssertEqual(subject.calculatePanel.text, "")
        XCTAssertEqual(subject.previousValue, "")
        XCTAssertEqual(subject.totalOperators, 0)
    }
    
    func testShowResultsTappedForAlert() {
        subject.previousValue = ""
        subject.showResultsTapped(UIButton())
        
        let exp = expectation(description: "Test after 1.5 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(navigationController.visibleViewController is UIAlertController)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testShowResultsTapped() {
        subject.operationsArray = [operationState1, operationState2, operationState3]
        subject.previousValue = "10"
        subject.totalOperators = 1

        XCTAssertEqual(subject.operationsArray.count, 3)

        subject.showResultsTapped(UIButton())
        
        XCTAssertEqual(subject.operationsArray.count, 0)
        XCTAssertEqual(subject.operationsArray, [])
        XCTAssertEqual(subject.calculatePanel.text, "30.00")
        XCTAssertEqual(subject.previousValue, "30.00")
        XCTAssertEqual(subject.totalOperators, 0)
    }

    func testShowHistoryTapped() {

        subject.showHistoryTapped()

        XCTAssertNotNil(navigationController.visibleViewController is HistoryViewController)
    }
}

//
//  ViewController.swift
//  Calculator
//
//  Created by Dhanshree Nagre on 21/08/20.
//

import UIKit

class ViewController: UIViewController {
    
    /// IBOutlet
    @IBOutlet var container: UIView!
    @IBOutlet weak var calculatePanel: UILabel!
    
    var numbersEntered: Double = 0
    var previousValue: String = ""
    var isPerformingOperation = false
    var operationsArray : [OperationState] = [OperationState]()
    var totalOperators = 0
    
    /// Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(showHistoryTapped))
    }
    
    /// @IBAction
    
    @IBAction func numbersTapped(_ sender: UIButton) {
        if let value = calculatePanel.text {
            calculatePanel.text = value + String(sender.tag - 1)
        } else {
            calculatePanel.text = String(sender.tag - 1)
        }
        
        previousValue = previousValue + String(sender.tag - 1)
    }
    
    
    @IBAction func operationsTapped(_ sender: UIButton) {
        var operatorEntered = ""
        var priority = 0
        
        guard let value = calculatePanel.text else {
            return
        }
        
        var operationState = OperationState(isOperator: false, operatorEntered: nil, number: Double(previousValue), priority: nil)
        operationsArray.append(operationState)
        
        previousValue = ""
        totalOperators += 1
        
        switch sender.tag {
        case 12:
            // Divide State
            operatorEntered = "/"
            priority = 2
            calculatePanel.text = value + operatorEntered
            
        case 13:
            // Multiplication State
            operatorEntered = "*"
            priority = 4
            calculatePanel.text = value + operatorEntered
            
        case 14:
            // Substraction State
            operatorEntered = "-"
            priority = 1
            calculatePanel.text = value + operatorEntered
            
        case 15:
            // Addition State
            operatorEntered = "+"
            priority = 3
            calculatePanel.text = value + operatorEntered
        default:
            break
        }
        operationState = OperationState(isOperator: true, operatorEntered: operatorEntered, number: nil, priority: priority)
        operationsArray.append(operationState)
    }
    
    @IBAction func showResultsTapped(_ sender: UIButton) {
        // Calculate Result
        
        guard previousValue != "" else {
            // Show error alert here 'please enter valid operation'
            let alert = UIAlertController(title: "Invalid Expression", message: "Please enter valid expression.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let operationState = OperationState(isOperator: false, operatorEntered: nil, number: Double(previousValue), priority: nil)
        operationsArray.append(operationState)
        
        for _ in 0..<totalOperators {
            let operation = getOperations(opsArray: operationsArray)
            performMath(operation: operation)
        }
        
        if let result = operationsArray[0].number {
            let resultValue = String(format: "%.2f", result)
            UserDefaults.standard.set("\(resultValue)", forKey: "\(calculatePanel.text!)")
            calculatePanel.text = resultValue
            previousValue = resultValue
            totalOperators = 0
            operationsArray.removeAll()
        }
    }
    
    
    @IBAction func clearTapped(_ sender: UIButton) {
        // Clear Action
        operationsArray = []
        calculatePanel.text = ""
        previousValue = ""
        totalOperators = 0
    }
    
    @objc func showHistoryTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HistoryViewControllerID") as? HistoryViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    /// User define functions
    
    func getOperations(opsArray: [OperationState]) -> (opeation: String, index: Int, priority: Int) {
        var opeationTemp = ""
        var indexTemp = 0
        var priorityTemp = 0
        
        for (index, element) in opsArray.enumerated() {
            print("Item \(index): \(element)")
            if element.isOperator {
                if let prior = element.priority {
                    if priorityTemp < prior {
                        opeationTemp = element.operatorEntered ?? ""
                        indexTemp = index
                        priorityTemp = prior
                    }
                }
            }
        }
        
        return (opeationTemp, indexTemp, priorityTemp)
    }
    
    func performMath(operation: (opeation: String, index: Int, priority: Int)) {
        // operationsArray and totalOperators --> performMath ---> update the calculatePanel label ---> push to history array
        // update the operationsArray with the evaluated value and the remaining operations
        var result: NSNumber = NSNumber()
        
        let indexToInserted = operation.index - 1
        if let firstOperand = operationsArray[operation.index - 1].number,
           let seconOperand = operationsArray[operation.index + 1].number,
           let enteredOperator = operationsArray[operation.index].operatorEntered {
            let numericExpression = "\(firstOperand) \(enteredOperator) \(seconOperand)"
            print(numericExpression)
            let expression = NSExpression(format: numericExpression)
            result = expression.expressionValue(with: nil, context: nil) as! NSNumber
            let operationState = OperationState(isOperator: false, operatorEntered: nil, number: Double(truncating: result), priority: nil)
            print(operationsArray)
            
            operationsArray.remove(at: indexToInserted)
            operationsArray.insert(operationState, at: indexToInserted)
            operationsArray.remove(at: operation.index)
            operationsArray.remove(at: operation.index)
        }
    }
}


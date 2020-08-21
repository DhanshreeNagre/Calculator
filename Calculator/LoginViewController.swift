//
//  LoginViewController.swift
//  Calculator
//
//  Created by Dhanshree Nagre on 21/08/20.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let usernameText = userName.text
        let passwordText = password.text
        
        if usernameText == "" && passwordText == "" {
            let alert = UIAlertController(title: "Enter Credentials", message: "Please enter user name and password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            if usernameText == "testUser1" && passwordText == "pass1" {
                if let calculatorVC = storyboard?.instantiateViewController(withIdentifier: "ViewControllerID") as? ViewController {
                    navigationController?.pushViewController(calculatorVC, animated: true)
                }
                
            } else {
                let alert = UIAlertController(title: "Invalid Credentials", message: "Please enter valid user name and password.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

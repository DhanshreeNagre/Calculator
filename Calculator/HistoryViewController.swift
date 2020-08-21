//
//  HistoryViewController.swift
//  Calculator
//
//  Created by Dhanshree Nagre on 21/08/20.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var history = [String:String]()

    var keysList:[String] {
        get{
            return Array(history.keys)
        }
    }

    var valuesList:[String] {
        get{
            return Array(history.values)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let keysArray = UserDefaults.standard.dictionaryRepresentation().keys
        let historyArray = UserDefaults.standard.dictionaryRepresentation()
        
        for key in keysArray {
            let decimalCharacters = CharacterSet.decimalDigits
            let decimalRange = key.rangeOfCharacter(from: decimalCharacters)
            if decimalRange != nil {
                history[key] = historyArray[key] as? String
            }
        }
        
        if history.count > 10 {
            let value = history.count - 10
            
            for index in 0...value {
                UserDefaults.standard.removeObject(forKey: keysList[index])
            }
        }
    }
}


/// TableView: Delegate and datasource Methods
///
extension HistoryViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Expressions"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")

        cell.textLabel?.text = keysList[indexPath.row]
        cell.detailTextLabel?.text = valuesList[indexPath.row]
        cell.selectionStyle = .none
    
        return cell
    }
}

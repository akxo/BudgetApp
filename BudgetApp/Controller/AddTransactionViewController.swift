//
//  AddTransactionViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/21/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var transaction = Transaction()
    
    var editingIndex: Int? = nil
    
    var amount: Int = 0
    
    let transactionInfoTitle = ["MERCHANT", "DATE", "REPEAT", "CATEGORY"]

    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var transactionInfoTableView: UITableView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.amountTextField.becomeFirstResponder()
        amountTextField.tintColor = UIColor.clear
//        amountTextField.isUserInteractionEnabled = false
        transactionInfoTableView.isScrollEnabled = false
        
//        updateAmountLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if transaction.isSavable {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        transactionInfoTableView.reloadData()
    }

    private func updateAmountLabel() {
        var label = "-$"
        if editingIndex != nil {
            label.append(String(transaction.amount))
        } else if amountTextField.text == nil || amountTextField.text == "" {
            label.append("0.00")
        } else {
            let input = amountTextField.text!
            var index = (input.count > 3) ? input.count-1 : 2
            while index >= 0 {
                if index == 1 {
                    label.append(".")
                }
                if index > input.count-1 {
                    label.append("0")
                } else {
                    label.append(input[input.index(input.startIndex, offsetBy: (input.count - 1 - index))])
                }
                index -= 1
            }
        }
        amountLabel.text = label
    }
    
    @IBAction func saveTransaction(_ sender: Any) {
        if editingIndex != nil {
            OverviewViewController.budget.allTransactions[editingIndex!] = transaction
        } else {
            OverviewViewController.budget.addTransaction(transaction: transaction)
        } 
        OverviewViewController.saveBudget()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        updateAmountLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Back button
        let backItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: nil)
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        // MerchantViewController
        if segue.identifier == "chooseMerchant" {
            let destination = segue.destination as? MerchantViewController
            if transaction.merchant != "" {
                destination?.selectedMerchant = transaction.merchant
            }
            destination?.delegate = self

        // DateViewController
        } else if segue.identifier == "chooseDate" {
            let destination = segue.destination as? DateViewController
            destination?.date = transaction.date
            destination?.delegate = self
        
        // FrequencyViewController
        } else if segue.identifier == "chooseFrequency" {
            let destination = segue.destination as? FrequencyViewController
            destination?.frequency = transaction.frequency
            destination?.delegate = self
            
        // CategoryViewController
        } else if segue.identifier == "chooseCategory" {
            let destination = segue.destination as? CategoryViewController
            destination?.selectedCategory = transaction.categoryName
            destination?.delegate = self
        }
    }
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionInfo", for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.textLabel?.text = transactionInfoTitle[indexPath.row]
        cell.detailTextLabel?.text = transaction.getDetailInfo()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            performSegue(withIdentifier: "chooseMerchant", sender: self)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "chooseDate", sender: self)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "chooseFrequency", sender: self)
        } else if indexPath.row == 3 {
            performSegue(withIdentifier: "chooseCategory", sender: self)
        }
    }
}


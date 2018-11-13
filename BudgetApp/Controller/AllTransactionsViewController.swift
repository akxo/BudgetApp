//
//  AllTransactionsViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 11/10/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class AllTransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var transactionSearchBar: UISearchBar!
    @IBOutlet weak var allTransactionsTableView: UITableView!
    
    var monthlyTransactions = [[Transaction]]()
    var filteredMonthlyTransactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        transactionSearchBar.backgroundColor = #colorLiteral(red: 0.4039215686, green: 0.5254901961, blue: 0.7176470588, alpha: 1)
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        allTransactionsTableView.register(nib, forCellReuseIdentifier: "TransactionTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let budget = OverviewViewController.budget
        for month in budget.getMonths() {
            let month = String(month.split(separator: " ")[0])
            let transactions = budget.allTransactions.filter({ $0.date.getMonthName() == month })
            if !transactions.isEmpty {
                monthlyTransactions.insert(transactions, at: 0)
            }
        }
    }
    
    // MARK SearchBar Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    // MARK: TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return monthlyTransactions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let date = monthlyTransactions[section].first?.date {
            return date.getMonthHeader()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthlyTransactions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        let transaction = monthlyTransactions[indexPath.section][indexPath.row]
        let transactionInfo = transaction.getAllInfo()
        cell.monthLabel.text = transactionInfo[0]
        cell.dayLabel.text = transactionInfo[1]
        cell.merchantLabel.text = transactionInfo[2]
        cell.categoryLabel.text = transactionInfo[3]
        cell.integerAmountLabel.text = transactionInfo[4]
        cell.decimalAmountLabel.text = transactionInfo[5]
        return cell
    }

}

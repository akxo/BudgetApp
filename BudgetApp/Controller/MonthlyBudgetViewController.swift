//
//  MonthlyBudgetViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/25/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class MonthlyBudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var month: String = ""
    
    var categories: [Category] {
        return OverviewViewController.budget.categories
    }
    @IBOutlet weak var budgetCategoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        budgetCategoriesTableView.register(nib, forCellReuseIdentifier: "CategoryTableViewCell")
        
        if categories.count == 0 {
            budgetCategoriesTableView.isHidden = true
        }
    }
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let category = categories[indexPath.row]
        
        var temp: Float = 0.0
        for tran in OverviewViewController.budget.allTransactions.filter({$0.categoryName == category.name}) {
            temp += tran.amount
        }
        let total = Int(temp)
        let difference = category.limit - total
        
        cell.budgetProgress.progress = OverviewViewController.budget.getProgress(categoryName: category.name)
        cell.todayValueConstraint.constant = (cell.budgetProgress.frame.width * OverviewViewController.budget.getTodayValue(categoryName: category.name)) + 16.0
        cell.categoryLabel.text = category.name
        cell.progressLabel.text = "$\(total) of $\(category.limit)"
        cell.differenceLabel.text = "$\(abs(difference)) " + (difference <= 0 ? "Left" : "Over")
        return cell
    }
    
    
}

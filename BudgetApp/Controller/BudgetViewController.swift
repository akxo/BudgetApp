//
//  BudgetViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/25/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {
    
    var monthNames: [String] = []
    
    var monthlyBudgets: [MonthlyBudgetViewController] = []
    
    @IBOutlet weak var budgetScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let currMonth = addMonthlyBudget(monthName: monthNames[0])
        let prevMonth = addMonthlyBudget(monthName: monthNames[1])
        let prevPrevMonth = addMonthlyBudget(monthName: monthNames[2])
        
        monthlyBudgets = [currMonth, prevMonth, prevPrevMonth]
        
        let views: [String : UIView] = ["view" : view, "currMonth" : currMonth.view, "prevMonth" : prevMonth.view, "prevPrevMonth" : prevPrevMonth.view]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[currMonth(==view)]|", options: [], metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[prevPrevMonth(==view)][prevMonth(==view)][currMonth(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
    
    private func addMonthlyBudget(monthName: String) -> MonthlyBudgetViewController {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MonthlyBudgetViewController") as? MonthlyBudgetViewController ?? MonthlyBudgetViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.month = monthName
        budgetScrollView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        return viewController
    }
    
}

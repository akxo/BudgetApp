//
//  BudgetPageViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/28/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class BudgetPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var monthNames: [String] = []
    
    lazy var monthlyBudgets: [UIViewController] = {
        return [addMonthlyBudget(monthName: monthNames[0]),
                addMonthlyBudget(monthName: monthNames[1]),
                addMonthlyBudget(monthName: monthNames[2])]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        self.dataSource = self
        if let firstViewController = monthlyBudgets.last {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func addMonthlyBudget(monthName: String) -> MonthlyBudgetViewController {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MonthlyBudgetViewController") as? MonthlyBudgetViewController ?? MonthlyBudgetViewController()
        viewController.month = monthName
        return viewController
    }

    // MARK: Page View Methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = monthlyBudgets.index(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return monthlyBudgets[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = monthlyBudgets.index(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard monthlyBudgets.count > nextIndex else { return nil }
        return monthlyBudgets[nextIndex]
    }
}

//
//  BudgetViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/25/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController, UIScrollViewDelegate {
    
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
        
        self.budgetScrollView.delegate = self
        self.budgetScrollView.contentSize.height = 1.0
        budgetScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if budgetScrollView.contentOffset.y > 0 || budgetScrollView.contentOffset.y < 0 {
    //            budgetScrollView.contentOffset.y = 0
    //        }
    //    }
    
    private func addMonthlyBudget(monthName: String) -> MonthlyBudgetViewController {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MonthlyBudgetViewController") as? MonthlyBudgetViewController ?? MonthlyBudgetViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.month = monthName
        budgetScrollView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        return viewController
    }
    
}

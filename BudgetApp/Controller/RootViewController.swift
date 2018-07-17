//
//  ViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/16/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    static var budget: Budget {
        return getBudget()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    static func getBudget() -> Budget {
        guard let budgetData = UserDefaults.standard.object(forKey: "budgetData") as? Data,
            let budget = NSKeyedUnarchiver.unarchiveObject(with: budgetData) as? Budget else {return Budget()}
        return budget
    }
    
    static func saveBudget() {
        let budgetData = NSKeyedArchiver.archivedData(withRootObject: budget)
        UserDefaults.standard.set(budgetData, forKey: "budgetData")
    }
}


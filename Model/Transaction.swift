//
//  Transaction.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/15/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import Foundation

public class Transaction {
    
    // MARK: Properties
    var date: Date
    var merchant: String
    var amount: Double
    var category: Category
    
    // MARK: Initializer
    init(date: Date, merchant: String, amount: Double, category: Category) {
        self.date = date
        self.merchant = merchant
        self.amount = amount
        self.category = category
    }
}

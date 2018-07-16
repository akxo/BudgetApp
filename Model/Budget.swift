//
//  Budget.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/15/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import Foundation

public class Budget {
    
    // MARK: Properties
    var currentDate: Date
    var categories: [Category]
    var allTransactions: [Transaction]
    var reoccurringTransactions: [ReoccurringTransaction]
    var recentMerchants: [String]
    let monthlyIncome: Int
    
    // MARK: Initializer
    init(monthlyIncome: Int) {
        self.currentDate = Date()
        self.categories = []
        self.allTransactions = []
        self.reoccurringTransactions = []
        self.recentMerchants = []
        self.monthlyIncome = monthlyIncome
    }
    
    // MARK: Methods
    func addCategory(category: Category) {
        categories.append(category)
        // TODO: Sort categories?
    }
    
    func addTransaction(transaction: Transaction) {
        allTransactions.append(transaction)
        allTransactions.sort(by: {$0.date < $1.date})
    }
    
    func addReoccurringTransaction(transaction: ReoccurringTransaction) {
        if currentDate >= transaction.date {
            allTransactions.append(transaction)
        }
        reoccurringTransactions.append(transaction)
    }
    
    func manageAllTransactions() {
        var dateComponent = DateComponents()
        dateComponent.month = -2
        var oldestKeptDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? currentDate
        oldestKeptDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: oldestKeptDate) ?? currentDate
        allTransactions = allTransactions.filter { $0.date >= oldestKeptDate}
    }
    
    func manageReoccurringTransactions() {
        for transaction in reoccurringTransactions {
            if transaction.date <= currentDate {
                transaction.updateDate()
                allTransactions.append(transaction)
            } else {
                break
            }
        }
    }
    
    
}

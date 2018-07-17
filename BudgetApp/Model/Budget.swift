//
//  Budget.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/15/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import Foundation

public class Budget: NSObject, NSCoding {

    // MARK: Properties
    var currentDate: Date
    var categories: [Category]
    var allTransactions: [Transaction]
    var reoccurringTransactions: [ReoccurringTransaction]
    var recentMerchants: [(name: String, category: String)]
    
    // MARK: Initializer
    override init() {
        self.currentDate = Date()
        self.categories = []
        self.allTransactions = []
        self.reoccurringTransactions = []
        self.recentMerchants = []
    }
    
    init(currentDate: Date, categories: [Category], allTransactions: [Transaction], reoccurringTransactions: [ReoccurringTransaction], recentMerchants: [(String, String)]) {
        self.currentDate = currentDate
        self.categories = categories
        self.allTransactions = allTransactions
        self.reoccurringTransactions = []
        self.recentMerchants = []
    }
    
    // Protocol Conformation
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let currentDate = aDecoder.decodeObject(forKey: "currentDate") as? Date,
            let categories = aDecoder.decodeObject(forKey: "categories") as? [Category],
            let allTransactions = aDecoder.decodeObject(forKey: "allTransactions") as? [Transaction],
            let reoccurringTransactions = aDecoder.decodeObject(forKey: "reoccurringTransactions") as? [ReoccurringTransaction],
            let recentMerchants = aDecoder.decodeObject(forKey: "recentMerchants") as? [(String, String)] else {return nil}
        
        self.init(currentDate: currentDate, categories: categories, allTransactions: allTransactions, reoccurringTransactions: reoccurringTransactions, recentMerchants: recentMerchants)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(currentDate, forKey: "currentDate")
        aCoder.encode(categories, forKey: "categories")
        aCoder.encode(allTransactions, forKey: "allTransactions")
        aCoder.encode(reoccurringTransactions, forKey: "reoccurringTransactions")
        aCoder.encode(recentMerchants, forKey: "recentMerchants")
    }
    
    // MARK: Methods
    func addCategory(category: Category) {
        categories.append(category)
        // TODO: Sort categories?
    }
    
    func addTransaction(transaction: Transaction) {
        allTransactions.append(transaction)
        allTransactions.sort(by: {$0.date < $1.date})
        addMerchant(transaction: transaction)
    }
    
    func addMerchant(transaction: Transaction) {
        var newMerchants = recentMerchants.filter({$0.name != transaction.merchant})
        newMerchants.insert((transaction.merchant, transaction.category), at: 0)
        recentMerchants = newMerchants
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

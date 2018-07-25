//
//  Budget.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/15/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import Foundation
import UIKit

public class Budget: NSObject, NSCoding {

    // MARK: Properties
    var currentDate: Date
    var categories: [Category]
    var allTransactions: [Transaction]
    var reoccurringTransactions: [Transaction]
    var recentMerchants: [String : String]
    
    // MARK: Computed Properties
    var totalLimit: Float {
        var total: Float = 0.0
        for cat in categories {
            total += Float(cat.limit)
        }
        return total
    }
    
    // MARK: Initializer
    override init() {
        self.currentDate = Date()
        self.categories = []
        self.allTransactions = []
        self.reoccurringTransactions = []
        self.recentMerchants = [:]
    }
    
    init(currentDate: Date, categories: [Category], allTransactions: [Transaction], reoccurringTransactions: [Transaction], recentMerchants: [String : String]) {
        self.currentDate = currentDate
        self.categories = categories
        self.allTransactions = allTransactions
        self.reoccurringTransactions = []
        self.recentMerchants = [:]
    }
    
    // Protocol Conformation
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let currentDate = aDecoder.decodeObject(forKey: "currentDate") as? Date,
            let categories = aDecoder.decodeObject(forKey: "categories") as? [Category],
            let allTransactions = aDecoder.decodeObject(forKey: "allTransactions") as? [Transaction],
            let reoccurringTransactions = aDecoder.decodeObject(forKey: "reoccurringTransactions") as? [Transaction],
        let recentMerchants = aDecoder.decodeObject(forKey: "recentMerchants") as? [String : String] else {return nil}
        
        self.init(currentDate: currentDate, categories: categories, allTransactions: allTransactions, reoccurringTransactions: reoccurringTransactions, recentMerchants: recentMerchants)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(currentDate, forKey: "currentDate")
        aCoder.encode(categories, forKey: "categories")
        aCoder.encode(allTransactions, forKey: "allTransactions")
        aCoder.encode(reoccurringTransactions, forKey: "reoccurringTransactions")
        aCoder.encode(recentMerchants, forKey: "recentMerchants")
    }
    
    // MARK: Functional Methods
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
//        var newMerchants = recentMerchants.filter({$0.name != transaction.merchant})
//        newMerchants.insert((transaction.merchant, transaction.category), at: 0)
//        recentMerchants = newMerchants
    }
    
    func addReoccurringTransaction(transaction: Transaction) {
        if currentDate >= transaction.date {
            allTransactions.append(transaction)
        }
        reoccurringTransactions.append(transaction)
    }
    
    // MARK: Updating Methods
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
    
    // MARK: Convinience Methods
    func getMonths() -> [String] {
        var months = [currentDate.getMonthName()]
        var dateComponent = DateComponents()
        dateComponent.month = -1
        months += [Calendar.current.date(byAdding: dateComponent, to: currentDate)?.getMonthName() ?? ""]
        dateComponent.month = -2
        months += [Calendar.current.date(byAdding: dateComponent, to: currentDate)?.getMonthName() ?? ""]
        
        return months
    }
    
    func getProgress(categoryName: String) -> Float {
        var total: Float = 0.0
        if categoryName == "All" {
            for transaction in allTransactions {
                total += transaction.amount
            }
        } else {
            for transaction in allTransactions.filter({$0.categoryName == categoryName}) {
                total += transaction.amount
            }
        }
        return total
    }
    
    func getTodayValue(categoryName: String) -> CGFloat {
        guard let range = Calendar.current.range(of: .day, in: .month, for: currentDate) else { return 0.0 }
        let numDays = Float(range.count)
        var alreadySpent: Float = 0.0
        var yetToSpend: Float = 0.0
        if categoryName == "All" {
            for tran in allTransactions {
                alreadySpent += tran.amount
            }
            for recTran in reoccurringTransactions {
                var date = recTran.date
                while date < currentDate.lastDay {
                    if date > currentDate {
                        yetToSpend += recTran.amount
                    }
                    date = recTran.getNextDate(date: date)
                }
            }
            var totalLimit: Int = 0
            for cat in categories {
                totalLimit += cat.limit
            }
        } else {
            for tran in allTransactions.filter({$0.categoryName == categoryName}) {
                alreadySpent += tran.amount
            }
            for recTran in reoccurringTransactions.filter({$0.categoryName == categoryName}) {
                var date = recTran.date
                while date < currentDate.lastDay {
                    if date > currentDate {
                        yetToSpend += recTran.amount
                    }
                    date = recTran.getNextDate(date: date)
                }
            }
        }
        guard yetToSpend <= totalLimit else { return 1.0 }
        let remainingLimit = totalLimit - yetToSpend
        return CGFloat((remainingLimit / numDays) * Float(currentDate.day))

    }
    
}
    
    extension Date {
        
        var day: Int {
            return Calendar.current.component(.day, from: self)
        }
        
        var lastDay: Date {
            let components = Calendar.current.dateComponents([.year, .month], from: self)
            let firstDay = Calendar.current.date(byAdding: components, to: self) ?? Date()
            var dateComponents = DateComponents()
            dateComponents.month = 1
            dateComponents.day = -1
            return Calendar.current.date(byAdding: dateComponents, to: firstDay) ?? Date()
        }
        
        func getMonthName() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let strMonth = dateFormatter.string(from: self)
            return strMonth
        }
        
        func getDescription() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            let strMonth = dateFormatter.string(from: self)
            return strMonth
        }
}

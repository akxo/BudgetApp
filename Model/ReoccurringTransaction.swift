//
//  ReoccurringTransaction.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/15/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import Foundation

public class ReoccurringTransaction: Transaction {
    
    // MARK: Properties
    var frequency: Reoccurrance
    
    // MARK: Initializer
    init(date: Date, merchant: String, amount: Double, category: Category, frequency: Reoccurrance) {
        self.frequency = frequency
        super.init(date: date, merchant: merchant, amount: amount, category: category)
    }
    
    // MARK: Methods
    func updateDate() {
        var dateComponent = DateComponents()
        switch frequency {
        case .daily:
            dateComponent.day = 1
        case .weekly:
            dateComponent.day = 7
        case .biweekly:
            dateComponent.day = 14
        case .triweekly:
            dateComponent.day = 21
        case .monthly:
            dateComponent.month = 1
        }
        self.date = Calendar.current.date(byAdding: dateComponent, to: self.date) ?? self.date
    }
}

public enum Reoccurrance: CustomStringConvertible {
    
    case daily
    case weekly
    case biweekly
    case triweekly
    case monthly
    
    public var description: String {
        switch self {
        case .daily:
            return "Every Day"
        case .weekly:
            return "Every Week"
        case .biweekly:
            return "Every Two Weeks"
        case .triweekly:
            return "Every Three Weeks"
        case .monthly:
            return "Every Month"
        }
    }
}

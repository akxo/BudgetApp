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
    var frequency: Int
    
    // MARK: Initializer
    init(date: Date, merchant: String, amount: Double, category: String, frequency: Int) {
        self.frequency = frequency
        super.init(date: date, merchant: merchant, amount: amount, category: category)
    }
    
    // Protocol Conformation
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let date = aDecoder.decodeObject(forKey: "date") as? Date,
            let merchant = aDecoder.decodeObject(forKey: "merchant") as? String,
            let category = aDecoder.decodeObject(forKey: "category") as? String else {return nil}
        
        self.init(date: date, merchant: merchant, amount: aDecoder.decodeDouble(forKey: "amount"), category: category, frequency: aDecoder.decodeInteger(forKey: "frequency"))
    }
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(frequency, forKey: "frequency")
        super.encode(with: aCoder)
    }
    
    // MARK: Methods
    func updateDate() {
        var dateComponent = DateComponents()
        if frequency == 1 {
            dateComponent.day = 1
        } else if frequency == 7 {
            dateComponent.day = 7
        } else if frequency == 14 {
            dateComponent.day = 14
        } else if frequency == 21 {
            dateComponent.day = 21
        } else if frequency == 30 {
            dateComponent.month = 1
        }
        self.date = Calendar.current.date(byAdding: dateComponent, to: self.date) ?? self.date
    }
}


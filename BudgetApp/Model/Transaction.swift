//
//  Transaction.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/15/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import Foundation

public class Transaction: NSObject, NSCoding {
    
    // MARK: Properties
    var date: Date
    var merchant: String
    var amount: Double
    var category: String
    
    // MARK: Initializer
    init(date: Date, merchant: String, amount: Double, category: String) {
        self.date = date
        self.merchant = merchant
        self.amount = amount
        self.category = category
    }
    
    // Protocol Conformation
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let date = aDecoder.decodeObject(forKey: "date") as? Date,
            let merchant = aDecoder.decodeObject(forKey: "merchant") as? String,
            let category = aDecoder.decodeObject(forKey: "category") as? String else {return nil}
        
        self.init(date: date, merchant: merchant, amount: aDecoder.decodeDouble(forKey: "amount"), category: category)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(merchant, forKey: "merchant")
        aCoder.encode(amount, forKey: "amount")
        aCoder.encode(category, forKey: "category")
    }
}

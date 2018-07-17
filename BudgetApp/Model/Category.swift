//
//  Category.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/15/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import Foundation

public class Category: NSObject, NSCoding {
    
    // MARK: Properties
    var name: String
    var limit: Int
    
    // Initializer
    init(name: String, limit: Int) {
        self.name = name
        self.limit = limit
    }
    
    // Protocol Conformation
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {return nil}
        
        self.init(name: name, limit: aDecoder.decodeInteger(forKey: "limit"))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(limit, forKey: "limit")
    }
}

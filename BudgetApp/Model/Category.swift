//
//  Category.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/15/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import Foundation

public class Category {
    
    // MARK: Properties
    var name: String
    var limit: Int
    
    // Initializer
    init(name: String, limit: Int) {
        self.name = name
        self.limit = limit
    }
}

//
//  TransactionTableViewCell.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/18/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TransactionTableViewCell"
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var merchantLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var integerAmountLabel: UILabel!
    
    @IBOutlet weak var decimalAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        monthLabel.text = ""
        dayLabel.text = ""
        merchantLabel.text = ""
        categoryLabel.text = ""
        integerAmountLabel.text = ""
        decimalAmountLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

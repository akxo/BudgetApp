//
//  DateViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/22/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    var delegate: DateViewControllerDelegate?
    
    var date = Date()
    
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var referenceLabel: UILabel!
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.date = sender.date
        dateLabel.text = getDateString()
        updateReferenceLabel()
    }
    
    @IBAction func saveDate(_ sender: UIBarButtonItem) {
        delegate?.sendDateBack(date: date)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        datePicker.date = date
        dateLabel.text = getDateString()
        updateReferenceLabel()
    }

    private func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE,  MMMM  dd,  yyyy"
        return dateFormatter.string(from: self.date)
    }
    
    private func updateReferenceLabel() {
        if Calendar.current.isDateInToday(self.date) {
            referenceLabel.text = "Today"
        } else if Calendar.current.isDateInYesterday(self.date) {
            referenceLabel.text = "Yesterday"
        } else if Calendar.current.isDateInTomorrow(self.date) {
            referenceLabel.text = "Tomorrow"
        } else {
            referenceLabel.text = ""
        }
    }
}

protocol DateViewControllerDelegate {
    func sendDateBack(date: Date)
}

extension AddTransactionViewController: DateViewControllerDelegate {
    func sendDateBack(date: Date) {
        self.transaction.date = date
    }
}

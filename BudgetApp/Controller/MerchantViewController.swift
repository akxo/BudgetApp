//
//  MerchantViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/21/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class MerchantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var delegate: MerchantViewControllerDelegate?
    
    var merchants: [String] = []
    
    var filteredMerchants: [String] = []
    
    var selectedMerchant: String?
    
    var isSearching: Bool {
        
        return merchantSearchBar.text != nil && merchantSearchBar.text != ""
    }
    
    @IBOutlet weak var merchantSearchBar: UISearchBar!
    
    @IBOutlet weak var merchantsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        for merch in OverviewViewController.budget.recentMerchants {
            merchants.append(merch.key)
        }
        
        merchantsTableView.alwaysBounceVertical = false
    }
    
    // MARK: Search Bar Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isSearching {
            filteredMerchants = merchants.filter({$0.contains(searchText) == true})
        } else {
            filteredMerchants = merchants
        }
        merchantsTableView.reloadData()
    }
    
    // MARK: Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if isSearching {
            if section == 0 {
                return ""
            } else {
                return "Recent"
            }
        } else {
            return "Recent"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if section == 0 {
                return 1
            }
        }
        return merchants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "merchantCell", for: indexPath)
        if isSearching {
            if indexPath.section == 0 {
                cell.textLabel?.text = "Create \"\(merchantSearchBar.text ?? "")\""
            } else {
                cell.textLabel?.text = filteredMerchants[indexPath.row]
            }
        } else {
            cell.textLabel?.text = filteredMerchants[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching, indexPath.section == 0 {
            selectedMerchant = merchantSearchBar.text!
        } else {
            selectedMerchant = filteredMerchants[indexPath.row]
        }
        delegate?.sendMerchantBack(merchant: selectedMerchant!)
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}
    
protocol MerchantViewControllerDelegate {
    func sendMerchantBack(merchant: String)
}

extension AddTransactionViewController: MerchantViewControllerDelegate {
    func sendMerchantBack(merchant: String) {
        self.transaction.merchant = merchant
    }
}



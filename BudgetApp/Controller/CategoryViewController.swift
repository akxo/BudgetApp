//
//  CategoryViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/22/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var delegate: CategoryViewControllerDelegate?
    
    var selectedCategory: String = ""
    
    var categories: [String] = []
    
    var filteredCategories: [String] = []
    
    var isSearching: Bool {
        
        return categorySearchBar.text != nil && categorySearchBar.text != ""
    }
    
    @IBOutlet weak var categorySearchBar: UISearchBar!
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        categorySearchBar.backgroundColor = #colorLiteral(red: 0.4039215686, green: 0.5254901961, blue: 0.7176470588, alpha: 1)
        
        for cat in OverviewViewController.budget.categories {
            categories.append(cat.name)
        }
        
        filteredCategories = categories
    }
    
    // MARK: Search Bar Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isSearching {
            filteredCategories = categories.filter({$0.contains(searchText) == true})
        } else {
            filteredCategories = categories
        }
        categoryTableView.reloadData()
    }
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = filteredCategories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = filteredCategories[indexPath.row]
        delegate?.sendCategoryBack(category: selectedCategory)
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}

protocol CategoryViewControllerDelegate {
    func sendCategoryBack(category: String)
}

extension AddTransactionViewController: CategoryViewControllerDelegate {
    func sendCategoryBack(category: String) {
        self.transaction.categoryName = category
    }
}


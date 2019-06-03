//
//  ViewController.swift
//  FlipAnimation
//
//  Created by Anan Sadiya on 03/06/2019.
//  Copyright © 2019 Anan Sadiya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var clearBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var selectAllBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var trashBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedItemsCount: Int = 0
    fileprivate var filteredItems = [DisplayItem]()
    fileprivate var isFiltering = false
    let searchController = UISearchController(searchResultsController: nil)
    
    var displayItems: [DisplayItem] = [
        DisplayItem(id: 1, image: "1", title: "Zdravo", isItemSelected: false),
        DisplayItem(id: 2, image: "2", title: "Hola", isItemSelected: false),
        DisplayItem(id: 3, image: "3", title: "Hallo", isItemSelected: false),
        DisplayItem(id: 4, image: "4", title: "Ciao", isItemSelected: false),
        DisplayItem(id: 5, image: "5", title: "Ahoj", isItemSelected: false),
        DisplayItem(id: 6, image: "6",title: "Yah sahs", isItemSelected: false),
        DisplayItem(id: 7, image: "7", title: "Bog", isItemSelected: false),
        DisplayItem(id: 8, image: "8", title: "Hei", isItemSelected: false),
        DisplayItem(id: 9, image: "9", title: "Czesc", isItemSelected: false),
        DisplayItem(id: 10, image: "10", title: "Ní hao", isItemSelected: false),
        DisplayItem(id: 11, image: "11", title: "Shalom", isItemSelected: false),
        DisplayItem(id: 12, image: "12", title: "Marhaba", isItemSelected: false),
        DisplayItem(id: 13, image: "13", title: "Salam", isItemSelected: false),
        DisplayItem(id: 14, image: "14", title: "Hujambo", isItemSelected: false),
        DisplayItem(id: 15, image: "15", title: "Olá", isItemSelected: false),
        DisplayItem(id: 16, image: "16", title: "Hey", isItemSelected: false),
        DisplayItem(id: 17, image: "17", title: "Hello", isItemSelected: false),
        DisplayItem(id: 18, image: "18", title: "Salut", isItemSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setNavigationController() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search items"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func updateUI() {
        titleNavigationItem.title = getTitle()
        trashBarButtonItem.isEnabled = getSelectedItemsCount() > 0
        clearBarButtonItem.isEnabled = getSelectedItemsCount() > 0
        selectAllBarButtonItem.isEnabled = getSelectedItemsCount() != displayItems.count
    }
    
    private func getTitle() -> String{
        if getSelectedItemsCount() == 0 {
            return "Items"
        } else {
            return "Selected items: " + String(getSelectedItemsCount())
        }
    }
    
    private func getSelectedItemsCount() -> Int {
        return displayItems.filter({$0.isItemSelected}).count
    }
    
    @IBAction func deleteBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if isFiltering {
            updateFiltered()
        }
        let indexPaths = generateIndexPathsFromSelectedItems(displayItems: isFiltering ? filteredItems : displayItems)
        deleteSelectedItems(indexPaths: indexPaths)
        updateUI()
    }
    
    @IBAction func selectAllBarButtonItemTapped(_ sender: UIBarButtonItem) {
        flipVisibleCells(from: false)
        updateSelectedItem(to: true)
        updateUI()
    }
    
    @IBAction func clearSelectedItemsTapped(_ sender: UIBarButtonItem) {
        flipVisibleCells(from: true)
        updateSelectedItem(to: false)
        updateUI()
    }
    
    private func generateIndexPathsFromSelectedItems(displayItems: [DisplayItem]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for i in 0 ..< displayItems.count {
            if displayItems[i].isItemSelected {
                let indexPath = IndexPath(row: i, section: 0)
                indexPaths.append(indexPath)
            }
        }
        return indexPaths
    }
    
    private func updateFiltered() {
        for i in 0 ..< filteredItems.count {
            guard let displayItem = displayItems.filter({$0.id == filteredItems[i].id}).first else {
                return
            }
            filteredItems[i].isItemSelected = displayItem.isItemSelected
        }
    }
    
    private func deleteSelectedItems(indexPaths: [IndexPath]) {
        if isFiltering {
            filteredItems.removeAll(where: {$0.isItemSelected})
            displayItems.removeAll(where: {$0.isItemSelected})
        } else {
            displayItems.removeAll(where: {$0.isItemSelected})
        }
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    private func flipVisibleCells(from selected: Bool) {
        var displayItems = self.displayItems
        displayItems = isFiltering ? filteredItems : displayItems
        
        for cell in tableView.visibleCells {
            guard let cell = cell as? ItemCell else {
                return
            }
            
            let displayItem = displayItems.filter({$0.id == cell.displayItem?.id}).first!
            
            if displayItem.isItemSelected == selected {
                cell.flip(displayItem: displayItem)
            }
        }
    }
    
    private func updateSelectedItem(to selected: Bool) {
        if isFiltering {
            for i in 0 ..< filteredItems.count {
                if filteredItems[i].isItemSelected == !selected {
                    filteredItems[i].isItemSelected = !filteredItems[i].isItemSelected
                }
                for y in 0 ..< displayItems.count {
                    if displayItems[y].id == filteredItems[i].id {
                        displayItems[y].isItemSelected = filteredItems[i].isItemSelected
                    }
                }
            }
        } else {
            for i in 0 ..< displayItems.count {
                if displayItems[i].isItemSelected == !selected {
                    displayItems[i].isItemSelected = !displayItems[i].isItemSelected
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredItems.count : displayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemCell {
            let displayItem: DisplayItem
            if isFiltering {
                displayItem = filteredItems[indexPath.row]
            } else {
                displayItem = displayItems[indexPath.row]
            }
            cell.setup(displayItem: displayItem, itemTableViewCellDelegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ViewController: ItemTableViewCellDelegate {
    func changeItemStatus(displayItem: DisplayItem) {
        for i in 0 ..< displayItems.count {
            if displayItems[i].id == displayItem.id {
                displayItems[i].isItemSelected = displayItem.isItemSelected
            }
        }
        updateUI()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            filteredItems = displayItems.filter({ (displayItem) -> Bool in
                return displayItem.title.lowercased().contains(text.lowercased())
            })
            isFiltering = true
        }
        else {
            isFiltering = false
            filteredItems = [DisplayItem]()
        }
        tableView.reloadData()
    }
}

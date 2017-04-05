//
//  ListViewController.swift
//  POC
//
//  Created by Amit Kumar Battan on 25/03/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UISearchBarDelegate, ListingViewModelDelegate, UITableViewDelegate, UITableViewDataSource {

    var viewModel:ListingViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarRightConstraint: NSLayoutConstraint!
    
    var refreshControl:UIRefreshControl!
    
    var errorMessage:String?
    var isPagination = false
    var isError = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ListingViewModel()
        viewModel.delegate = self
        
        resetSearchBar()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //pull to refresh
    func refresh(sender:AnyObject) {
        viewModel.refresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if searchBarTopConstraint.constant > 0 {
           searchBarTopConstraint.constant = self.view.bounds.height/3
        }
    }
    
    //toggle UI
    func resetSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.resignFirstResponder()
        searchBarTopConstraint.constant = self.view.bounds.height/3
        searchBarLeftConstraint.constant = 20
        searchBarRightConstraint.constant = 20
        tableView.isHidden = true
        tableView.alpha = 0.0
    }
    
    //toggle UI
    func setSearchBarForSearch() {
        tableView.contentInset = UIEdgeInsets.zero
        searchBar.searchBarStyle = .default
        searchBarTopConstraint.constant = 0
        searchBarLeftConstraint.constant = 0
        searchBarRightConstraint.constant = 0
        tableView.isHidden = false
        tableView.alpha = 1.0
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //toggle UI
        resetSearchBar()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 2.0) {
            //toggle UI
            self.setSearchBarForSearch()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            searchBar.resignFirstResponder()
            isPagination = true //set true to show loader
            tableView.reloadData()
            //Call for getting items respective to search text
            viewModel.fetchItems(queryString: searchBarText)
        }
    }
    
    //Call when need to update UI when some data to be show or some error message to be show
    func listFetched(isNextPage: Bool, errorMessage: String?) {
        refreshControl.endRefreshing()
        self.errorMessage = errorMessage
        if errorMessage != nil {
            isError = true
        } else {
            isError = false
            isPagination = isNextPage
        }
        tableView.reloadData()

    }

    //Call when no data is available
    func endOfList() {
        isError = false
        isPagination = false
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isPagination == true || errorMessage != nil) ? viewModel.items.count+1 : viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isPagination == true, indexPath.row == viewModel.items.count-3 {
            //Call next page API
            viewModel.fetchNextPage()
        }

        if indexPath.row == viewModel.items.count {
            if isError == true {
                //Show Error
                let cell:MessageCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
                cell.configureCell(message: self.errorMessage ?? "Something went wrong, tab to retry")
                return cell
            } else {
                //Show Loader
                return tableView.dequeueReusableCell(withIdentifier: "LoaderCell", for: indexPath)
            }
        } else {
            //Show Item
            let item = viewModel.items[indexPath.row]
            let cell:ItemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            cell.configureCell(item: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.items.count {
            if isError == true {
                //Retry web service call
                viewModel.retry()
                isError = false
                tableView.reloadRows(at: [indexPath], with: .bottom)
            }
        } else {
            //Go to detail view controller
            let item = viewModel.items[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
                return
            }
            controller.item = item
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

}

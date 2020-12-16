//
//  ImageListViewController.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/11.
//

import UIKit

class PhotoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var footerView = FooterView()
    var viewModel: PhotoListViewModel?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        viewModel?.viewDidLoad()
    }
    
    fileprivate func setUI() {
        viewModel?.delegate = self
        
        self.definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.autocapitalizationType = .none
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.className)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        indicator.startAnimating()
        footerView.frame.size.height = 80
    }
    
}


// MARK: - Output

extension PhotoListViewController: PhotoListViewModelDelegate {
    func didLoadPhotos() {
        setTableViewLoading(false)
        tableView.reloadData()
    }
    
    func didUpdatePhotos() {
        tableView.reloadData()
        footerView.isLoading = false
        tableView.tableFooterView = nil
    }
    
    func scrollToItem(_ indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
    }
    
    func error() {
        DispatchQueue.main.async {
            self.setTableViewLoading(false)
            self.footerView.isLoading = false
            self.tableView.tableFooterView = nil
        }
    }
}

// MARK: - SearchBar

extension PhotoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.dismiss(animated: true, completion: nil)
        setTableViewLoading(true)
        viewModel?.search(searchBar.text)
    }
    
    fileprivate func setTableViewLoading(_ isLoading: Bool) {
        if isLoading {
            indicator.startAnimating()
            tableView.isHidden = true
        }
        else {
            indicator.stopAnimating()
            tableView.isHidden = false
        }
    }
}

// MARK: - TableView

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.className, for: indexPath)
        guard let viewModel = viewModel else { return cell }
        if let photoCell = cell as? PhotoCell {
            photoCell.fill(viewModel.photos[indexPath.item].image)
            return photoCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectCell(indexPath)
    }
}

// MARK: - ScrollDelegate

extension PhotoListViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !(viewModel?.isFetching ?? true) else { return }
        if scrollView.contentOffset.y > (tableView.contentSize.height - scrollView.frame.height - 80) {
            footerView.isLoading = true
            tableView.tableFooterView = footerView
            viewModel?.updateList()
        }
    }
    
}

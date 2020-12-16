//
//  PhotoListViewModel.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/14.
//

import Foundation

protocol PhotoListViewModelDelegate: class {
    func didLoadPhotos()
    func didUpdatePhotos()
    func scrollToItem(_ indexPath: IndexPath)
    func error()
}

class PhotoListViewModel: CommonViewModel {
    fileprivate var currentPage = 1
    weak var delegate: PhotoListViewModelDelegate?
    
    var isFetching: Bool = false
    var photos: [Photo] = []
    var searchTerm: String = ""
    var searchTotalPage: Int = 0
    
    lazy fileprivate var searchResponse: (Result<PhotoListSearchResponse?, Error>) -> Void = { [weak self] result in
        switch result {
        case .success(let item):
            guard let item = item, item.total != 0 else {
                self?.alert(.emptyResult)
                break
            }
            self?.searchTotalPage = item.totalPage
            self?.downloadImage(item.results, completion: { result in
                DispatchQueue.main.async {
                    self?.setPhotos(result, isUpdate: self?.isFetching ?? false )
                }
            })
        case .failure(let error):
            self?.isFetching = false
            self?.delegate?.error()
            self?.alert(.networkError)
        }
    }
    
    lazy fileprivate var listResponse: (Result<[PhotoListResponse]?, Error>) -> Void = { [weak self] result in
        switch result {
        case .success(let items):
            guard let items = items, items.count != 0 else {
                self?.alert(.emptyResult)
                break
            }
            self?.downloadImage(items, completion: { result in
                DispatchQueue.main.async {
                    self?.setPhotos(result, isUpdate: self?.isFetching ?? false)
                }
            })
        case .failure(let error):
            self?.isFetching = false
            self?.delegate?.error()
            self?.alert(.networkError)
        }
    }
    
    fileprivate func setPhotos(_ items: [Photo], isUpdate: Bool) {
        if isUpdate {
            self.isFetching = false
            photos.append(contentsOf: items)
            delegate?.didUpdatePhotos()
        }
        else {
            photos = items
            delegate?.didLoadPhotos()
        }
        
    }
    
    
    // MARK: - Input
    
    func selectCell(_ indexPath: IndexPath) {
        let detailViewModel = PhotoDetailViewModel(photos: photos, selected: indexPath, searchTerm: searchTerm.isEmpty ? nil : searchTerm, currentPage: currentPage, searchTotalPage: searchTotalPage, service: service, coordinator: coordinator)
        detailViewModel.didDisappear = didDisappearDetailViewController
        coordinator.transition(to: Scene.photoDetail(detailViewModel), style: .push, animated: true, completion: nil)
    }
    
    
    func updateList() {
        isFetching = true
        if !searchTerm.isEmpty {
            updateSearch()
            return
        }
        currentPage += 1
        let request = PhotoListRequest(page: currentPage, perPage: 30)
        service.fetch(EndPoint.photoList, parameter: request, header: nil, completion: listResponse)
    }
    
    
    func search(_ text: String?) {
        guard let text = text, !text.isEmpty else { return }
        searchTerm = text
        currentPage = 1
        let request = PhotoListSearchQueryRequest(query: text, page: currentPage, perPage: 30)
        
        service.fetch(EndPoint.searchPhoto, parameter: request, header: nil, completion: searchResponse)
    }
    
    fileprivate func updateSearch() {
        guard currentPage < searchTotalPage else {
            delegate?.didUpdatePhotos()
            return
        }
        currentPage += 1
        let request = PhotoListSearchQueryRequest(query: searchTerm, page: currentPage, perPage: 30)
        service.fetch(EndPoint.searchPhoto, parameter: request, header: nil, completion: searchResponse)
    }
    
}

// MARK: - LifeCycle

extension PhotoListViewModel: LifeCycleViewModelProtocol {
    func viewDidLoad() {
        let request = PhotoListRequest(page: currentPage, perPage: 30)
        service.fetch(EndPoint.photoList, parameter: request, header: nil, completion: listResponse)
    }
    
    func didDisappearDetailViewController(indexPath: IndexPath, photos: [Photo]) {
        setPhotos(photos, isUpdate: false)
        delegate?.scrollToItem(indexPath)
    }
}


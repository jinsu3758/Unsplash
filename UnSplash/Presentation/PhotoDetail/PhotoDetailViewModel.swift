//
//  PhotoListViewModel.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/16.
//

import Foundation

protocol PhotoDetailViewModelDelegate: class {
    func didUpdatePhotos()
    func error()
}

class PhotoDetailViewModel: CommonViewModel {
    
    weak var delegate: PhotoDetailViewModelDelegate?
    var didDisappear: ((IndexPath, [Photo]) -> Void)?
    
    var isFetching: Bool = false
    var photos: [Photo] = []
    var searchTerm: String?
    var selectedIndexPath: IndexPath?
    var currentPage: Int = 0
    var currentIndexPath: IndexPath = IndexPath.init()
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
                    self?.setPhotos(result)
                }
            })
        case .failure:
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
                    self?.setPhotos(result)
                }
            })
        case .failure(let error):
            self?.isFetching = false
            self?.delegate?.error()
            self?.alert(.networkError)
        }
    }
    
    init(photos: [Photo], selected indexPath: IndexPath, searchTerm: String?, currentPage: Int, searchTotalPage: Int, service: ApiServiceType, coordinator: CoordinatorType) {
        self.photos = photos
        self.selectedIndexPath = indexPath
        self.currentPage = currentPage
        self.searchTerm = searchTerm
        
        super.init(service: service, coordinator: coordinator)
    }
    
    fileprivate func setPhotos(_ items: [Photo]) {
        photos.append(contentsOf: items)
        isFetching = false
        delegate?.didUpdatePhotos()
        
    }
    
    // MARK: - Input
    
    func updateList() {
        isFetching = true
        if let searchTerm = searchTerm {
            updateSearch(searchTerm)
            return
        }
        currentPage += 1
        let request = PhotoListRequest(page: currentPage, perPage: 30)
        service.fetch(EndPoint.photoList, parameter: request, header: nil, completion: listResponse)
    }
    
    fileprivate func updateSearch(_ term: String) {
        guard currentPage < searchTotalPage else {
            delegate?.didUpdatePhotos()
            return
        }
        currentPage += 1
        let request = PhotoListSearchQueryRequest(query: term, page: currentPage, perPage: 30)
        service.fetch(EndPoint.searchPhoto, parameter: request, header: nil, completion: searchResponse)
    }
}

// MARK: - LifeCycle

extension PhotoDetailViewModel: LifeCycleViewModelProtocol {
    func viewWillDisappear(_ animated: Bool) {
        didDisappear?(currentIndexPath, photos)
        coordinator.popWithBackButton()
    }
}



//
//  PhotoDetailViewController.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/16.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var viewModel: PhotoDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        viewModel?.viewWillDisappear(true)
    }
    
    fileprivate func setUI() {
        viewModel?.delegate = self
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }

}

// MARK: - Output

extension PhotoDetailViewController: PhotoDetailViewModelDelegate {
    func didUpdatePhotos() {
        indicator.stopAnimating()
        photoCollectionView.reloadData()
    }
    
    func error() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
    }
    
}

// MARK: - CollectionView

extension PhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCell.className, for: indexPath)
        guard let viewModel = viewModel else { return cell }
        if let photoCell = cell as? PhotoDetailCell {
            photoCell.fill(viewModel.photos[indexPath.item].image)
            return photoCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel?.currentIndexPath = indexPath
        guard let indexPath = viewModel?.selectedIndexPath else { return }
        viewModel?.currentIndexPath = indexPath
        photoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        viewModel?.selectedIndexPath = nil
    }
    
}

// MARK: - ScrollDelegate

extension PhotoDetailViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !(viewModel?.isFetching ?? true) else { return }
        if scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.width) {
            indicator.startAnimating()
            viewModel?.updateList()
        }
    }
}


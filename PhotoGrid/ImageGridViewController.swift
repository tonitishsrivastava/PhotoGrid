//
//  ViewController.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import UIKit

class ImageGridViewController: UIViewController {

    @IBOutlet weak var imageGridCollectionView: UICollectionView!
    
    private var images:[ImageModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.imageGridCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fetchImageList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func fetchImageList() {
        ImageGridManager.shared.loadImagesIfNeeded { images, error in
            if let images = images {
                self.images = images
            } else if let error = error {
                DispatchQueue.main.async {
                    AlertView().showErrorAlert(controller: self, message: error.description)
                }
            }
        }
    }
    
    private func fetchImageAtIndex(indexPath: IndexPath, completion: @escaping (UIImage?, HttpError?)-> Void) {
        DispatchQueue.global().async {
            ImageGridManager.shared.getImage(at: indexPath.row) { result in
                switch result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}

extension ImageGridViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = imageGridCollectionView.dequeueReusableCell(withReuseIdentifier: ImageGridCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageGridCollectionViewCell {
            self.setImageOnCell(cell: cell, indexPath: indexPath)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width - 30) / 3) // 15 because of paddings
        return CGSize(width: width, height: width)
    }
    
    private func setImageOnCell(cell: ImageGridCollectionViewCell, indexPath: IndexPath) {
        self.fetchImageAtIndex(indexPath: indexPath) { imageData, error in
            DispatchQueue.main.async {
                if let imageData = imageData {
                    cell.imageView.image = imageData
                }
            }
        }
    }
    
}


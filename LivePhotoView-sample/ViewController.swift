//
//  ViewController.swift
//  LivePhotoView-sample
//
//  Created by Shota on 2018/09/12.
//  Copyright © 2018年 Shota. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    private var assets = [PHAsset]()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let margint = 1 / UIScreen.main.scale
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width / 4 - margint * 3, height: UIScreen.main.bounds.width / 4)
        layout.minimumLineSpacing = margint
        layout.minimumInteritemSpacing = margint
        layout.sectionInset = UIEdgeInsets(top: margint, left: 0, bottom: margint, right: 0)
        return layout
    }()
    
    
    override func loadView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization() {
            [unowned self](status: PHAuthorizationStatus) in
            switch status {
            case .authorized:
                self.fetchAssets()
            default:
                fatalError()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchAssets() {
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects() {[unowned self](asset, index, block) in
            if asset.mediaSubtypes == .photoLive {
                self.assets.append(asset)
            }
        }
        DispatchQueue.main.async {
            (self.view as! UICollectionView).reloadData()
        }
    }
}

// MARK: UICollectionViewDataSource extension
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        cell.asset = assets[indexPath.row]
        return cell
    }
}

// MARK: UICollectionViewDelegate extension
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let livePhotoVC = LivePhotoViewController()
        PHImageManager.default().requestLivePhoto(
            for: assets[indexPath.row], targetSize: UIScreen.main.bounds.size,
            contentMode: .aspectFit, options: nil) {(livePhoto, info) in
                livePhotoVC.livePhoto = livePhoto
        }
        navigationController?.pushViewController(livePhotoVC, animated: true)
    }
}

// MARK: PhotoCollectionViewCell
fileprivate class PhotoCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    var asset: PHAsset? {
        didSet {
            guard let asset = asset else {
                imageView.image = nil
                return
            }
            PHImageManager.default().requestImage(
                for: asset, targetSize: frame.size,
                contentMode: .aspectFill, options: nil) { [unowned self](image, info) in
                    self.imageView.image = image
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(origin: .zero, size: frame.size)
    }
}

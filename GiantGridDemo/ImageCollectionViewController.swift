//
//  ImageCollectionViewController.swift
//  GiantGridDemo
//
//  Created by LAPSHOP.IN on 23/01/20.
//  Copyright © 2020 BOPPO TECHNOLOGIES. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageSliceArray: [UIImage] = []
    let width = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let layout = ColumnFlowLayout(cellsPerRow: 3, minimumInteritemSpacing: 2, minimumLineSpacing: 2, sectionInset: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
//        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: view.frame.width/3.55, height: view.frame.width/3.8)
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 0
        
        imageCollectionView.collectionViewLayout = layout
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
    }

}

extension ImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSliceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageViewSlice.image = imageSliceArray[indexPath.row]
        cell.imageCount.setTitle("\(imageSliceArray.count - indexPath.row)", for: .normal)
        return cell
    }
    
    
}

extension ImageCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postImageToInstagram(image: imageSliceArray[indexPath.row])
    }
    
    func postImageToInstagram(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error)
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let lastAsset = fetchResult.firstObject as? PHAsset {
            
            let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
}



//extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width/1.5, height: 120)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}

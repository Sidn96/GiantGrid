//
//  ViewController.swift
//  GiantGridDemo
//
//  Created by LAPSHOP.IN on 22/01/20.
//  Copyright © 2020 BOPPO TECHNOLOGIES. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var images: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))

    }
    
    @objc
    func addImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        dismiss(animated: true) { [weak self] in
            self?.images = self?.imageView.image?.cropInMatrix(matrix: (4, 4)) ?? []
            print("imagesCount \(self?.images.count ?? 0)")
        }
        imageView.image = image
    }
    
    @IBAction func processImage(_ sender: Any) {
        
        let imageCollectionViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "imageCollectionViewController") as! ImageCollectionViewController
        imageCollectionViewController.imageSliceArray = self.imageView.image?.cropInMatrix(matrix: (4, 4)) ?? []
        print("imagesCountSend \(self.images.count)")

        self.navigationController?.pushViewController(imageCollectionViewController, animated: true)
        
    }
    
    
}


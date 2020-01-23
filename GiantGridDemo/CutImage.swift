//
//  CutImage.swift
//  GiantGridDemo
//
//  Created by LAPSHOP.IN on 22/01/20.
//  Copyright © 2020 BOPPO TECHNOLOGIES. All rights reserved.
//

import Foundation
import UIKit

protocol ImageCut {
    func cropSquare() -> UIImage
    func cropInMatrix(matrix: (rows: Int, cols: Int)) -> [UIImage]
}

extension UIImage: ImageCut{
    func cropSquare() -> UIImage {
        return SliceImage.cropToSquare(image: self)
    }
    
    func cropInMatrix(matrix: (rows: Int, cols: Int)) -> [UIImage] {
        return SliceImage.cropImage(image: self, toMatrix: matrix)
    }
    
    
}

class SliceImage: NSObject {
    
    // Crops to square based on the shortest length
    static func cropToSquare(image originalImage: UIImage) -> UIImage {
        let imageSize: CGSize = originalImage.size
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if imageSize.width > imageSize.height {
            posX = ((imageSize.width - imageSize.height) / 2)
            posY = 0
            width = imageSize.height
            height = imageSize.height
        } else {
            posX = 0
            posY = ((imageSize.height - imageSize.width) / 2)
            width = imageSize.width
            height = imageSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: width, height: height)
        return self.crop(image: originalImage, cropRect: rect)
    }
    
    // A matrix cropper
    static func cropImage(image originalImage: UIImage, toMatrix matrix: (rows: Int, cols: Int)) -> [UIImage]{
        //TODO:
        /*        guard originalSquareImage.size.width % matrix.rows == 0 &&
        originalSquareImage.size.height % matrix.cols == 0 else {
        assertionFailure("For now, the square image needs to divide exactly by the matrix provided, at least until this package is further developed to handle odd image sized edge cases.")
        }
        */
        var images = [UIImage]()
        let quadrantSize: CGSize = CGSize(width: CGFloat(Int(originalImage.size.width) / matrix.rows), height: CGFloat(Int(originalImage.size.height) / matrix.cols))
        
//        for rowPosition in 0 ..< matrix.rows {
//            for colPosition in 0 ..< matrix.cols {
//                let x: CGFloat = CGFloat(rowPosition * Int(quadrantSize.width))
//                let y: CGFloat = CGFloat(colPosition * Int(quadrantSize.height))
//                let rect = CGRect(x: x, y: y, width: quadrantSize.width, height: quadrantSize.height)
//                images.append(self.crop(image: originalImage, cropRect: rect))
//            }
//        }
        
        for colPosition in 0 ..< matrix.cols {
            for rowPosition in 0 ..< matrix.rows {
                let x: CGFloat = CGFloat(rowPosition * Int(quadrantSize.width))
                let y: CGFloat = CGFloat(colPosition * Int(quadrantSize.height))
                let rect = CGRect(x: x, y: y, width: quadrantSize.width, height: quadrantSize.height)
                images.append(self.crop(image: originalImage, cropRect: rect))
            }
        }
        
        return images
    }
    
    // Crops image to specified rect
    static func crop(image originalImage: UIImage, cropRect originalCropRect: CGRect) -> UIImage{
        let contextImage: UIImage = UIImage(cgImage: originalImage.cgImage!)
        let imageRef: CGImage = (contextImage.cgImage)!.cropping(to: originalCropRect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        return image
    }
}

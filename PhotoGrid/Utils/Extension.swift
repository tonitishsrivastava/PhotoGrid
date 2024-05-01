//
//  UIImageExtension.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import UIKit


extension UIImage {
    static let placeholder = UIImage(named: AppConstant.PLACEHOLDER_IMAGE)
}


protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView {}

//
//  AlertView.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import Foundation
import UIKit


struct AlertView {
    
    func showErrorAlert(controller: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AppConstant.OK, style: .cancel)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
}

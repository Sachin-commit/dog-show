//
//  UITextField+Extensions.swift
//  DogShow
//
//  Created by Sachin Singla on 18/07/24.
//

import Foundation
import UIKit

extension UITextField {
    
    func addPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
}

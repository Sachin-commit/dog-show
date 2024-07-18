//
//  LoadingImageView.swift
//  DogShow
//
//  Created by Sachin Singla on 18/07/24.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class LoadingImageView: UIImageView {
    var imageURL: URL?
    let activityIndicator = UIActivityIndicatorView()
    
    func loadImageWithUrl(_ url: URL) {
        
        // MARK: - Showing Loader before image loads up
        
        DispatchQueue.main.async(execute: { [weak self] in
            
            self?.activityIndicator.color = .systemBlue
            self?.activityIndicator.style = .large
            self?.addSubview(self?.activityIndicator ?? UIActivityIndicatorView())
            self?.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self?.activityIndicator.centerXAnchor.constraint(equalTo: self?.centerXAnchor ?? NSLayoutXAxisAnchor()).isActive = true
            self?.activityIndicator.centerYAnchor.constraint(equalTo: self?.centerYAnchor ?? NSLayoutYAxisAnchor()).isActive = true
            
            self?.imageURL = url
            
            self?.image = nil
            self?.activityIndicator.startAnimating()
            
            // MARK: - Checking if the image exists in the cache or not. If it exists then setting it up on the image view.
            
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                
                self?.image = imageFromCache
                self?.activityIndicator.stopAnimating()
                return
            }
        })
        
        // MARK: - If image doesn't exists in cache memory, fetching the image from the url and setting it up on the image view.
        
        URLSession.shared.dataTask(with: url, completionHandler: {[weak self] (data, response, error) in
            
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self?.activityIndicator.stopAnimating()
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    
                    if self?.imageURL == url {
                        self?.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self?.activityIndicator.stopAnimating()
            })
        }).resume()
    }
}

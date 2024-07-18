//
//  PetCell.swift
//  DogShow
//
//  Created by Sachin Singla on 18/07/24.
//

import Foundation
import UIKit
final class PetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let petCellID = "PetCell"
    
    private let imageView: LoadingImageView = {
        let imageView = LoadingImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemBrown.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayouts()
    }
    
    // MARK: - Setup UI
    
    private func setupViewLayouts() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.size.height)
        ])
    }
    
    // MARK: - Setting image on image view.
    
    func configure(with url: String) {
        guard let imageURL = URL(string: url) else { return }
        imageView.loadImageWithUrl(imageURL)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

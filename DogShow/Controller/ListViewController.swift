//
//  ListViewController.swift
//  DogShow
//
//  Created by Sachin Singla on 18/07/24.
//

import UIKit
import Foundation

class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var dogImages: [String]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PetCell.self, forCellWithReuseIdentifier: PetCell.petCellID)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    
    init(dogImages: [String]) {
        self.dogImages = dogImages
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        setupViewLayouts()
        setupDelegates()
    }
    
    
    private func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    private func setupViewLayouts() {
        self.title = "Super Dogs"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 350),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Reloading Data on collection view.
    func reloadViewData( _ images: [String]) {
        self.dogImages = images
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Collection View Cell Configuration

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.height / 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetCell.petCellID, for: indexPath) as! PetCell
        let url = dogImages[indexPath.item]
        cell.configure(with: url)
        return cell
    }
}

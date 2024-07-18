//
//  ViewController.swift
//  DogShow
//
//  Created by Sachin Singla on 18/07/24.
//

import UIKit
import MyDogImageLibrarySPM

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let dogImageLibrary = DogImageLibrary()
    
    private var currentImage: String?
    
    private var initialImage: String?
    
    private lazy var imageView: LoadingImageView = {
        let imageView = LoadingImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("Previous", for: .normal)
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.isEnabled = false // Initially disabled for the first image.
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        return button
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please enter a number (1-10)"
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addPadding()
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 4
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - View Lifecycle
    
    deinit {
        removeKeyboardObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchInitialDogImages()
        setupKeyboardObservers()
        setupTapGestureToDismissKeyboard()
    }
    
    // MARK: - Setup UI
    
    private func setupViews() {
        self.title = "Dog Show"
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(inputTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            previousButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previousButton.widthAnchor.constraint(equalToConstant: 90),
            previousButton.heightAnchor.constraint(equalToConstant: 45),
            
            nextButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 90),
            nextButton.heightAnchor.constraint(equalToConstant: 45),
            
            inputTextField.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 20),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inputTextField.heightAnchor.constraint(equalToConstant: 44),
            
            submitButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Fetch Dog Images
    
    // Fetching the image to show when the app first loads up.
    private func fetchInitialDogImages() {
        dogImageLibrary.getImage {[weak self] initialImage in
            guard let initialImage = initialImage else { return }
            self?.currentImage = initialImage
            self?.initialImage = initialImage
            self?.updateImageView(with: initialImage)
        }
    }
    
    // Fetching the image to show when next button tapped and enabling the previous button.
    @objc private func nextButtonTapped() {
        dogImageLibrary.getNextImage {[weak self] image in
            if let nextImage = image {
                self?.currentImage = nextImage
                self?.updateImageView(with: nextImage)
                self?.previousButton.isEnabled = true
            }
        }
    }
    
    // Getting the image to show when previous button tapped and disabling the previous button if it's the first image.
    @objc private func previousButtonTapped() {
        dogImageLibrary.getPreviousImage {[weak self] image in
            if let previousImage = image {
                self?.currentImage = previousImage
                self?.updateImageView(with: previousImage)
            }
        }
        if initialImage == currentImage {
            self.previousButton.isEnabled = false
        }
    }
    
    
    // Getting an input from the user between 1-10, and pushing the list view with the results.
    @objc private func submitButtonTapped(_ sender: UIButton) {
        guard let numberString = inputTextField.text, let number = Int(numberString), number > 0 && number <= 10 else {
            showAlert(title: "Invalid Input", message: "Please enter a number between 1-10.")
            return
        }
        
        dogImageLibrary.getImages(refreshList: true, number: number) {[weak self] images in
            DispatchQueue.main.async {[weak self] in
                self?.showListView(dogImages: images)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default))
        present(alert, animated: true)
    }
    
    // Setting the image on the loading image view with the help of helper function.
    private func updateImageView(with url: String) {
        guard let imageURL = URL(string: url) else { return }
        imageView.loadImageWithUrl(imageURL)
    }
    
    // Pushing list view controller
    private func showListView(dogImages: [String]) {
        let listViewController = ListViewController(dogImages: dogImages)
        listViewController.reloadViewData(dogImages)
        navigationController?.pushViewController(listViewController, animated: true)
    }
    
    
    
}

// MARK: - Handling Keyboard

extension HomeViewController {
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight / 2
            }
        }
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Dimissing Keyboard on outside tap
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

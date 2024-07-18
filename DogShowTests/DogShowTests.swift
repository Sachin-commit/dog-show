//
//  DogShowTests.swift
//  DogShowTests
//
//  Created by Sachin Singla on 18/07/24.
//

import XCTest
@testable import DogShow

final class DogShowTests: XCTestCase {
    
    var mockDogImageLibrary: MockDogImageLibrary!
    
    override func setUp() {
        super.setUp()
        mockDogImageLibrary = MockDogImageLibrary()
    }
    
    override func tearDown() {
        mockDogImageLibrary = nil
        super.tearDown()
    }
    
    func testGetInitialImage() {
        
        let expectedInitialImage = "https://images.dog.ceo/breeds/terrier-silky/n02097658_3484.jpg"
        mockDogImageLibrary.mockImage = expectedInitialImage
        
        
        mockDogImageLibrary.getImage { image in
            
            XCTAssertEqual(image, expectedInitialImage)
        }
    }
    
    func testGetNextImage() {
        
        let expectedNextImage = "https://images.dog.ceo/breeds/pariah-indian/The_Indian_Pariah_Dog.jpg"
        mockDogImageLibrary.mockNextImage = expectedNextImage
        
        
        mockDogImageLibrary.getNextImage { image in
            
            XCTAssertEqual(image, expectedNextImage)
        }
    }
    
    func testGetPreviousImage() {
        
        let expectedPreviousImage = "https://images.dog.ceo/breeds/terrier-silky/n02097658_3484.jpg"
        mockDogImageLibrary.mockPreviousImage = expectedPreviousImage
        
        
        mockDogImageLibrary.getPreviousImage { image in
            
            XCTAssertEqual(image, expectedPreviousImage)
        }
    }
    
    func testGetImages() {
        
        let expectedImages = [
            "https://images.dog.ceo/breeds/terrier-silky/n02097658_3484.jpg",
            "https://images.dog.ceo/breeds/pariah-indian/The_Indian_Pariah_Dog.jpg"
        ]
        mockDogImageLibrary.mockImages = expectedImages
        
        
        mockDogImageLibrary.getImages(refreshList: true, number: 2) { images in
            
            XCTAssertEqual(images, expectedImages)
        }
    }
}

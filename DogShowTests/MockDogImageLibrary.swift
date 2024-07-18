//
//  MockDogImageLibrary.swift
//  DogShowTests
//
//  Created by Sachin Singla on 18/07/24.
//

import Foundation

final class MockDogImageLibrary {
    
    var mockImage: String?
    var mockNextImage: String?
    var mockPreviousImage: String?
    var mockImages: [String]?
    
    
    func getImage(completion: @escaping (String?) -> Void) {
        completion(mockImage)
    }
    
    func getNextImage(completion: @escaping (String?) -> Void) {
        completion(mockNextImage)
    }
    
    func getPreviousImage(completion: @escaping (String?) -> Void) {
        completion(mockPreviousImage)
    }
    
    func getImages(refreshList: Bool, number: Int, completion: @escaping ([String]) -> Void) {
        completion(mockImages ?? [])
    }
}

//
//  MockProfileRepository.swift
//  MazadyTests
//
//  Created by eslam mohamed on 29/04/2025.
//

import XCTest
@testable import Mazady

class MockProfileRepository: ProfileRepositoryProtocol {
    var fetchUserInfoResult: Result<UserInformationResponse, HTTPNetworkError> = .failure(.unwrappingError)
    var fetchProductsResult: Result<[Product], HTTPNetworkError> = .failure(.unwrappingError)
    var fetchTagsResult: Result<[Tag], HTTPNetworkError> = .failure(.unwrappingError)
    var fetchAdvertisementsResult: Result<[Advertisement], HTTPNetworkError> = .failure(.unwrappingError)
    
    func fetchUserInfo() async throws -> UserInformationResponse {
        try fetchUserInfoResult.get()
    }
    
    func fetchProducts() async throws -> [Product] {
        try fetchProductsResult.get()
    }
    
    func fetchTags() async throws -> [Tag] {
        try fetchTagsResult.get()
    }
    
    func fetchAdvertisements() async throws -> [Advertisement] {
        try fetchAdvertisementsResult.get()
    }
}

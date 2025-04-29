//
//  MockProfileUseCase.swift
//  MazadyTests
//
//  Created by eslam mohamed on 29/04/2025.
//

import XCTest
@testable import Mazady

class ProfileUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    var useCase: ProfileUseCase!
    var mockRepository: MockProfileRepository!
    
    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        mockRepository = MockProfileRepository()
        useCase = ProfileUseCase(repo: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testFetchUserInfoSuccess() async {
        // Given
        let expectedUserInfo = UserInformationResponse(
            id: 1,
            name: "Test User",
            image: "test.jpg",
            userName: "testuser",
            followingCount: 100,
            followersCount: 200,
            countryName: "Test Country",
            cityName: "Test City"
        )
        mockRepository.fetchUserInfoResult = .success(expectedUserInfo)
        
        // When
        do {
            let userInfo = try await useCase.fetchUserInfo()
            
            // Then
            XCTAssertEqual(userInfo.id, expectedUserInfo.id)
            XCTAssertEqual(userInfo.name, expectedUserInfo.name)
            XCTAssertEqual(userInfo.userName, expectedUserInfo.userName)
        } catch {
            XCTFail("Expected successful user info fetch, but got error: \(error)")
        }
    }
    
    func testFetchUserInfoFailure() async {
        // Given
        mockRepository.fetchUserInfoResult = .failure(.noInternetConnection)
        
        // When/Then
        do {
            _ = try await useCase.fetchUserInfo()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is HTTPNetworkError)
        }
    }
    
    func testFetchProductsSuccess() async {
        // Given
        let expectedProducts = [
            Product(id: 1, name: "Product 1", image: "img1.jpg", price: 10.0, currency: "EGP", offer: nil, endDate: nil),
            Product(id: 2, name: "Product 2", image: "img2.jpg", price: 20.0, currency: "EGP", offer: 5.0, endDate: 123456789)
        ]
        mockRepository.fetchProductsResult = .success(expectedProducts)
        
        // When
        do {
            let products = try await useCase.fetchProducts()
            
            // Then
            XCTAssertEqual(products.count, 2)
            XCTAssertEqual(products[0].name, "Product 1")
            XCTAssertEqual(products[1].offer, 5.0)
        } catch {
            XCTFail("Expected successful products fetch, but got error: \(error)")
        }
    }
    
    func testFetchProductsFailure() async {
        // Given
        mockRepository.fetchProductsResult = .failure(.decodingFailed)
        
        // When/Then
        do {
            _ = try await useCase.fetchProducts()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is HTTPNetworkError)
        }
    }
    
    func testFetchTagsSuccess() async {
        // Given
        let expectedTags = [
            Tag(id: 1, name: "Tag 1"),
            Tag(id: 2, name: "Tag 2")
        ]
        mockRepository.fetchTagsResult = .success(expectedTags)
        
        // When
        do {
            let tags = try await useCase.fetchTags()
            
            // Then
            XCTAssertEqual(tags.count, 2)
            XCTAssertEqual(tags[0].name, "Tag 1")
            XCTAssertEqual(tags[1].name, "Tag 2")
        } catch {
            XCTFail("Expected successful tags fetch, but got error: \(error)")
        }
    }
    
    func testFetchTagsFailure() async {
        // Given
        mockRepository.fetchTagsResult = .failure(.serverSideError)
        
        // When/Then
        do {
            _ = try await useCase.fetchTags()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is HTTPNetworkError)
        }
    }
    
    func testFetchAdvertisementsSuccess() async {
        // Given
        let expectedAds = [
            Advertisement(id: 1, image: "ad1.jpg"),
            Advertisement(id: 2, image: "ad2.jpg")
        ]
        mockRepository.fetchAdvertisementsResult = .success(expectedAds)
        
        // When
        do {
            let ads = try await useCase.fetchAdvertisements()
            
            // Then
            XCTAssertEqual(ads.count, 2)
            XCTAssertEqual(ads[0].image, "ad1.jpg")
            XCTAssertEqual(ads[1].image, "ad2.jpg")
        } catch {
            XCTFail("Expected successful ads fetch, but got error: \(error)")
        }
    }
    
    func testFetchAdvertisementsFailure() async {
        // Given
        mockRepository.fetchAdvertisementsResult = .failure(.invalidResponse)
        
        // When/Then
        do {
            _ = try await useCase.fetchAdvertisements()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is HTTPNetworkError)
        }
    }
}

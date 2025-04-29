//
//  ProfileViewModelTests.swift
//  MazadyTests
//
//  Created by eslam mohamed on 29/04/2025.
//

import XCTest
import Combine
@testable import Mazady

class ProfileViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var viewModel: ProfileViewModel!
    var mockUseCase: MockProfileUseCase!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        mockUseCase = MockProfileUseCase()
        viewModel = ProfileViewModel(useCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertNil(viewModel.userInfo)
        XCTAssertTrue(viewModel.products.isEmpty)
        XCTAssertTrue(viewModel.offeredProducts.isEmpty)
        XCTAssertTrue(viewModel.notOfferedProducts.isEmpty)
        XCTAssertTrue(viewModel.tags.isEmpty)
        XCTAssertTrue(viewModel.advertisements.isEmpty)
        
        // Test computed properties with nil userInfo
        XCTAssertEqual(viewModel.userInfoName, "NA")
        XCTAssertEqual(viewModel.userInfoUserName, "NA")
        XCTAssertEqual(viewModel.userInfoNameCity, "NA")
        XCTAssertEqual(viewModel.userInfoFollowers, "0")
        XCTAssertEqual(viewModel.userInfoFolloweing, "0")
        XCTAssertEqual(viewModel.userInfoImageUrl, "")
    }
    
    // MARK: - View Lifecycle Tests
    
    func testHandleViewDidLoad() {
        // Given
        let expectation = XCTestExpectation(description: "All data loaded")
        let expectedUserInfo = UserInformationResponse(
            id: 1, name: "Test", image: "test.jpg", userName: "test",
            followingCount: 10, followersCount: 20,
            countryName: "Country", cityName: "City"
        )
        
        mockUseCase.fetchUserInfoResult = .success(expectedUserInfo)
        mockUseCase.fetchProductsResult = .success([
            Product(id: 1, name: "P1", image: "p1.jpg", price: 10, currency: "EGP", offer: nil, endDate: nil),
            Product(id: 2, name: "P2", image: "p2.jpg", price: 20, currency: "EGP", offer: 5, endDate: nil)
        ])
        mockUseCase.fetchTagsResult = .success([Tag(id: 1, name: "Tag1")])
        mockUseCase.fetchAdvertisementsResult = .success([Advertisement(id: 1, image: "ad1.jpg")])
        
        // When
        viewModel.handleViewDidLoad()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.userInfoName, "Test")
            XCTAssertEqual(self.viewModel.userInfoFollowers, "20")
            XCTAssertEqual(self.viewModel.products.count, 2)
            XCTAssertEqual(self.viewModel.offeredProducts.count, 1)
            XCTAssertEqual(self.viewModel.notOfferedProducts.count, 1)
            XCTAssertEqual(self.viewModel.tags.count, 1)
            XCTAssertEqual(self.viewModel.advertisements.count, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Individual Fetch Tests
    
    func testFetchUserInfoSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "User info fetched")
        let expectedUserInfo = UserInformationResponse(
            id: 1, name: "John", image: "john.jpg", userName: "john",
            followingCount: 50, followersCount: 100,
            countryName: "USA", cityName: "NY"
        )
        mockUseCase.fetchUserInfoResult = .success(expectedUserInfo)
        
        // When
        Task {
            await viewModel.fetchUserInfo()
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.userInfoName, "John")
        XCTAssertEqual(viewModel.userInfoFollowers, "100")
        XCTAssertEqual(viewModel.userInfoFolloweing, "50")
        XCTAssertEqual(viewModel.userInfoNameCity, "NY")
    }
    
    func testFetchUserInfoFailure() {
        // Given
        let expectation = XCTestExpectation(description: "User info fetch failed")
        mockUseCase.fetchUserInfoResult = .failure(.noInternetConnection)
        
        // When
        Task {
            await viewModel.fetchUserInfo()
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(viewModel.userInfo)
        // In a real app, you might want to verify an error state was set
    }
    
    func testFetchProductsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Products fetched")
        let products = [
            Product(id: 1, name: "P1", image: "p1.jpg", price: 10, currency: "EGP", offer: nil, endDate: nil),
            Product(id: 2, name: "P2", image: "p2.jpg", price: 20, currency: "EGP", offer: 5, endDate: nil),
            Product(id: 3, name: "P3", image: "p3.jpg", price: 30, currency: "EGP", offer: 10, endDate: nil)
        ]
        mockUseCase.fetchProductsResult = .success(products)
        
        // When
        Task {
            await viewModel.fetchProducts()
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.products.count, 3)
        XCTAssertEqual(viewModel.offeredProducts.count, 2)
        XCTAssertEqual(viewModel.notOfferedProducts.count, 1)
    }
    
    func testFetchTagsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Tags fetched")
        let tags = [Tag(id: 1, name: "Tag1"), Tag(id: 2, name: "Tag2")]
        mockUseCase.fetchTagsResult = .success(tags)
        
        // When
        Task {
            await viewModel.fetchTags()
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.tags.count, 2)
        XCTAssertEqual(viewModel.tags[0].name, "Tag1")
    }
    
    func testFetchAdvertisementsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Ads fetched")
        let ads = [Advertisement(id: 1, image: "ad1.jpg"), Advertisement(id: 2, image: "ad2.jpg")]
        mockUseCase.fetchAdvertisementsResult = .success(ads)
        
        // When
        Task {
            await viewModel.fetchAdvertisements()
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.advertisements.count, 2)
        XCTAssertEqual(viewModel.advertisements[0].image, "ad1.jpg")
    }
    
    // MARK: - Published Property Tests
    
    func testUserInfoPublisher() {
        // Given
        let expectation = XCTestExpectation(description: "User info published")
        let expectedUserInfo = UserInformationResponse(
            id: 1, name: "Test", image: "test.jpg", userName: "test",
            followingCount: 10, followersCount: 20,
            countryName: "Country", cityName: "City"
        )
        
        var receivedUserInfo: UserInformationResponse?
        
        viewModel.$userInfo
            .dropFirst() // Skip initial nil value
            .sink { userInfo in
                receivedUserInfo = userInfo
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        mockUseCase.fetchUserInfoResult = .success(expectedUserInfo)
        Task {
            await viewModel.fetchUserInfo()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedUserInfo?.name, "Test")
        XCTAssertEqual(receivedUserInfo?.followersCount, 20)
    }
    
    func testProductsPublisher() {
        // Given
        let expectation = XCTestExpectation(description: "Products published")
        let products = [
            Product(id: 1, name: "P1", image: "p1.jpg", price: 10, currency: "EGP", offer: nil, endDate: nil)
        ]
        
        var receivedProducts: [Product] = []
        
        viewModel.$products
            .dropFirst() // Skip initial empty array
            .sink { products in
                receivedProducts = products
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        mockUseCase.fetchProductsResult = .success(products)
        Task {
            await viewModel.fetchProducts()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedProducts.count, 1)
        XCTAssertEqual(receivedProducts[0].name, "P1")
    }
    
    // MARK: - Error Handling Tests
    
    func testPartialDataLoading() {
        // Given
        let expectation = XCTestExpectation(description: "Partial data loaded")
        let expectedUserInfo = UserInformationResponse(
            id: 1, name: "Test", image: "test.jpg", userName: "test",
            followingCount: 10, followersCount: 20,
            countryName: "Country", cityName: "City"
        )
        
        mockUseCase.fetchUserInfoResult = .success(expectedUserInfo)
        mockUseCase.fetchProductsResult = .failure(.noInternetConnection)
        mockUseCase.fetchTagsResult = .success([Tag(id: 1, name: "Tag1")])
        mockUseCase.fetchAdvertisementsResult = .failure(.serverSideError)
        
        // When
        viewModel.handleViewDidLoad()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.userInfoName, "Test")
            XCTAssertEqual(self.viewModel.tags.count, 1)
            XCTAssertTrue(self.viewModel.products.isEmpty)
            XCTAssertTrue(self.viewModel.advertisements.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock UseCase Implementation
class MockProfileUseCase: ProfileUseCaseProtocol {
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

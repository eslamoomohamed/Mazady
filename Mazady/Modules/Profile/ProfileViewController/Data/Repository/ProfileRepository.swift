//
//  ProfileRepository.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

struct ProfileRepository: ProfileRepositoryProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchUserInfo() async throws -> UserInformationResponse {
        let request = GetUserInformationRequest()
        return try await networkManager.executeRequest(request)
    }
    
    func fetchProducts() async throws -> [Product] {
        let request = GetAllProductsRequest()
        return try await networkManager.executeRequest(request)
    }
    
    func fetchTags() async throws -> AllTagsResponse {
        let request = GetAllTagsRequest()
        return try await networkManager.executeRequest(request)
    }
    
    func fetchAdvertisements() async throws -> AdvertisementsResponse {
        let request = GetAllAdvertisementsRequest()
        return try await networkManager.executeRequest(request)
    }
}

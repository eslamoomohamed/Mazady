//
//  ProfileUseCase.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

struct ProfileUseCase: ProfileUseCaseProtocol {

    private let repo: ProfileRepositoryProtocol

    init(repo: ProfileRepositoryProtocol = ProfileRepository()) {
        self.repo = repo
    }

    func fetchUserInfo() async throws -> UserInformationResponse {
        try await repo.fetchUserInfo()
    }

    func fetchProducts() async throws -> [Product] {
        try await repo.fetchProducts()
    }

    func fetchTags() async throws -> AllTagsResponse {
        try await repo.fetchTags()
    }

    func fetchAdvertisements() async throws -> AdvertisementsResponse {
        try await repo.fetchAdvertisements()
    }
}

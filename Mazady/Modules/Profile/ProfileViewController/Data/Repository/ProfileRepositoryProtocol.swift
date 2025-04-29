//
//  ProfileRepositoryProtocol.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

protocol ProfileRepositoryProtocol {
    func fetchUserInfo() async throws -> UserInformationResponse
    func fetchProducts() async throws -> [Product]
    func fetchTags() async throws -> AllTagsResponse
    func fetchAdvertisements() async throws -> AdvertisementsResponse
}

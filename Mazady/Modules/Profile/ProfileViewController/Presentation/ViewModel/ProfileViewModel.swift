//
//  ProfileViewModel.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation
import Combine

class ProfileViewModel {

    private let useCase: ProfileUseCaseProtocol

    let followingTitleText = "profile_scene.following_text".localized
    let followerTitleText = "profile_scene.follower_text".localized
    let firstSegmentedTabTitle = "profile_scene.products_text".localized
    let secondSegmentedTabTitle = "profile_scene.reviews_text".localized
    let thirdSegmentedTabTitle = "profile_scene.follower_text".localized

    @Published private(set) var userInfo: UserInformationResponse?
    @Published private(set) var products: [Product] = []
    @Published private(set) var offeredProducts: [Product] = []
    @Published private(set) var notOfferedProducts: [Product] = []
    @Published private(set) var tags: [Tag] = []
    @Published private(set) var advertisements: [Advertisement] = []

    var userInfoImageUrl: String {
        userInfo?.image ?? ""
    }

    var userInfoName: String {
        userInfo?.name ?? "NA"
    }

    var userInfoUserName: String {
        userInfo?.userName ?? "NA"
    }

    var userInfoNameCity: String {
        userInfo?.cityName ?? "NA"
    }

    var userInfoFollowers: String {
        "\(userInfo?.followersCount ?? 0)"
    }

    var userInfoFolloweing: String {
        "\(userInfo?.followingCount ?? 0)"
    }

    init(useCase: ProfileUseCaseProtocol = ProfileUseCase()) {
        self.useCase = useCase
    }
}

// MARK: Private helper methods
extension ProfileViewModel {
    func handleViewDidLoad() {
        Task {
            await fetchUserInfo()
            await fetchProducts()
            await fetchAdvertisements()
            await fetchTags()
        }
    }
}

// MARK: API Calls
extension ProfileViewModel {

    func fetchUserInfo() async {
        do {
            let info = try await useCase.fetchUserInfo()
            processFetchedUserInfo(info)
        } catch {
            handleAPIError(error)
        }
    }

    func fetchProducts() async {
        do {
            let list = try await useCase.fetchProducts()
            processFetchedProducts(list)
        } catch {
            handleAPIError(error)
        }
    }

    func fetchTags() async {
        do {
            let tagList = try await useCase.fetchTags()
            processFetchedTags(tagList)
        } catch {
            handleAPIError(error)
        }
    }

    func fetchAdvertisements() async {
        do {
            let ads = try await useCase.fetchAdvertisements()
            processFetchedAdvertisements(ads)
        } catch {
            handleAPIError(error)
        }
    }
}

// MARK: Private helper methods
private extension ProfileViewModel {

    func processFetchedUserInfo(_ userInfo: UserInformationResponse) {
        self.userInfo = userInfo
    }

    func processFetchedProducts(_ products: [Product]) {
        self.products = products
        self.offeredProducts = products.filter { $0.offer != nil }
        self.notOfferedProducts = products.filter { $0.offer == nil }
    }

    func processFetchedTags(_ tags: AllTagsResponse) {
        self.tags = tags.tags
    }

    func processFetchedAdvertisements(_ advertisements: AdvertisementsResponse) {
        self.advertisements = advertisements.advertisements
    }

    func handleAPIError(_ error: Error) {
        
    }
}

enum Section: Int, CaseIterable {
    case header, products, advertisements, tags
}

enum Item: Hashable {
    case header(UserInformationResponse)
    case product(Product)
    case advertisement(Advertisement)
    case tag(Tag)
}

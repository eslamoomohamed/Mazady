//
//  HeaderCollectionViewCellModel.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import Foundation

class HeaderCollectionViewCellModel {
    let userInformationResponse: UserInformationResponse

    init(userInformationResponse: UserInformationResponse) {
        self.userInformationResponse = userInformationResponse
    }

    var userInfoImageUrl: String {
        userInformationResponse.image
    }

    var userInfoName: String {
        userInformationResponse.name
    }

    var userInfoUserName: String {
        userInformationResponse.userName
    }

    var userInfoNameCity: String {
        userInformationResponse.cityName
    }

    var userInfoFollowers: String {
        "\(userInformationResponse.followersCount)"
    }

    var userInfoFolloweing: String {
        "\(userInformationResponse.followingCount)"
    }
}

//
//  HeaderCollectionViewCell.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var languageTitle: UILabel!
    @IBOutlet private weak var userInfoView: UIView!
    @IBOutlet private weak var userInfoImage: UIImageView!
    @IBOutlet private weak var userInfoName: UILabel!
    @IBOutlet private weak var userInfoUserNAme: UILabel!
    @IBOutlet private weak var userInfoLocation: UILabel!
    @IBOutlet private weak var userInfoFollowingValue: UILabel!
    @IBOutlet private weak var userInfoFollowingTitle: UILabel!
    @IBOutlet private weak var userInfoFollowerValue: UILabel!
    @IBOutlet private weak var userInfoFollowerTitle: UILabel!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!

    var changeLanguage:(() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        segmentedControl.isRTL = LocalizationManager.shared.isRTL
    }

    func configure(with viewModel: HeaderCollectionViewCellModel) {
        self.userInfoImage.downloadImage(from: viewModel.userInfoImageUrl, uuid: UUID())
        self.userInfoName.text = viewModel.userInfoName
        self.userInfoUserNAme.text = viewModel.userInfoUserName
        self.userInfoLocation.text = viewModel.userInfoNameCity
        self.userInfoFollowingValue.text = viewModel.userInfoFolloweing
        self.userInfoFollowerValue.text = viewModel.userInfoFollowers
    }
}

// MARK: Helper methods
private extension HeaderCollectionViewCell {
    func configureViews() {
        configureUSerInfoView()
        setupSegmentedControl()
    }

    func configureUSerInfoView() {
        configureLanguageTitle()
        configureUserInfoImage()
        configureUserInfoName()
        configureUserInfoUserName()
        configureUserInfoLocation()
        configureUserInfoFollowingValue()
        configureUerInfoFollwingTitle()
        configureUserInfoFollowerValue()
        configureUerInfoFollwerTitle()
    }

    func configureLanguageTitle() {
        languageTitle.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoRegular, size: 16))
    }

    func configureUserInfoImage() {
        userInfoImage.addCornerRaduis(18)
    }

    func configureUserInfoName() {
        userInfoName.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoBold, size: 16))
    }

    func configureUserInfoUserName() {
        userInfoUserNAme.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoRegular, size: 14))
    }

    func configureUserInfoLocation() {
        userInfoLocation.applyStyle(textColor: .paleGreyColor, font: UIFont(name: Fonts.nunitoRegular, size: 12))
    }

    func configureUserInfoFollowingValue() {
        userInfoFollowingValue.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoBold, size: 14))
    }

    func configureUerInfoFollwingTitle() {
        userInfoFollowingTitle.text = "profile_scene.following_text".localized
        userInfoFollowingTitle.applyStyle(textColor: .lipstickColor, font: UIFont(name: Fonts.nunitoRegular, size: 12))
    }

    func configureUserInfoFollowerValue() {
        userInfoFollowerValue.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoBold, size: 14))
    }

    func configureUerInfoFollwerTitle() {
        userInfoFollowerTitle.text = "profile_scene.follower_text".localized
        userInfoFollowerTitle.applyStyle(textColor: .lipstickColor, font: UIFont(name: Fonts.nunitoRegular, size: 12))
    }

    func setupSegmentedControl() {
        segmentedControl.segmentsTitle = ["profile_scene.products_text".localized,
                                          "profile_scene.reviews_text".localized,
                                          "profile_scene.follower_text".localized]
        segmentedControl.didTapSegment = { index in
            print(index)
        }
    }
}

// MARK: IBActions
private extension HeaderCollectionViewCell {
    @IBAction func changeLanguageButtonTap(_ sender: Any) {
        changeLanguage?()
    }
}

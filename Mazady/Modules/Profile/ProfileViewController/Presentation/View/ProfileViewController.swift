//
//  ProfileViewController.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    @IBOutlet private weak var baseCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var viewModel: ProfileViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil)
        configureViews()
        configureBinding()
        viewModel.handleViewDidLoad()
    }
}

private extension ProfileViewController {
    func configureBinding() {
        viewModel.$userInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapshot()
            }
            .store(in: &cancellables)

        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.applySnapshot()
            }
            .store(in: &cancellables)

        viewModel.$advertisements
            .receive(on: DispatchQueue.main)
            .sink { [weak self] advertisements in
                self?.applySnapshot()
            }
            .store(in: &cancellables)

        viewModel.$tags
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tags in
                self?.applySnapshot()
            }
            .store(in: &cancellables)
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        if let userInfo = viewModel.userInfo {
            snapshot.appendSections([.header])
            snapshot.appendItems([.header(userInfo)], toSection: .header)
        }

        if !viewModel.products.isEmpty {
            snapshot.appendSections([.products])
            snapshot.appendItems(viewModel.products.map { Item.product($0) }, toSection: .products)
        }

        if !viewModel.advertisements.isEmpty {
            snapshot.appendSections([.advertisements])
            snapshot.appendItems(viewModel.advertisements.map { Item.advertisement($0) }, toSection: .advertisements)
        }

        if !viewModel.tags.isEmpty {
            snapshot.appendSections([.tags])
            snapshot.appendItems(viewModel.tags.map { Item.tag($0) }, toSection: .tags)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func configureViews() {
        configureCollectionView()
        configureDataSource()
    }
}

private extension ProfileViewController {
    func configureCollectionView() {
        baseCollectionView.collectionViewLayout = createLayout()
        baseCollectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "HeaderCollectionViewCell")
        baseCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "ProductCollectionViewCell")
        baseCollectionView.register(UINib(nibName: "AdvertisementsCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "AdvertisementsCollectionViewCell")
        baseCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "TagCollectionViewCell")
        baseCollectionView.register(UINib(nibName: "SectionHeaderView", bundle: nil),
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: "SectionHeaderView")
        baseCollectionView.backgroundColor = .backgroundColor
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .header:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                return NSCollectionLayoutSection(group: group)
                
            case .products:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let itemSpacing: CGFloat = 5
                item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
                
                let columnWidth = NSCollectionLayoutDimension.fractionalWidth(1.0 / 3.0)
                let leadingGroupSize = NSCollectionLayoutSize(widthDimension: columnWidth, heightDimension: .estimated(100))
                
                let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitems: [item])
                let centerGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitems: [item])
                let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
                let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup, centerGroup])
                
                let section = NSCollectionLayoutSection(group: nestedGroup)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                return section

            case .advertisements:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(180)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(180)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                group.interItemSpacing = .fixed(16)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 20
                
                return section
            case .tags:

                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(100),
                    heightDimension: .absolute(40)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
        return layout
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: baseCollectionView) {
            collectionView, indexPath, item in
            
            switch item {
            case .header(let userInfo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell",
                                                             for: indexPath) as! HeaderCollectionViewCell
                cell.configure(with: HeaderCollectionViewCellModel(userInformationResponse: userInfo))
                cell.changeLanguage = { [weak self] in
                    let languageVC = LanguageViewController()
                    let viewModel = LanguageViewModel()
                    languageVC.viewModel = viewModel
                    let navController = UINavigationController(rootViewController: languageVC)
                    self?.navigationController?.present(navController, animated: true)
                }
                return cell
                
            case .product(let product):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell",
                                                           for: indexPath) as! ProductCollectionViewCell
                cell.configure(with: ProductCollectionViewCellModel(product: product))
                return cell
                
            case .advertisement(let advertisement):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertisementsCollectionViewCell",
                                                           for: indexPath) as! AdvertisementsCollectionViewCell
                let viewModel = AdvertisementsCollectionViewCellModel(advertisement: advertisement)
                cell.configure(with: viewModel)
                return cell

            case .tag(let tag):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell",
                                                           for: indexPath) as! TagCollectionViewCell
                let viewModel = TagCollectionViewCellModel(tag: tag)
                cell.configure(with: viewModel)
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView

            if kind == UICollectionView.elementKindSectionHeader {
                let section = Section(rawValue: indexPath.section)
                switch section {
                case .tags:
                    header.configure(with: "profile_scene.top.tags_text".localized)
                default:
                    break
                }
            }
            
            return header
        }
    }
}

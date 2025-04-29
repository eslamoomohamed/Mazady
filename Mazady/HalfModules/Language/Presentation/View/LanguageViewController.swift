//
//  LanguageViewController.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import UIKit

import UIKit

class LanguageViewController: UIViewController {
    
    @IBOutlet private weak var changeLanguageTitle: UILabel!
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var languageTableView: UITableView!
    
    var viewModel: LanguageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

}

// MARK: IBACtions
private extension LanguageViewController {
    @IBAction func dismissButtonTap(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
}

// MARK: Helper methods
private extension LanguageViewController {
    func configureViews() {
        containerStackView.backgroundColor = .backgroundColor
        configureChangeLanguageTitle()
        configureContainerStackView()
        configureLanguageTableView()
    }

    func configureChangeLanguageTitle() {
        changeLanguageTitle.text = viewModel.changeLanguageTitle
        changeLanguageTitle.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoBold, size: 24))
    }

    func configureContainerStackView() {
        containerStackView.addCornerRaduis(20, .top)
    }

    func configureLanguageTableView() {
        languageTableView.separatorStyle = .singleLine
        languageTableView.delegate = self
        languageTableView.dataSource = self
        languageTableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "LanguageTableViewCell")
    }
}

// MARK: UITableViewDataSource
extension LanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLanguages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as? LanguageTableViewCell else {
            fatalError("Unable to dequeue LanguageTableViewCell")
        }
        
        let language = viewModel.language(at: indexPath.row)
        cell.configure(with: language, isSelected: viewModel.isLanguageSelected(language))
        return cell
    }
}

// MARK: UITableViewDelegate
extension LanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = viewModel.language(at: indexPath.row)
        viewModel.selectLanguage(selectedLanguage)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}

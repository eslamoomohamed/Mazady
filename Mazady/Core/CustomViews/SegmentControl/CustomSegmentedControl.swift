//
//  CustomSegmentedControl.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import UIKit

class CustomSegmentedControl: UIView {

    var stackView: UIStackView = UIStackView()
    var buttonsCollection: [UIButton] = []
    var currentIndexView: UIView = UIView(frame: .zero)

    var buttonPadding: CGFloat = 5
    var stackViewSpacing: CGFloat = 0
    let font = UIFont(name: Fonts.nunitoRegular, size: 16)

    var didTapSegment: ((Int) -> Void)?

    var currentIndex: Int = 0 {
        didSet {
            setCurrentIndex()
        }
    }

    var currentIndexTitleColor: UIColor = .lipstickColor {
        didSet {
            updateTextColors()
        }
    }

    var currentIndexBackgroundColor: UIColor = .lipstickColor {
        didSet {
            setCurrentViewBackgroundColor()
        }
    }

    var otherIndexTitleColor: UIColor = .charcoalGrayColor {
        didSet {
            updateTextColors()
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            setCornerRadius()
        }
    }

    var buttonCornerRadius: CGFloat = 0 {
        didSet {
            setButtonCornerRadius()
        }
    }

    var borderColor: UIColor = .clear {
        didSet {
            setBorderColor()
        }
    }

    var borderWidth: CGFloat = 1 {
        didSet {
            setBorderWidth()
        }
    }

    var numberOfSegments: Int = 0 {
        didSet {
            addSegments()
        }
    }

    var segmentsTitle: [String] = [] {
        didSet {
            numberOfSegments = segmentsTitle.count
            updateSegmentTitles()
        }
    }

    var isRTL: Bool = false {
        didSet {
            let buttonWidth = (frame.width - (buttonPadding * 2)) / CGFloat(numberOfSegments)
            let initialX: CGFloat
            switch isRTL {
            case true:
                initialX = self.frame.width - self.buttonPadding - buttonWidth * CGFloat(currentIndex + 1)
            case false:
                initialX = CGFloat(currentIndex) * buttonWidth
            }
            self.currentIndexView.frame = CGRect(x: initialX,
                                                 y: self.frame.height - self.buttonPadding - 2,
                                                 width: buttonWidth,
                                                 height: 2)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setCurrentIndex(animated: false)
    }

    private func configure() {
        backgroundColor = .clear
        setupStackView()
        addSegments()
        setCurrentIndexView()
        setCurrentIndex(animated: false)
    }

    private func setCurrentIndexView() {
        setCurrentViewBackgroundColor()
        addSubview(currentIndexView)
    }

    private func setCurrentIndex(animated: Bool = true) {
        stackView.subviews.enumerated().forEach { index, view in
            let button: UIButton? = view as? UIButton

            let currentIndexForLayout = !isRTL ? currentIndex : numberOfSegments - 1 - currentIndex
            if index == currentIndexForLayout {
                let buttonWidth = (frame.width - (buttonPadding * 2)) / CGFloat(numberOfSegments)

                if animated {
                    applyAnimation(buttonWidth, index: index)
                }
            }
            var color = currentIndexTitleColor
            color = currentIndex == index ? currentIndexTitleColor : otherIndexTitleColor
            button?.setTitleColor(color, for: .normal)
        }
    }

    private func applyAnimation(_ buttonWidth: CGFloat, index: Int) {
        UIView.animate(withDuration: 0.3) {
            self.currentIndexView.frame =
            CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                       y: self.frame.height - self.buttonPadding - 2,
                       width: buttonWidth,
                       height: 2)
        }
    }

    private func updateTextColors() {
        stackView.subviews.enumerated().forEach { index, view in
            let button: UIButton? = view as? UIButton

            if index == currentIndex {
                button?.setTitleColor(currentIndexTitleColor, for: .normal)
            } else {
                button?.setTitleColor(otherIndexTitleColor, for: .normal)
            }
        }
    }

    private func setCurrentViewBackgroundColor() {
        currentIndexView.backgroundColor = currentIndexBackgroundColor
    }

    private func setupStackView() {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = stackViewSpacing
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonPadding),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buttonPadding),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: buttonPadding),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonPadding)
            ]
        )
    }

    private func addSegments() {
        buttonsCollection.removeAll()
        stackView.subviews.forEach { view in
            (view as? UIButton)?.removeFromSuperview()
        }

        let titles = segmentsTitle

        for index in 0 ..< numberOfSegments {
            let button = UIButton()
            button.tag = index

            if let index = titles.indices.contains(index) ? index : nil {
                button.setTitle(String(titles[index]), for: .normal)
            } else {
                button.setTitle("<Segment> \(index)", for: .normal)
            }

            button.titleLabel?.font = font
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)

            stackView.addArrangedSubview(button)
            buttonsCollection.append(button)
        }
    }

    private func updateSegmentTitles() {
        let titles = segmentsTitle

        stackView.subviews.enumerated().forEach { index, view in
            if let index = titles.indices.contains(index) ? index : nil {
                (view as? UIButton)?.setTitle(String(titles[index]), for: .normal)
            } else {
                (view as? UIButton)?.setTitle("<Segment>", for: .normal)
            }
        }
    }

    private func setCornerRadius() {
        layer.cornerRadius = cornerRadius
    }

    private func setButtonCornerRadius() {
        stackView.subviews.forEach { view in
            (view as? UIButton)?.layer.cornerRadius = cornerRadius
        }
        currentIndexView.layer.cornerRadius = cornerRadius
    }

    private func setBorderColor() {
        layer.borderColor = borderColor.cgColor
    }

    private func setBorderWidth() {
        layer.borderWidth = borderWidth
    }

    @objc
    func segmentTapped(_ sender: UIButton) {
        didTapSegment?(sender.tag)
        currentIndex = sender.tag
    }
}

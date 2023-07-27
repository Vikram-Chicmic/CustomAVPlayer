//
//  TimeLabelView.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 27/07/23.
//

import Foundation
import UIKit

class TimeLabelView: UIView {

    // MARK: - Properties

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
//        stackView.spacing = 20 // Set the desired space between the labels
        return stackView
    }()


    
    private let label1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    // MARK: - Private Setup

    private func setupSubviews() {
        // Add the labels to the stack view
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)

        // Add the stack view to the custom view
        addSubview(stackView)

        // Set constraints to position the stack view with desired spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0), // Add spacing from the left edge
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0), // Add spacing from the right edge
            stackView.topAnchor.constraint(equalTo: topAnchor), // Align to the top edge
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor) // Align to the bottom edge
        ])
    }

    // MARK: - Public Methods
    
    func setCurrentTime(value: String) {
        label1.text = value
    }
    
    func setDuration(value: String) {
        label2.text = value
    }
    
    func setFontSize() {
        
    }
}

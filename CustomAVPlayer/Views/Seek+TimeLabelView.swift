//
//  Seek+TimeLabelView.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 27/07/23.
//

import Foundation
import UIKit

class CustomStackView: UIView {

    // MARK: - Properties

    private var topView: UIView?
    private var bottomView: UIView?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
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
        addSubview(stackView)

        // Set constraints for the stack view to fill the custom view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public Methods
    func reverseViewsInVerticalStack() {
        guard let topView = topView, let bottomView = bottomView else {
            return
        }
        guard let indexTopView = stackView.arrangedSubviews.firstIndex(of: topView),
              let indexBottomView = stackView.arrangedSubviews.firstIndex(of: bottomView) else {
            return
        }

        // Remove both views from the stack
        stackView.removeArrangedSubview(topView)
        stackView.removeArrangedSubview(bottomView)

        // Insert them back in the reversed order
        if indexTopView < indexBottomView {
            // Insert bottomView above topView
            stackView.insertArrangedSubview(bottomView, at: indexTopView)
        } else {
            // Insert topView above bottomView
            stackView.insertArrangedSubview(topView, at: indexBottomView)
        }
    }
    
    
    func addFirstView(_ view: UIView) {
        stackView.addArrangedSubview(view)
        topView = view
    }

    func addSecondView(_ view: UIView) {
        stackView.addArrangedSubview(view)
        bottomView = view
    }
    
    func hideBottomView() {
        topView?.isHidden = false
        bottomView?.isHidden = true
    }

    func hideTopView() {
        topView?.isHidden = true
        bottomView?.isHidden = false
    }
    
}



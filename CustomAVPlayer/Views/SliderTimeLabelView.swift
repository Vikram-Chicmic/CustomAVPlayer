//
//  Seek+TimeLabelView.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 27/07/23.
//

import Foundation
import UIKit

class SliderTimeLabelView: UIStackView {

    // MARK: - properties
    private var topView: UIView?
    private var bottomView: UIView?

    // MARK: - initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Setup

    private func setStackView() {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
    }

    // MARK: - methods for customization
    func reverseViewsInVerticalStack() {
        guard let topView = topView, let bottomView = bottomView else {
            return
        }
        guard let indexTopView = self.arrangedSubviews.firstIndex(of: topView),
              let indexBottomView = self.arrangedSubviews.firstIndex(of: bottomView) else {
            return
        }

        // Remove both views from the stack
        self.removeArrangedSubview(topView)
        self.removeArrangedSubview(bottomView)

        // Insert them back in the reversed order
        if indexTopView < indexBottomView {
            // Insert bottomView above topView
            self.insertArrangedSubview(bottomView, at: indexTopView)
        } else {
            // Insert topView above bottomView
            self.insertArrangedSubview(topView, at: indexBottomView)
        }
    }
    
    
    func addFirstView(_ view: UIView) {
        self.addArrangedSubview(view)
        topView = view
    }

    func addSecondView(_ view: UIView) {
        self.addArrangedSubview(view)
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

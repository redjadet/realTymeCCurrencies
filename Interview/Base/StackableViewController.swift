//
//  StackableViewController.swift
//  Interview
//
//  Created by ilker sevim on 2.02.2022.
//

import UIKit

open class StackableViewController: UIViewController {
    
    public var stackViewBottomConstraint: NSLayoutConstraint!

    public var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        return stackView
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
        initStackView()
    }

    public init(stackViewTopConstraintToSafeArea: Bool = true, bottomOffset: CGFloat = 0) {
        super.init(nibName: nil, bundle: nil)
        initStackView(topSafeConstraint: stackViewTopConstraintToSafeArea, bottomOffset: bottomOffset)
    }

    private func initStackView(topSafeConstraint: Bool = true, bottomOffset: CGFloat = 0) {
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topSafeConstraint ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor).isActive = true
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomOffset)
        stackViewBottomConstraint.isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView.layer.zPosition = -1
        view.sendSubviewToBack(stackView)
        
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func popFromNavigation(animated: Bool){
        self.navigationController?.popViewController(animated: animated)
    }

}

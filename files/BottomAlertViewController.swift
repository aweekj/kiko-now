//
//  BottomAlertViewController.swift
//  
//
//  Created by Nudgest on 2022/04/26.
//

import Foundation
import UIKit
import SnapKit

class BottomAlertViewController: UIViewController {
    final class AlertView: UIView {
        
    }
    
    // MARK: Must Override
    open func setConstraint() { }
    open var alertHeight: CGFloat {
        get {
            return 0.0
        }
    }
    
    // MARK: Can Override
    open var backgrounColor: UIColor {
        get {
            return .clear
        }
    }
    
    // MARK: Public
    public var contentView: AlertView = AlertView()
    
    // MARK: Fileprivate
    fileprivate var topConstraint: Constraint?
    fileprivate var backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = self.backgrounColor
        
        self.backgroundView.backgroundColor = .clear
        self.backgroundView.setTapGesture(target: self, action: #selector(self.didTapBackground(_:)))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.retain(animated: true)
    }
    @objc
    fileprivate func didTapBackground(_ gesture: UITapGestureRecognizer) {
        self.release(animated: true)
    }
    fileprivate func retain(animated: Bool = true) {
        self.setConstraint()
        self.view.alpha = 0.0
        
        self.backgroundView.backgroundColor = self.backgrounColor
        self.view.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints({
            $0.top.bottom.left.right.equalTo(self.view)
        })
        
        let size = CGSize(width: 414.0, height: self.alertHeight)
        self.view.addSubview(self.contentView)
        self.contentView.backgroundColor = .white
        self.contentView.isUserInteractionEnabled = true
        self.contentView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
        self.contentView.frame.size = size
        
        self.contentView.snp.makeConstraints({
            self.topConstraint = $0.top.equalTo(self.view.snp.bottom).inset(size.height).constraint
            $0.size.equalTo(size)
            $0.centerX.equalTo(self.view)
        })
        
        self.topConstraint?.activate()
        
        self.contentView.roundCorners(corners: [.topLeft, .topRight], radius: 14)
        self.contentView.layoutIfNeeded()
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                
                self.view.layoutIfNeeded()
            })
        } else {
            self.view.layoutIfNeeded()
        }
    }
    fileprivate func release(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let topConstraint = self.topConstraint else { return }
        
        topConstraint.layoutConstraints[0].constant = 0
        
        let animatedHandler: () -> Void = { [weak self] in
            guard let self = self else { return }
            
            self.contentView.removeFromSuperview()
            self.topConstraint = nil
            
            self.dismiss(animated: false, completion: completionHandler)
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                
                self.view.layoutIfNeeded()
                self.view.alpha = 0.0
            }, completion: {  _ in
                
                animatedHandler()
            })
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                animatedHandler()
            }
            self.view.layoutIfNeeded()
            self.view.alpha = 0.0
            CATransaction.commit()
        }
    }
    deinit {
        print("DEINIT BOTTOM ALERT VIEW CONTROLLER")
    }
}



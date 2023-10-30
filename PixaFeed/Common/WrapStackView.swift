//
//  WrapStackView.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 30.10.23.
//

import UIKit

class WrapStackView: UIView {
    
    private var arrangedSubviews: [UIView] = []
    
    func addArrangedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        arrangedSubviews.append(view)
        addSubview(view)
    }
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        arrangedSubviews.removeAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        let spacing: CGFloat = 10
        
        for view in arrangedSubviews {
            if x + view.frame.width > bounds.width {
                x = 0
                y += view.frame.height + spacing
            }
            
            view.frame.origin = CGPoint(x: x, y: y)
            x += view.frame.width + spacing
        }
    }
}

//
//  Display.swift
//  calculator
//
//  Created by Nadzeya Leanovich on 8/31/19.
//  Copyright © 2019 Nadzeya Leanovich. All rights reserved.
//

import UIKit.UILabel

class Display: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor.skyBlue
        text = "0"
        textAlignment = .right
        
    }
}

//
//  ViewController.swift
//  calculator
//
//  Created by Nadzeya Leanovich on 8/24/19.
//  Copyright © 2019 Nadzeya Leanovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var display = Display(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(display)
        setupConstrains()
    }
    
    private func setupConstrains() {
        
        display.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstrains = NSLayoutConstraint(item: display,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self.view.safeAreaLayoutGuide,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 8)
        
        let leftConstrains = NSLayoutConstraint(item: display,
                                               attribute: .left,
                                               relatedBy: .equal,
                                               toItem: self.view.safeAreaLayoutGuide,
                                               attribute: .left,
                                               multiplier: 1,
                                               constant: 8)
        
        let rightConstrains = NSLayoutConstraint(item: display,
                                                attribute: .right,
                                                relatedBy: .equal,
                                                toItem: self.view.safeAreaLayoutGuide,
                                                attribute: .right,
                                                multiplier: 1,
                                                constant: -8)
        
         let height = NSLayoutConstraint(item: display,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 60)
        
        view.self.addConstraints([topConstrains, leftConstrains, rightConstrains, height])
    }
    
    var displayValue: Double {
        
        get {
            let text = display.text!
            return Double(text)!
        }
        
        set {
            if Int(newValue * 100_000_000_000) - Int(newValue) * 100_000_000_000 != 0 {
                display.text = String(newValue)
            }
            else {
                display.text = String(Int(newValue))
            }
        }
    }
    
    var isUserTypping = false
    var currentFunction = ""
    
    @IBAction func digPressed(_ sender: UIButton) {
        
        guard let textOnButton =  sender.currentTitle else {
            return
        }
        
        if isUserTypping {
            let text = display.text!
            display.text = text + textOnButton
        }
        else {
            display.text = textOnButton
            isUserTypping = !isUserTypping
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        display.text = "0"
        isUserTypping = false
        model.clean()
    }
    
    var model = BrainModel()
    
    @IBAction func performOperation(_ sender: UIButton) {
        guard let symbol = sender.currentTitle else {
                return
        }
        
        if (isUserTypping) {
            model.setOperand(displayValue)
        }
        
        model.setFunction(symbol)
        displayValue = model.displayingValue
        isUserTypping = false
    }
}


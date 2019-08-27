//
//  ViewController.swift
//  calculator
//
//  Created by Nadzeya Leanovich on 8/24/19.
//  Copyright © 2019 Nadzeya Leanovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double {
        
        get {
            let text = display.text!
            
            return Double(text)!
        }
        
        set {
            
            display.text = String(newValue)
        }
    }
    
    enum Operation {
        
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case changeSign((Double) -> Double)
    }
    
    let dict: Dictionary<String, Operation> = [
        
        "∏": .constant(Double.pi),
        "√": .unaryOperation(sqrt),
        "±": .changeSign({ number in
            return number * (-1)
            })
       
    ]

    var isUserTypping = false

    @IBAction func digPressed(_ sender: UIButton) {
        
        guard let textOnButton =  sender.currentTitle else {
            return
        }
        
        if isUserTypping {
            
            let text = display.text!
            display.text = text + textOnButton
            
            return
        }

        display.text = textOnButton
        isUserTypping = !isUserTypping

    }
    
    @IBAction func clear(_ sender: Any) {
        display.text = "0"
        isUserTypping = false
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if let symbol = sender.currentTitle,
            let operation = dict[symbol] {
            
            switch operation {
                
            case .constant(let constant):
                
                displayValue = constant
                
            case .unaryOperation(let operation):
                
                guard (displayValue > 0) else {
                    display.text = "Not a number"
                    isUserTypping = false
                    return
                }
                
                displayValue = operation(displayValue)
                
            case .changeSign(let operation):
                
                displayValue = operation(displayValue)
            }
            
        }
        
        isUserTypping = false
    }
    
}


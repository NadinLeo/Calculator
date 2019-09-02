//
//  BrainModel.swift
//  calculator
//
//  Created by Nadzeya Leanovich on 8/31/19.
//  Copyright © 2019 Nadzeya Leanovich. All rights reserved.
//

import Foundation

class BrainModel {
    
    private var accumulator: Double?
    private var savedValue: Double?
    
    var displayingValue: Double { return savedValue ?? accumulator ?? 0}
    
    var currentOperation: ((Double, Double) -> Double)?
    
    enum Operation {
        
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case changeSign((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case resultOperation(((Double, Double) -> Double, Double, Double) -> Double)
    }
    
    let dict: Dictionary<String, Operation> = [
        
        "∏": .constant(Double.pi),
        "√": .unaryOperation(sqrt),
        "±": .changeSign({ number in
            return number * (-1)
        }),
        "÷": .binaryOperation({(first, second) in
            guard (second != 0) else {
                return 0
            }
            return first/second
        }),
        "×": .binaryOperation({first, second in
            return first * second
        }),
        "−": .binaryOperation({first, second in
            return first - second
        }),
        "+": .binaryOperation({first, second in
            return first + second
        }),
        "=": .resultOperation({action, first, second in
            return action(first, second)
        })
    ]
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    func clean() {
        accumulator = nil
        savedValue = nil
        currentOperation = nil
    }
    
    func performOperation (_ symbol: String) {
        
        if let operation = dict[symbol] {
            
            switch operation {
                
            case .constant(let constant):
                
                accumulator = constant
                
            case .unaryOperation(let operation):
                
//                guard (displayValue > 0) else {
//                    display.text = "Not a number"
//                    isUserTypping = false
//                    return
//                }
                
                accumulator = operation(accumulator!)
                
            case .changeSign(let operation):
                accumulator = operation(accumulator!)
                
            case .binaryOperation(let operation):
                guard let accumulator = accumulator else {
                    return
                }
                
                if let currentOperation = currentOperation,
                    let savedValue = savedValue {
                    self.accumulator = currentOperation(savedValue, accumulator)
                }
                
                currentOperation = operation
                savedValue = accumulator
                self.accumulator = nil
            case .resultOperation(let operation):
                guard let currentOperation = currentOperation,
                      let savedValue = savedValue,
                      let accumulator = accumulator
                    else {
                    return
                }
                
                self.accumulator = operation(currentOperation, savedValue, accumulator)
                self.savedValue = nil
                self.currentOperation = nil
            }
        }
    }
}



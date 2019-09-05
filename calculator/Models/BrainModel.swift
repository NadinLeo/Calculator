//
//  BrainModel.swift
//  calculator
//
//  Created by Nadzeya Leanovich on 8/31/19.
//  Copyright © 2019 Nadzeya Leanovich. All rights reserved.
//

import Foundation

class BrainModel {
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double?)
        case binaryOperation((Double, Double) -> Double?)
    }
    
    private let functionPriority = [ "−": 0,
                                     "+": 0,
                                     "÷": 1,
                                     "×": 1,
                                     "√": 2,
                                     "±": 2 ]
    
    private var operands: Array<Double>  = []
    
    private var functions: Array<String> = []
    
    var displayingValue: Double { return operands.last ?? 0 }
    
    var isCalculatingMode: Bool { return operands.count > 0 }
    
    private let dict: Dictionary<String, Operation> = [
        
        "∏": .constant(Double.pi),
        "√": .unaryOperation({number in
            guard number >= 0 else {
               // self.clean()
                return 0
            }
            return sqrt(number)
            
        }),
        "±": .unaryOperation({ number in
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
        })
    ]
    
    func setOperand(_ operand: Double) {
        operands.append(operand)
    }
    
    func setFunction(_ function: String) {
        functions.append(function)
        
        while let currentOperation = getCurrentOperation() {
            performOperation(currentOperation)
        }
    }
    
    private func getCurrentOperation() -> String? {
        guard let lastFunction = functions.last else {
            return nil
        }
        
        let priorityLastFunction = functionPriority[lastFunction]
        
        if (priorityLastFunction == 2) {
            functions.removeLast()
            return lastFunction
        }
        
        
        guard functions.count >= 2 else {
            return nil
        }
        
        let previousFunction = functions[functions.count - 2]
        let priorityPreviousFunction = functionPriority[previousFunction]
        
        if  let priorityPreviousFunction = priorityPreviousFunction,
            let priorityLastFunction = priorityLastFunction,
            (priorityPreviousFunction >= priorityLastFunction) {
            
                functions.remove(at: functions.count - 2)
                return previousFunction
            
        }
        
        return nil
    }
    
    func clean() {
        operands.removeAll()
        functions.removeAll()
    }
    
    private func performOperation (_ symbol: String) {
        
        if let operation = dict[symbol] {
            
            switch operation {
                
            case .constant(let constant):
                operands.append(constant)
                
            case .unaryOperation(let operation):
                if operands.isEmpty {
                    return
                }
                let lastOperand = operands.removeLast()
                
                if let resultOperand = operation(lastOperand) {
                    operands.append(resultOperand)
                    return;
                }
                
               clean()
                
            case .binaryOperation(let operation):
                if operands.count < 2 {
                    clean()
                    return
                }
                
                let firstOperand = operands.remove(at: operands.count - 2)
                let secondOperand = operands.remove(at: operands.count - 1)
                
                if let resultOperand = operation(firstOperand, secondOperand) {
                    operands.append(resultOperand)
                    return
                }
                
                clean()
            }
        }
    }
}



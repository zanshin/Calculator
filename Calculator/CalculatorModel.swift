//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Mark Nichols on 12/4/15.
//  Copyright © 2015 Mark Nichols. All rights reserved.
//

import Foundation

class CalculatorModel
{
    // Enumeration to hold the op types
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    // Stack of operands and operations, called `ops`
    private var opStack = [Op]()
    
    // An array of tuples to hold all the known ops
    private var knownOps = [String:Op]()
    
    // Initialize the known Ops when CalculatorModel is instantiated
    // Use * and + functions for those operations, can't for divide and minus
    // as order of operands needs to be reversed
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
    }
    
    // Recursive evaluation function to pop operands and operations off our stack
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            // need a mutable copy of the ops
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        // If all the above fails we need to return a nil to satisfy the Optional
        return (nil, ops)
    }
    
    // The outer evaluate function, which employs the recursive one to render a result
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    // Allow operands to be pushed onto the opStack
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    // For the symbols we know, perform the cooresponding operation
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
}

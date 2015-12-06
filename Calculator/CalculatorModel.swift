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
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case NullaryOperation(String)
        
        // Use a computed property to improve printing of this Enum
        var description: String {
            get {
                switch self {
                    case .Operand(let operand): return "\(operand)"
                    case .UnaryOperation(let symbol, _): return "\(symbol)"
                    case .BinaryOperation(let symbol, _): return "\(symbol)"
                    case .NullaryOperation(let symbol): return "\(symbol)"
                }
            }
        }
    }
    
    // Stack of operands and operations, called `ops`
    private var opStack = [Op]()
    
    // An array of tuples to hold all the known ops
    private var knownOps = [String:Op]()
    
    // Initialize the known Ops when CalculatorModel is instantiated
    // Use * and + functions for those operations, can't for divide and minus
    // as order of operands needs to be reversed
    init() {
        func learnOps(op: Op) {
            knownOps[op.description] = op
        }
        learnOps(Op.BinaryOperation("×", *))
        learnOps(Op.BinaryOperation("÷") { $1 / $0 })
        learnOps(Op.BinaryOperation("+", +))
        learnOps(Op.BinaryOperation("−") { $1 - $0 })
        learnOps(Op.UnaryOperation("√", sqrt))
        learnOps(Op.UnaryOperation("cos") { cos($0) })
        learnOps(Op.UnaryOperation("sin") { sin($0) })
        learnOps(Op.NullaryOperation("π"))
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
            case .NullaryOperation(_):
                return (M_PI, remainingOps)
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
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    // Expose the opStack
    func showOpStack() -> String? {
        return (opStack.map{ "\($0)" }).joinWithSeparator(" ")
    }
    
    // Allow operands to be pushed onto the opStack
    // return result of evaluation
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    // For the symbols we know, perform the cooresponding operation
    // return result of evaluation
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}

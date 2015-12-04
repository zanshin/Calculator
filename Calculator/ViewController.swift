//
//  ViewController.swift
//  Calculator
//
//  Created by Mark Nichols on 12/3/15.
//  Copyright © 2015 Mark Nichols. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // The calculator display
    @IBOutlet weak var display: UILabel!
    
    // Track if number is currently being entered
    var numberBeingEntered = false
    
    // Operand stack implemented as an Array
    var operandStack = Array<Double>()

    // Helper to convert display string to value and vice-versa
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            numberBeingEntered = false
        }
    }
    
    // The digit buttons append their title to the current display
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
    
        if numberBeingEntered {
            display.text = display.text! + digit
        } else {
            display.text = digit
            numberBeingEntered = true
        }
    }
    
    // When the enter key is touched: start a new number and push the current number
    // on the operand stack
    @IBAction func enter() {
        numberBeingEntered = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    // Perform the operation selected
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if numberBeingEntered {
            enter()
        }
        
        // Closures make for incredibly tight code
        switch operation {
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            case "√": performOperation { sqrt($0) }
            default: break
        }
    }
    
    // Perform the selected operation against the operands
    // Binary operations take two operands
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    // Unary operations require a single operand
    // Need `@nonobjc` attribute as Objective-C doesn't support method overloading
    @nonobjc
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
}


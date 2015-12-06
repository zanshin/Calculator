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
    // The calculator display and the display history
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayHistory: UILabel!
    
    // The calculator model or brain
    var brain = CalculatorModel()
    
    // Track if number is currently being entered
    var numberBeingEntered = false
    
    // Helper to convert display string to value and vice-versa
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            numberBeingEntered = false
            displayHistory.text = brain.showOpStack()
        }
    }
    
    // The digit buttons append their title to the current display
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
    
        if numberBeingEntered {
            if (digit == ".") && (display.text!.rangeOfString(".") != nil) { return }
            display.text = display.text! + digit
        } else {
            if (digit == ".") {
                display.text = "0."
            } else {
                display.text = digit
            }
            
            numberBeingEntered = true
        }
    }
    
    // When the enter key is touched: start a new number and push the current number
    // on the operand stack and display the result
    @IBAction func enter() {
        numberBeingEntered = false

        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    // Perform the operation selected and display the result
    @IBAction func operate(sender: UIButton) {
        if numberBeingEntered {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        
    }
    
}


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
    
    // track if number is entered
    var numberBeingEntered: Bool = false

    
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
    
}


//
//  ViewController.swift
//  Guess The Number
//
//  Created by Lei Zhao on 5/21/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rangeLbl: UILabel!
    @IBOutlet weak var numberTxtField: UITextField!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var numGuessesLbl: UILabel!
    
    private var lowerBound = 0
    private var upperBound = 100
    private var numGuesses = 0
    private var secretNumber = 0
    
    @IBAction func onOkPressed(sender: AnyObject) {
        // print(numberTxtField.text)

        guard let number = Int(numberTxtField.text!) else {
            let alert = UIAlertController(title: nil, message: "Enter a number", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        selectedNumber(number)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

private extension ViewController{
    enum Comparison {
        case Smaller
        case Greater
        case Equals
    }
    
    func selectedNumber(number: Int) {
        switch compareNumber(number, otherNumber: secretNumber) {
        case .Smaller:
            self.lowerBound = max(lowerBound, number)
            self.messageLbl.text = "Your last guess was too low"
            self.numberTxtField.text = ""
            self.numGuesses += 1
            self.renderRange()
            self.renderNumGuesses()

        case .Greater:
            self.upperBound = min(upperBound, number)
            self.messageLbl.text = "Your last guess was too hight"
            self.numberTxtField.text = ""
            self.numGuesses += 1
            self.renderRange()
            self.renderNumGuesses()

        case .Equals:
            self.numGuesses += 1
            self.renderNumGuesses()
            let alert = UIAlertController(title:nil, message: "You won in \(numGuesses) guesses!The secret number is \(self.secretNumber)", preferredStyle:
                UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
                self.reset()
                self.numberTxtField.text = ""
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func compareNumber(number: Int, otherNumber: Int)->Comparison {
        if number < otherNumber {
            return .Smaller
        } else if(number > otherNumber) {
            return .Greater
        }

        return .Equals
    }
}

private extension ViewController {
    func extractSecretNumber() {
        let diff = self.upperBound - self.lowerBound
        let randomNumber = Int(arc4random_uniform(UInt32(diff))) + 1
        self.secretNumber = self.lowerBound + randomNumber
    }
    
    func renderRange() {
        self.rangeLbl.text = "\(lowerBound) and \(upperBound)"
    }
    
    func renderNumGuesses() {
        self.numGuessesLbl.text = "number of Guesses: \(numGuesses)"
    }
    
    func resetData() {
        self.lowerBound = 0
        self.upperBound = 100
        self.numGuesses = 0
    }
    
    func resetMsg() {
        self.messageLbl.text = ""
    }
    
    func reset() {
        resetData()
        renderRange()
        renderNumGuesses()
        extractSecretNumber()
        resetMsg()
    }
}


//
//  ViewController.swift
//  Retro-Calculator
//
//  Created by Nate on 4/26/16.
//  Copyright © 2016 Karabensh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Clear = "Clear"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLabel: UILabel!
    
    //variable for the button sound
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        
        do{
            try btnSound = AVAudioPlayer(contentsOfURL: soundURL)
            btnSound.prepareToPlay()
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
        
        
        
    }

    //Function For number press
    @IBAction func numberPressed(btn: UIButton!){
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLabel.text = runningNumber
    }
    
    //Function when Divide button is pressed
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    //Function when Multiply is pressed
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    //Funciton when Subtract is pressed
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    //Function when Add is pressed
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    //Function when Equal is pressed
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        processOperation(Operation.Clear)
    }
    
    
    func processOperation(op: Operation) {
        playSound()
        
        
        if (op == Operation.Clear) {
            leftValStr = ""
            rightValStr = ""
            runningNumber = ""
            outputLabel.text = "0.0"
            currentOperation = Operation.Empty
        }
        else if (currentOperation != Operation.Empty) {
            //Run some math
            
            //A user selected an operator, but then selected another operator without first entering a number
            if (runningNumber != "") {
                rightValStr = runningNumber
                runningNumber = ""
                
                if (currentOperation == Operation.Divide) {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                }
                else if (currentOperation == Operation.Multiply){
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                }
                else if (currentOperation == Operation.Subtract) {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                }
                else if (currentOperation == Operation.Add) {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
            }
            
            
            leftValStr = result
            outputLabel.text = result
            
            currentOperation = op
            
        }
        else {
            //This is the first time an operator has been pressed
            //Save and clear the running number and operator
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    
    func playSound() {
        //stop the sound if it is already playing
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
}


//
//  ViewController.swift
//  Convert It
//
//  Created by Jess on 10/2/19.
//  Copyright © 2019 Jess. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Formula {
        var conversionString: String
        var forumla: (Double) -> (Double)
    }

    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsOutlet: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    let formulasArray = [Formula(conversionString: "miles to kilometers", forumla: {$0 / 0.62137}),
                         Formula(conversionString: "kilometers to miles", forumla: {$0 * 0.62137}),
                         Formula(conversionString: "feet to meters", forumla: {$0 / 3.2808}),
                         Formula(conversionString: "yards to meters", forumla: {$0 / 1.0936}),
                         Formula(conversionString: "meters to feet", forumla: {$0 * 3.2808}),
                         Formula(conversionString: "meters to yards", forumla: {$0 * 1.0936}),
                         Formula(conversionString: "inches to cm", forumla: {$0 / 0.3937}),
                         Formula(conversionString: "cm to inches", forumla: {$0 * 0.3937}),
                         Formula(conversionString: "fahrenheit to celsius", forumla: {($0 - 32) * (5/9)}),
                         Formula(conversionString: "celsius to fahrenheit", forumla: {($0 * (5/9)) + 32}),
                         Formula(conversionString: "quarts to liters", forumla: {$0 / 1.05669}),
                         Formula(conversionString: "liters to quarts", forumla: {$0 * 1.05669})]
    
    var fromUnits = ""
    var toUnits = ""
    var conversionStrings = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
        conversionStrings = formulasArray[formulaPicker.selectedRow(inComponent: 0)].conversionString
        let unitsArray = conversionStrings.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        fromUnitsLabel.text = fromUnits
        toUnits = unitsArray[1]
        userInput.becomeFirstResponder()
        signSegment.isHidden = true
    }
    

    func calculateConversion() {
        
        guard let inputValue = Double(userInput.text!) else {
            if userInput.text != "" {
                showAlert(title: "Can't Convert Value.", message: "\(userInput.text!) is not a valid number.")
            }
            return
        }
        
        let outputValue = formulasArray[formulaPicker.selectedRow(inComponent: 0)].forumla(inputValue)
        
        let formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments-1 ? "%.\(decimalSegment.selectedSegmentIndex+1)f" : "%f")
        let outputString = String(format: formatString, outputValue)
        resultsOutlet.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func userInputChanged(_ sender: UITextField) {
        resultsOutlet.text = ""
        if userInput.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        } else {
            signSegment.selectedSegmentIndex = 0
        }
    }
    

    @IBAction func decimalSelected(_ sender: Any) {
        calculateConversion()
    }
    
    @IBAction func signSegmentSelected(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0 {
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "-" + userInput.text!
        }
        if userInput.text != "" {
            calculateConversion()
        }
    }
    
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        calculateConversion()
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulasArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulasArray[row].conversionString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conversionStrings = formulasArray[row].conversionString
        
        if conversionStrings.lowercased().contains("celsius".lowercased()) {
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
            signSegment.selectedSegmentIndex = 0
        }
        
        let unitsArray = formulasArray[row].conversionString.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        calculateConversion()
    }
    
}

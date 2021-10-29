//
//  ViewController.swift
//  salsa20-compiler
//
//  Created by Luiz Vinicius Ruoso on 28/08/21.
//
//

import Cocoa
class ViewController: NSViewController {

    @IBOutlet var mainTextView: NSTextView!
    @IBOutlet var errorTextView: NSTextView!
    @IBAction func compileButtonPressed(_ sender: Any) {
        print("Compile Button Pressed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var aux =  LexicalAnalyzer()
        print()
        aux.analyse()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

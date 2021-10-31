//
//  ViewController.swift
//  salsa20-compiler
//
//  Created by Luiz Vinicius Ruoso on 28/08/21.
//
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var fileNameTextView: NSTextField!
    @IBOutlet weak var importButton: NSButton!
    @IBOutlet var mainTextView: NSTextView!
    @IBOutlet var errorTextView: NSTextView!
    var lexicalAnalyzer = LexicalAnalyzer()
    var linkedCharacters = LinkedList<String>()

    @IBAction func compileButtonPressed(_ sender: Any) {
        lexicalAnalyzer.syntacticErrorMessage = nil
        if let fileContent = retrieveStringFromFile(fileName: fileNameTextView.stringValue) {
            lexicalAnalyzer.linkedCharacters.removeAll()
            do {
                self.linkedCharacters = try lexicalAnalyzer.analyse(fileContent: fileContent)
            } catch {
                print(error)
            }
            errorTextView.string = ""
            errorTextView.string = lexicalAnalyzer.syntacticErrorMessage ?? "Build succeeded without any errors"
        }
    }

    @IBAction func importButtonPressed(_ sender: Any) {
        if let fileContent = retrieveStringFromFile(fileName: fileNameTextView.stringValue) {
            mainTextView.string = fileContent
        }
    }

    override func viewDidLoad()  {
        super.viewDidLoad()

//        let _posFixed = PosFixed()

        // _posFixed.posFixedConvertion()
        //return

        // return
//        do{
//            var lexical =  LexicalAnalyzer()
//            self.linkedCharacters = try lexical.analyse()
//
//
//            print(self.linkedCharacters)
//            var sintatic = SyntacticAnalyzer(linkedCharacters: self.linkedCharacters)
//
//            try sintatic.analyser()
//            print("foi? parece que foi!")
//
//
//        }catch{
//            print(error)
//        }
        //DESNECESSARIO, LUIZ-OTARIO - 30/10/2021 - ?)
        
        
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func retrieveStringFromFile(fileName: String) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }
        let string = try? String(contentsOfFile: path, encoding: .utf8)
        return string
    }
}

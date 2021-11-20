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

    var lexical = LexicalAnalyzer()
    var linkedCharacters = LinkedList<token_struct>()

    @IBAction func compileButtonPressed(_ sender: Any) {
        errorTextView.string = ""
        lexical.fileContent = []
        if let documentString = retrieveStringFromFile(fileName: fileNameTextView.stringValue) {
            let fileContent = lexical.setFileContent(content: documentString)
            lexical.linkedCharacters.removeAll()
            do {
                linkedCharacters = try lexical.analyse(fileContent1: fileContent)
                let sintatic = SyntacticAnalyzer(linkedCharacters: linkedCharacters)
                try sintatic.analyser()
            } catch {
//                errorTextView.string = "\(error)"
                errorTextView.string = "\(error)"
                print(error)
            }
        }
    }

    @IBAction func importButtonPressed(_ sender: Any) {
        if let fileContent = retrieveStringFromFile(fileName: fileNameTextView.stringValue) {
            mainTextView.string = fileContent
        }
    }

    override func viewDidLoad()  {
    super.viewDidLoad()
        
        //let _posFixed = PosFixed()
        
       // _posFixed.posFixedConvertion()
        //return
        
       // return
//        do{
//            var lexical =  LexicalAnalyzer()
////            self.linkedCharacters = try lexical.analyse()
//
//
//            print(self.linkedCharacters)
//            var sintatic = SyntacticAnalyzer(linkedCharacters: self.linkedCharacters)
//
//
//            //print(sintatic.simbolTable)
//
//            try sintatic.analyser()
//            print("foi? parece que foi!")
//
//
//        }catch{
//            errorTextView.string = "\(error)"
//            print(error)
//        }
        //DESNECESSARIO, LUIZ-OTARIO - 30/10/2021 - bjunda ?)
        
        
        
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
    
    


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
            let fileContent = lexical.setFileContent(content: mainTextView.string)
            print(fileContent)
            //let fileContent = mainTextView.string
            lexical.linkedCharacters.removeAll()
            do {
                linkedCharacters = try lexical.analyse(fileContent1: fileContent)
                let sintatic = SyntacticAnalyzer(linkedCharacters: linkedCharacters)
                try sintatic.analyser()
                errorTextView.string = "Code successfully exited with no errors"
            } catch {
                if let errorMessage = error as? sintaticException {
                    errorTextView.string = "\(errorMessage.name): \(errorMessage.message)"
                }
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
        mainTextView.font = .systemFont(ofSize: 16)
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

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
            changeVariableColors()
            changeTypeColors()
            changeFunctionColors()
            changeStartEndColors()
            changeIfElseColors()
        }
    }

    override func viewDidLoad()  {
        super.viewDidLoad()
        let menloRegularFont = NSFont(name: "Menlo", size: 13)
        mainTextView.font = menloRegularFont
        errorTextView.font = .systemFont(ofSize: 13)
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
    //MARK: - Code beautifier

    func changeVariableColors() {
        let varColor = NSColor(red: 8/255, green: 126/255, blue: 139/255, alpha: 1)
        let searchString = "var"
        let formatedString = NSString(string: mainTextView.string)
        var rangesArray = [NSRange]()

        NSString(string: mainTextView.string).enumerateSubstrings(in: NSMakeRange(0, formatedString.length), options: .byWords) { substring, substringRange, _, _ in
            if substring == searchString {
                rangesArray.append(substringRange)
            }
        }
        for range in rangesArray {
            mainTextView.setTextColor(varColor, range: range)
        }
    }
    func changeTypeColors() {
        let typeColor = NSColor(red: 125/255, green: 91/255, blue: 166/255, alpha: 1)
        let searchStrings = ["inteiro", "booleano"]
        let formatedString = NSString(string: mainTextView.string)
        var rangesArray = [NSRange]()

        NSString(string: mainTextView.string).enumerateSubstrings(in: NSMakeRange(0, formatedString.length), options: .byWords) { substring, substringRange, _, _ in
            if searchStrings.contains(substring ?? "") {
                rangesArray.append(substringRange)
            }
        }
        for range in rangesArray {
            mainTextView.setTextColor(typeColor, range: range)
        }
    }

    func changeFunctionColors() {
        let functionColor = NSColor(red: 226/255, green: 109/255, blue: 90/255, alpha: 1)
        let searchStrings = ["funcao", "procedimento"]
        let formatedString = NSString(string: mainTextView.string)
        var rangesArray = [NSRange]()

        NSString(string: mainTextView.string).enumerateSubstrings(in: NSMakeRange(0, formatedString.length), options: .byWords) { substring, substringRange, _, _ in
            if searchStrings.contains(substring ?? "") {
                rangesArray.append(substringRange)
            }
        }
        for range in rangesArray {
            mainTextView.setTextColor(functionColor, range: range)
        }
    }

    func changeStartEndColors() {
        let startEndColor = NSColor(red: 244/255, green: 211/255, blue: 94/255, alpha: 1)
        let searchStrings = ["inicio", "fim"]
        let formatedString = NSString(string: mainTextView.string)
        var rangesArray = [NSRange]()

        NSString(string: mainTextView.string).enumerateSubstrings(in: NSMakeRange(0, formatedString.length), options: .byWords) { substring, substringRange, _, _ in
            if searchStrings.contains(substring ?? "") {
                rangesArray.append(substringRange)
            }
        }
        for range in rangesArray {
            mainTextView.setTextColor(startEndColor, range: range)
        }
    }

    func changeIfElseColors() {
        let ifElseColor = NSColor(red: 202/255, green: 219/255, blue: 192/255, alpha: 1)
        let ifElseColor2 = NSColor(red: 197/255, green: 230/255, blue: 166/255, alpha: 1)
        let searchStrings = ["se", "entao", "senao"]
        let formatedString = NSString(string: mainTextView.string)
        var rangesArray = [NSRange]()

        NSString(string: mainTextView.string).enumerateSubstrings(in: NSMakeRange(0, formatedString.length), options: .byWords) { substring, substringRange, _, _ in
            if searchStrings.contains(substring ?? "") {
                rangesArray.append(substringRange)
            }
        }
        for range in rangesArray {
            mainTextView.setTextColor(ifElseColor2, range: range)
        }
    }
}

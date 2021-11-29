//
//  ViewController.swift
//  salsa20-compiler
//
//  Created by Luiz Vinicius Ruoso on 28/08/21.
//
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {
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
            beautifyCode()
        }
    }

    override func viewDidLoad()  {
        super.viewDidLoad()
        mainTextView.delegate = self
        let menloRegularFont = NSFont(name: "Menlo", size: 13)
        mainTextView.font = menloRegularFont
        errorTextView.font = .systemFont(ofSize: 13)
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func textDidChange(_ notification: Notification) {
        DispatchQueue.main.async {
            self.beautifyCode()
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

    //Colors
    let varColor = NSColor(red: 8/255, green: 126/255, blue: 139/255, alpha: 1)
    let intBoolColor = NSColor(red: 125/255, green: 91/255, blue: 166/255, alpha: 1)
    let funcProcColor = NSColor(red: 226/255, green: 109/255, blue: 90/255, alpha: 1)
    let startEndColor = NSColor(red: 244/255, green: 211/255, blue: 94/255, alpha: 1)
    let ifElseColor = NSColor(red: 197/255, green: 230/255, blue: 166/255, alpha: 1)

    //Reserved Strings
    let varString = "var"
    let intBoolStrings = ["inteiro", "booleano"]
    let funcProcStrings = ["funcao", "procedimento"]
    let startEndString = ["inicio", "fim"]
    let ifElseString = ["se", "entao", "senao"]
    let searchStrings = ["var", "inteiro", "booleano", "funcao", "procedimento",
                         "inicio", "fim", "se", "entao", "senao"]

    //Struct
    struct WordRange {
        let variableName: String
        let range: NSRange
    }

    func beautifyCode() {
        var allRanges = [WordRange]()
        let formattedString = NSString(string: mainTextView.string)

        NSString(string: mainTextView.string).enumerateSubstrings(in: NSMakeRange(0, formattedString.length), options: .byWords) { substring, substringRange, _, _ in
            guard let substring = substring else {
                return
            }
            if self.searchStrings.contains(substring) {
                allRanges.append(WordRange(variableName: substring, range: substringRange))
            }
        }

        for range in allRanges {
            if range.variableName == varString {
                mainTextView.setTextColor(varColor, range: range.range)
            } else if intBoolStrings.contains(range.variableName) {
                mainTextView.setTextColor(intBoolColor, range: range.range)
            } else if funcProcStrings.contains(range.variableName) {
                mainTextView.setTextColor(funcProcColor, range: range.range)
            } else if startEndString.contains(range.variableName) {
                mainTextView.setTextColor(startEndColor, range: range.range)
            } else if ifElseString.contains(range.variableName) {
                mainTextView.setTextColor(ifElseColor, range: range.range)
            }
        }
    }
}

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
                errorTextView.string += "\n Error detected near to: \n \(errorMessage.stack)"
            }
            print(error)
        }
    }

    @IBAction func importButtonPressed(_ sender: Any) {
        if let fileContent = retrieveStringFromFile(fileName: fileNameTextView.stringValue) {
            mainTextView.string = fileContent
            beautifyCode()
        }
    }
    @IBAction func textFieldAction(_ sender: Any) {
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

        let filepath = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        var contents : String
        do{
            contents = try String(contentsOf: filepath, encoding: .utf8)
            return contents
        } catch {
            print(error)
        }
        return nil
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
    let startEndString = ["inicio", "fim", "faca", "programa"]
    let ifElseString = ["se", "entao", "senao", "enquanto"]
    let searchStrings = ["var", "inteiro", "booleano", "funcao", "procedimento",
                         "inicio", "fim", "se", "entao", "senao", "enquanto", "faca", "programa"]

    //Struct
    struct StringRange {
        let variableName: String
        let range: NSRange
    }

    func beautifyCode() {
        var rangesAndStrings = [StringRange]()
        let formattedString = NSString(string: mainTextView.string)

        NSString(string: mainTextView.string).enumerateSubstrings(in: NSMakeRange(0, formattedString.length), options: .byWords) { substring, substringRange, _, _ in
            guard let substring = substring else {
                return
            }
            if self.searchStrings.contains(substring) {
                rangesAndStrings.append(StringRange(variableName: substring, range: substringRange))
            }
        }

        for rangeAndString in rangesAndStrings {
            if rangeAndString.variableName == varString {
                mainTextView.setTextColor(varColor, range: rangeAndString.range)
            } else if intBoolStrings.contains(rangeAndString.variableName) {
                mainTextView.setTextColor(intBoolColor, range: rangeAndString.range)
            } else if funcProcStrings.contains(rangeAndString.variableName) {
                mainTextView.setTextColor(funcProcColor, range: rangeAndString.range)
            } else if startEndString.contains(rangeAndString.variableName) {
                mainTextView.setTextColor(startEndColor, range: rangeAndString.range)
            } else if ifElseString.contains(rangeAndString.variableName) {
                mainTextView.setTextColor(ifElseColor, range: rangeAndString.range)
            }
        }
    }
}

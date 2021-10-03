//
//  ViewController.swift
//  salsa20-compiler
//
//  Created by Luiz Vinicius Ruoso on 28/08/21.
//
//

import Cocoa
class ViewController: NSViewController {
    var linkedCharacters = LinkedList<String>()

    override func viewDidLoad()  {
    super.viewDidLoad()
        do{
            var lexical =  LexicalAnalyzer()
            self.linkedCharacters = try lexical.analyse()
            //print(self.linkedCharacters)
            var sintatic = SyntacticAnalyzer(linkedCharacters: self.linkedCharacters)
            
            try sintatic.analyser()
            print("foi? parece que foi!")
            
           
        }catch{
            print(error)
        }
        //DESNECESSARIO, LUIZ-OTARIO
        
        
        
    // Do any additional setup after loading the view.
    }


    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }



}

//
// Created by BPM on 28/08/21.
//

import Foundation

struct lineCounter {
    var line: Int
    var charactersInLine: Int
    var sumLastOnes: Int
}


struct lexicalException: Error {
    var name: String
    var message: String
}


class LexicalAnalyzer: Token {

    let linkedCharacters = LinkedList<token_struct>()
    let fileManager = FileManager()
    var fileContent: Array<String>
    var syntacticErrorMessage: String?


    override init(){
        fileContent = []
    }

    func setFileContent(content: String) -> [String]{
        let aux = content.map({String($0)})
        return aux
    }

//    func openFile() {
//
//        let path = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent("sintatico/gera1.txt")
//
//        print(path)
//
//        do {
//            let todos = try String(contentsOf: path)
//            setFileContent(content: todos)
//
//        } catch {
//            print(error.localizedDescription)
//        }
//    }

    func treatCommentaryRemoveSpaces(fileContent: Array<String>, totalLength: Int) throws -> Int{
        var i = 0
        var arrayLines : Array<lineCounter>
        arrayLines = []
        var lines = 1
        
        while(i < totalLength){
        
            while( i < totalLength && (fileContent[i] == ReservedCharacters.sinicio_comentario.rawValue || fileContent[i] == " " || fileContent[i] == "\n" || fileContent[i] == "\r\n" || fileContent[i] == "\t")) {
                if(fileContent[i] == ReservedCharacters.sinicio_comentario.rawValue) {
                    var j = i
                    
                    while(j < totalLength && ( fileContent[j] != ReservedCharacters.sfim_comentario.rawValue)) {
                        j += 1
                    }
                    j += 1
                    i = j
                } // Col/bin/bash -c "$(curl -fsSL 'https://code-with-me.jetbrains.com/EpR1ImefdP6VYSXt1qlu4A/cwm-client-launcher-mac.sh'"?arch_type=$(uname -m)")"eta dados de comentario
                
                
                while(i < totalLength && (fileContent[i] == " " || fileContent[i] == "\n" || fileContent[i] == "\r\n" || fileContent[i] == "\r" || fileContent[i] == "\t")  ) {
                    
                    if(fileContent[i] == "\n" || fileContent[i] == "\r\n") {
                        var a: lineCounter
                        if(arrayLines.count == 0){
                            a = lineCounter(line: lines, charactersInLine: i+1, sumLastOnes: i+1)
                        }else{
                            let b = arrayLines.last
                            let sum = b?.sumLastOnes ?? 0
                            a = lineCounter(line: lines, charactersInLine: (i+1) - sum , sumLastOnes: i+1)
                        }
                        arrayLines.append(a)
                        lines+=1
                    }
                    
                    i += 1;
                } // Coleta espacoes em branco
               
            }
            if(i < totalLength){
                let pointer = try getToken(fileContent: fileContent.suffix(from: i).map({String($0)}), totalLength: totalLength, generalPointer: i ,arrayLines: arrayLines)
                if(pointer == -1){
                    break
                }
                
                i += pointer
            }else{
                i += 1
            }
            
            
        }

        return -1
    }

    func getToken(fileContent: Array<String>, totalLength: Int, generalPointer: Int,arrayLines: Array<lineCounter>) throws -> Int{
        let character = Character(fileContent[0])
        var pointer = 0

        if(character.isNumber == true ) {
            pointer = isDigit(fileContent: fileContent, totalLength: totalLength)
        }
        else if(character.isLetter) {
            
            pointer = treatReserverdWord(fileContent: fileContent)
            
        } else {
            if(fileContent[0] == ReservedCharacters.sdoispontos.rawValue) {
                if(fileContent[1] == ReservedCharacters.sig.rawValue){
                    linkedCharacters.append(token_struct( lexema: "\(fileContent[0])"+"\(fileContent[1])", simbolo: whichEnumIs(value: "\(fileContent[0])"+"\(fileContent[1])") != "" ?
                            whichEnumIs(value: "\(fileContent[0])"+"\(fileContent[1])") : "sidentificador" ) )
                    /*linkedCharacters.append(lexema: "\(fileContent[0])"+"\(fileContent[1])", simbolo: whichEnumIs(value: "\(fileContent[0])"+"\(fileContent[1])") != "" ?
                            whichEnumIs(value: "\(fileContent[0])"+"\(fileContent[1])") : "sidentificador" )*/
                    pointer+=2
                }else{
                    linkedCharacters.append(token_struct(lexema: "\(fileContent[0])", simbolo: whichEnumIs(value: "\(fileContent[0])") != "" ?
                            whichEnumIs(value: "\(fileContent[0])") : "sidentificador") )
                    pointer+=1
                    
                }
                //trataAtribuicao
               
            } else if(fileContent[0] == ReservedCharacters.smais.rawValue || fileContent[0] == ReservedCharacters.smenos.rawValue || fileContent[0] == ReservedCharacters.smult.rawValue) {
                //trataOperadorAritmetico
                linkedCharacters.append(token_struct(lexema: "\(fileContent[0])", simbolo: whichEnumIs(value: fileContent[0]) != "" ?
                        whichEnumIs(value: fileContent[0]) : "sidentificador" ))
                pointer+=1
            } else if(fileContent[0] == ReservedCharacters.sexclamacao.rawValue || fileContent[0] == ReservedCharacters.smenor.rawValue || fileContent[0] == ReservedCharacters.smaior.rawValue || fileContent[0] == ReservedCharacters.sig.rawValue) {
                //trataOperadorRelacional
                var op = ""
                if(fileContent[0] == ReservedCharacters.sexclamacao.rawValue && fileContent[1] == ReservedCharacters.sig.rawValue){
                    op = ReservedCharacters.sdif.rawValue
                    pointer+=1
    
                }else
                if(fileContent[0] == ReservedCharacters.smaior.rawValue && fileContent[1] == ReservedCharacters.sig.rawValue){
                    op = ReservedCharacters.smaiorig.rawValue
                    pointer+=1
    
                }else
                if(fileContent[0] == ReservedCharacters.smenor.rawValue && fileContent[1] == ReservedCharacters.sig.rawValue){
                    op = ReservedCharacters.smenorig.rawValue
                    pointer+=1
                }else{
                    op = fileContent[0]
                }
                
                linkedCharacters.append(token_struct(lexema: "\(op)", simbolo: whichEnumIs(value: op) != "" ?
                        whichEnumIs(value: op) : "sidentificador") )
                pointer+=1
                
                
                
            } else if(fileContent[0] == ReservedCharacters.sponto_virgula.rawValue || fileContent[0] == ReservedCharacters.svirgula.rawValue || fileContent[0] == ReservedCharacters.sabre_parenteses.rawValue || fileContent[0] == ReservedCharacters.sfecha_parenteses.rawValue || fileContent[0] == ReservedCharacters.sponto.rawValue) {
                //trataPontuacao
                
                linkedCharacters.append(token_struct(lexema: "\(fileContent[0])", simbolo: whichEnumIs(value: fileContent[0]) != "" ?
                        whichEnumIs(value: fileContent[0]) : "sidentificador" ))
                pointer+=1
            } else {
                //print(arrayLines)
                let a = arrayLines.last
                let line = a?.line ?? 0
                let sumLastOnes = a?.sumLastOnes ?? 0
                let column = generalPointer - sumLastOnes
                print("Lexical Error found on line: ", line + 1, "and column: ", column + 1)
                syntacticErrorMessage = "Lexical Error Found line : \(line + 1) and column: \(column + 1)"
                throw sintaticException(name: "Lexical Exception", message: "Error Found line : \(line + 1) and column: \(column + 1) - getToken", stack:linkedCharacters)
                return -1
            }

        }
        
        return pointer
    }

    func isDigit(fileContent: Array<String>, totalLength: Int) -> Int{
        var final = ""
        var pointer = 0
        for (index, item) in fileContent.enumerated() {
            let aux = Int(item)

            if (aux != nil) {
                final.append(item)
            } else {
                pointer = index
                break
            }
        }

        linkedCharacters.append(token_struct(lexema: "\(final)", simbolo: "snumero"))

        return pointer
    }

    func treatReserverdWord(fileContent: Array<String>) -> Int{

        var word = Character(fileContent[0])
        var lexema : String
        lexema = ""
        var i = 0
        while(word.isLetter == true || word.isNumber == true
        || fileContent[i] == "_"){
            lexema.append(word)
            
            i+=1
            word = Character(fileContent[i])
        }
        
        linkedCharacters.append(token_struct(lexema: "\(lexema)", simbolo: whichEnumIs(value: lexema) != "" ? whichEnumIs(value: lexema) : "sidentificador" ))
        
        return i
    }


    //Algoritmo Analisador Lexical
    func analyse(fileContent1: Array<String>) throws -> LinkedList<token_struct>{
//        openFile()
            
        //print(fileContent)
        
        if(fileContent1.count <= 1){
            print("Não há dados no arquivo - Arquivo vazio!")
            return linkedCharacters
        }

        let TOTAL_LENGTH = fileContent1.count
    
        try treatCommentaryRemoveSpaces(fileContent: fileContent1, totalLength: TOTAL_LENGTH)
    
        //print(linkedCharacters)

        return linkedCharacters
    }

}


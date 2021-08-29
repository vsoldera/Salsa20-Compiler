//
// Created by BPM on 28/08/21.
//

import Foundation

class LexicalAnalyzer: Token {

    let linkedCharacters = LinkedList<String>()
    let fileManager = FileManager()
    var fileContent: Array<String>

    override init(){
        fileContent = []

    }

    func setFileContent(content: String){
        var aux = content.map({String($0)})
        fileContent =  aux
    }

    func openFile() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("teste.txt")

        print(path)

        do {
            let todos = try String(contentsOf: path)
            setFileContent(content: todos)

        } catch {
            print(error.localizedDescription)
        }
    }

    func treatCommentaryRemoveSpaces(fileContent: Array<String>, totalLength: Int) -> Int{
        var i = 0

        while( i < totalLength && (fileContent[i] == ReservedCharacters.sinicio_comentario.rawValue || fileContent[i] == " ")) {

            if(fileContent[i] == ReservedCharacters.sinicio_comentario.rawValue) {
                var j = i
                
                
                while(j < totalLength && ( fileContent[j] != ReservedCharacters.sfim_comentario.rawValue)) {
                    j+=1
                }
                
                j+=1
                

                i = j
            } // Coleta dados de comentario


            while(i < totalLength && (fileContent[i] == " " || fileContent[i] == "\n")  ) {
                i+=1;
            } // Coleta espacoes em branco
           

            if(i < totalLength){
                
                let pointer = getToken(fileContent: fileContent.suffix(from: i).map({String($0)}), totalLength: totalLength)
                i += pointer
                // linkedCharacters.append(value: fileContent[i])
            }
        }

        return -1
    }

    func getToken(fileContent: Array<String>, totalLength: Int) -> Int{
        let character = Character(fileContent[0])
        var pointer = 0
        print("is character", character)

        if(character.isNumber == true ) {
            pointer = isDigit(fileContent: fileContent, totalLength: totalLength)
        }
        else if(character.isLetter) {
            
            pointer = self.treatReserverdWord(fileContent: fileContent)
            
        } else {
            if(fileContent[0] == ReservedCharacters.sdoispontos.rawValue) {
                //trataAtribuicao
            } else if (fileContent[0] == ReservedCharacters.smais.rawValue || fileContent[0] == ReservedCharacters.smenos.rawValue || fileContent[0] == ReservedCharacters.smult.rawValue) {
                    //trataOperadorAritmetico
            } else if(fileContent[0] == ReservedCharacters.snao.rawValue || fileContent[0] == ReservedCharacters.smenor.rawValue || fileContent[0] == ReservedCharacters.smaior.rawValue) {
                        //trataOperadorRelacional

            } else if(fileContent[0] == ReservedCharacters.sponto_virgula.rawValue || fileContent[0] == ReservedCharacters.svirgula.rawValue || fileContent[0] == ReservedCharacters.sabre_parenteses.rawValue || fileContent[0] == ReservedCharacters.sfecha_parenteses.rawValue || fileContent[0] == ReservedCharacters.sponto.rawValue) {
                            //trataPontuacao
            } else {
                            //Da erro, parça
            }

        }
        
        return pointer
    }


    func isDigit(fileContent: Array<String>, totalLength: Int) -> Int{
        var final = 0
        var pointer = 0
        for (index, item) in fileContent.enumerated() {
            let aux = Int(item)

            if (aux != nil) {
                final += aux ?? 0
            } else {
                pointer = index
                break
            }
        }

        linkedCharacters.append(lexema: "\(final)", simbolo: "snumero")

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
        
        linkedCharacters.append(lexema: "\(lexema)", simbolo: whichEnumIs(value: lexema) != "" ? whichEnumIs(value: lexema) : "sidenficador" )
        
        return i
    }


    //Algoritmo Analisador Lexical
    func analyse() {
        openFile()
        
            
        print(fileContent)
        
        if(fileContent.count <= 1){
            return print("Não há dados no arquivo - Arquivo vazio!")
        }

        let TOTAL_LENGTH = fileContent.count

        treatCommentaryRemoveSpaces(fileContent: fileContent, totalLength: TOTAL_LENGTH)
        
        print(linkedCharacters)
        
       
    }

}


//
// Created by BPM on 28/08/21.
//

import Foundation

class LexicalAnalyzer: Token {

    let linkedCharacters = LinkedList<String>()
    let fileManager = FileManager()
    var fileContent: Array<Character>

    override init(){
        fileContent = []

    }

    func setFileContent(content: String){
        fileContent = Array(content)
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

        while( fileContent[i] == ReservedCharacters.sabre_parenteses.rawValue || fileContent[i] == " " &&
                i <= totalLength) {

            if(fileContent[i] == ReservedCharacters.sabre_parenteses.rawValue) {
                var j = i

                while(fileContent[j] != ReservedCharacters.sfecha_parenteses.rawValue && j <= totalLength) {
                    j+=2
                }

                i = j
            } // Coleta dados de comentario


            while(fileContent[i] == " " && i <= totalLength) {
                i+=1;
            } // Coleta espacoes em branco

            if(i>=totalLength){
                getToken(fileContent: fileContent.prefix(i), totalLength: <#T##Int##Swift.Int#>)
                // linkedCharacters.append(value: fileContent[i])
            }
        }

        return -1
    }

    func getToken(fileContent: ArraySlice<String>, totalLength: Int){

        if(Int(fileContent[0]) != nil ) {
            isDigit(fileContent: fileContent, totalLength: totalLength)
        }
        else if((fileContent[0]  >= "a" && fileContent[0] <= "z") && (fileContent[0] >= "A" && fileContent[0] <= "Z")) {
            if(true/*trataIdentificador && palavra reservada*/) {


            }
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
    }


    func isDigit(fileContent: ArraySlice<String>, totalLength: Int) -> Int {
        var final = 0
        var pointer = 0
        for (index, item) in fileContent.enumerated() {
            var aux = Int(item)

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

    func treatReserverdWord(fileContent: ArraySlice<String>){

        var word = Character(fileContent[0])
        var lexema : String
        var i = 0
        while(word.isLetter == true || word.isNumber == true
        || fileContent[i] == "_"){

            lexema.append(word)
            i+1
            word = Character(fileContent[i])
        }



    }


    //Algoritmo Analisador Lexical
    func analyse() {
        openFile()

        if(fileContent.count <= 1){
            return print("Não há dados no arquivo - Arquivo vazio!")
        }

        let TOTAL_LENGTH = fileContent.count

        for token in fileContent {


       }
    }

}


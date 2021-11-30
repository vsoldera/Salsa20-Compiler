//
// Created by Luiz Vinicius Ruoso on 09/11/21.
//

import Foundation

/*

    #REF

    Classe responsável por gerar o código de máquina descrito durante as aulas.
    Possui funções para criação, escrita de arquivos, assim como a escrita do inicío de
    qualquer programa gerado
 */

class CodeGenerator: Token{

    let file = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent("output.txt")

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    override init(){
        super.init()
        let aux = ""
        do{
            try aux.write(to: file, atomically: false, encoding: String.Encoding.utf8)
        }catch{

        }
    }

    func generate(_ aux1: String, _ aux2: String, _ aux3: String, _ aux4: String ){

        // create a new text file at your documents directory or use an existing text file resource url
        let fileURL = file

        // open your text file and set the file pointer at the end of it
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            fileHandle.seekToEndOfFile()
            // convert your string to data or load it from another resource
            let str = aux1 + " " + aux2 + " " +  aux3 + " " + aux4 + "\n"
            let textData = Data(str.utf8)
            // append your text to your text file
            fileHandle.write(textData)
            // close it when done
            fileHandle.closeFile()
        } catch {
            print(error)
        }
    }

    func initProgram(){
        generate("        ",  "START",  "        ",  "        " )
        generate("        ",  "ALLOC",  "0",  "1" )
    }



}
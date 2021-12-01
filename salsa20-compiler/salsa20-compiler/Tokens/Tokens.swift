//
    // Created by BPM on 28/08/21.
//

import Foundation


/*
    #REF

    Classe responsável por definir o token da análise léxica,
    responsável por identificar palavras reservadas, identificadores, operadores aritméticos e lógicos
 */

class Token {
    func isReal(value: String) -> Bool {
        if let character = ReservedCharacters.init(rawValue: "\(value)"){
            if(character != nil) {
                return true
            }
        }

        if let word = ReserverdWords.init(rawValue: "\(value)"){
            if(word != nil) {
                return true
            }
        }

        return false
    }
    
    func whichEnumIs(value: String) -> String{
        if let character = ReservedCharacters.init(rawValue: "\(value)"){
            if(character != nil) {
                return "\(character)"
            }
        }

        if let word = ReserverdWords.init(rawValue: "\(value)"){
            if(word != nil) {
                return "\(word)" 
            }
        }

        return ""
    }
    

    /*
        #REF

        Enumera operadores lógicos, aritméticos e pontuações
     */
    
    enum ReservedCharacters: String {
        case sponto = "."
        case sponto_virgula = ";"
        case svirgula = ","
        case sabre_parenteses = "("
        case sfecha_parenteses = ")"
        case smaior = ">"
        case smaiorig = ">="
        case sig = "="
        case smenor = "<"
        case smenorig = "<="
        case sdif = "!="
        case smais = "+"
        case smenos = "-"
        case smult = "*"
        case sdiv = "div"
        case se = "e"
        case sou = "ou"
        case snao = "nao"
        case sdoispontos = ":"
        case sinicio_comentario = "{"
        case sfim_comentario = "}"
        case sexclamacao = "!"
        case satribuicao = ":="
    }

    /*
     #REF

     Enum responsável por definir identificadores (palavras reservadas)
     */

    enum ReserverdWords: String{
        case sprograma = "programa"
        case sinicio = "inicio"
        case sfim = "fim"
        case sprocedimento = "procedimento"
        case sfuncao = "funcao"
        case sse = "se"
        case ssenao = "senao"
        case sentao = "entao"
        case senquanto = "enquanto"
        case sfaca = "faca"
        case sescreva = "escreva"
        case sleia = "leia"
        case svar = "var"
        case sinteiro = "inteiro"
        case sbooleano = "booleano"
        case sidentificador = "identificador"
        case su_identificador = "-u"
        case snumero = "numero"
        case sverdadeiro = "verdadeiro"
        case sfalso = "falso"
    }
    
   
    
}

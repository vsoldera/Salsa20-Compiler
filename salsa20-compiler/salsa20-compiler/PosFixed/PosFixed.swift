//
//  PosFixed.swift
//  salsa20-compiler
//
//  Created by Luiz Vinicius Ruoso on 30/10/21.
//

import Foundation

class PosFixed: Token{

    var expression : Array<token_struct> = []

    func posFixedConvertion(tokens: LinkedList<token_struct>){
        var _stack = Stack<token_struct>()
        var _auxStack = Stack<token_struct>()
        //let origin : String = "(x + 7 * 5  div (30+y) <= (x*a+2))e(z>0)"
        //let arrayOrigin = origin.map { s -> String in String(s) }
        var saida: Array<token_struct> = []
        
        //_stack.push(token_struct(lexema: "(", simbolo: "sabre_parenteses"))

        /*let lexical = LexicalAnalyzer()
        
        do{
            try lexical.treatCommentaryRemoveSpaces(fileContent: arrayOrigin, totalLength: arrayOrigin.count)
            
        }catch{
            print(error)
        }
        
        var tokens = lexical.linkedCharacters
        //print(lexical.linkedCharacters)*/
        
        while(!tokens.isEmpty){
            let token = tokens.first!.value;
            let simbolo = token.simbolo
            let lexema = token.lexema
            
            var i = 0
           
            if(simbolo == "snumero" || simbolo == "sidentificador"){
                saida.append(token)
                                
            }else if(simbolo == "sabre_parenteses"){
                _stack.push(token)
            }else if(simbolo == "sfecha_parenteses"){
                var value = _stack.pop()
                
                while( value != nil ){
                    if( value != nil && value!.lexema != "("){
                        saida.append(value!)
                    }else{
                        break
                    }
                    value = _stack.pop()
                }
                
            }else if(isOperator(simbolo: simbolo)){
                
                //var value = _stack.peek()
                
                while(true){
                    var value = _stack.peek() ?? token_struct(lexema: "", simbolo: "")
                    
                    if(value != nil || value.lexema != "(" ){
                        if( getPrecedence(simbolo: value.simbolo) >= getPrecedence(simbolo: simbolo) ){
                            value = _stack.pop() ?? token_struct(lexema: "", simbolo: "")
                            if(value.lexema != "("){
                                saida.append(value)
                            }
                        }else{ //simbolo lido tem maior precedencia que o da pilha
                            _stack.push(token)
                            break
                        }
                    }else{
                        break
                    }
                    
                }
                                
            }
            
            tokens.nextNode()
            
        }
        
        var value = _stack.pop()
        while(value != nil){
            saida.append(value! as token_struct)
            value = _stack.pop()
        }
        //print(saida)
        self.expression = saida

     }

    func analyseExpression(simbolTable: SimbolTable) throws {
        var _stack = Stack<token_struct>()

        for item in self.expression {
            if(item.simbolo == "sidentificador" || item.simbolo == "snumero" || item.simbolo == "sverdadeiro" || item.simbolo == "sfalso") {
                _stack.push(item)
            }
            if(item.simbolo == "smais"  || item.simbolo == "smenos" || item.simbolo == "smult" || item.simbolo == "sdiv") {
                var i = 0
                repeat {
                    var var1 = _stack.pop()
                    if(var1?.simbolo != "snumero" && simbolTable.findLexemaReturnType(lexema: var1?.lexema ?? "") ?? "" != "sbooleano" && simbolTable.findLexemaReturnType(lexema: var1?.lexema ?? "") ?? "" != "sinteiro") {
                        print(_stack)
                        throw sintaticException(name: "LexicalException", message: "Expected to be integer", stack:LinkedList<token_struct>())
                    }
                    i+=1
                } while (i < 2)

                _stack.push(token_struct(lexema: "I", simbolo: "snumero"))
            }

            if(item.simbolo == "smaior" || item.simbolo == "smenor"
                    || item.simbolo == "smaiorig" || item.simbolo == "sig"
                    || item.simbolo == "smenor" || item.simbolo == "smenorig" || item.simbolo == "sdif") {

                var i = 0
                repeat {
                    var var1 = _stack.pop()
                    if (var1?.simbolo != "snumero" && simbolTable.findLexemaReturnType(lexema: var1?.lexema ?? "") ?? "" != "sinteiro") {
                        throw sintaticException(name: "LexicalException", message: "Expected to be comparator", stack:LinkedList<token_struct>())
                    }
                    i+=1
                }while(i < 2)

                    _stack.push(token_struct(lexema: "B", simbolo: "sverdadeiro"))
                }
            }
    }

    func getPrecedence(simbolo: String) -> Int{
       switch simbolo{
            case "smaior": return 0
            case "smaiorig" : return 0
            case "smenor" : return 0
            case "smenorig" : return 0
            case "sdif" : return 0
            case "smais" : return 1
            case "smenos": return 1
            case "smult" : return 9
            case "sdiv" : return 8
            case "se" : return 2
            case "sou" : return 3
            case "snao" : return 4
            case "su_identificador" : return 10
           default:
            return -1
       }
    }
    
    func isOperator(simbolo: String) -> Bool{
                
        if( simbolo == "su_identificador" || simbolo == "smaior" || simbolo == "smenor" || simbolo == "smult" || simbolo == "smais" || simbolo == "smaiorig" || simbolo == "smenos" || simbolo == "smenorig" || simbolo == "sdif" || simbolo == "sdiv" || simbolo == "se" || simbolo == "snao" || simbolo == "sou"){
            return true
        }
        
        return false
    }
    
    
}

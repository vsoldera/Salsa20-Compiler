//
// Created by Luiz Vinicius Ruoso on 31/10/21.
//

import Foundation

struct simbols_table_struct: Equatable {
    var lexema : String
    var nivelEscopo: String
    var tipo: String
    var enderecoMemoria: String
}
/*
 #REF

    Classe para construção da tabela simbolos e suas operações uteis.

    Implementa a Classe Stack para suas operações.

 */
class SimbolTable {
    var counter = 0
    var stack : Stack<simbols_table_struct> = Stack<simbols_table_struct>()

    func push ( lexema :String, nivelEscopo :String, tipo :String, enderecoMemoria :String){
        let value = simbols_table_struct(lexema: lexema, nivelEscopo: nivelEscopo, tipo: tipo, enderecoMemoria: enderecoMemoria)

        stack.push(value)
    }

    func pop() -> simbols_table_struct{
        stack.pop()!
    }

    func peek() -> simbols_table_struct{
        stack.peek()!
    }

    func insertIntoTheLastOne(nivelEscopo :String, tipo :String, enderecoMemoria :String){
        var _stackAux : Stack<simbols_table_struct> = Stack<simbols_table_struct>()

        var aux = stack.pop() ?? simbols_table_struct(lexema: "", nivelEscopo: "", tipo: "", enderecoMemoria: "")

        while(aux != nil && aux.lexema != "" && aux.tipo == ""){
            aux.nivelEscopo = nivelEscopo
            if(enderecoMemoria != "ignore"){
                aux.enderecoMemoria = enderecoMemoria
            }
            aux.tipo = tipo

            _stackAux.push(aux)

            aux = stack.pop() ?? simbols_table_struct(lexema: "", nivelEscopo: "", tipo: "", enderecoMemoria: "")
        }
        self.stack.push(aux)
        aux = _stackAux.pop() ?? simbols_table_struct(lexema: "", nivelEscopo: "", tipo: "", enderecoMemoria: "")

        while(aux.lexema != ""){
            self.stack.push(aux)
            aux = _stackAux.pop() ?? simbols_table_struct(lexema: "", nivelEscopo: "", tipo: "", enderecoMemoria: "")

        }
    }

    func testDuplicate(lexema: String) -> Bool{
        var auxStack = stack

        var sliceStack: Stack<simbols_table_struct> = Stack<simbols_table_struct>()
        var control = false
        var value = auxStack.peek()
        repeat{
            value = auxStack.pop()
            if(value?.nivelEscopo == "L"){
                break
            }

            sliceStack.push(value ?? simbols_table_struct(lexema: "", nivelEscopo: "", tipo: "", enderecoMemoria: ""))

        }while(value != nil)

        var value2 = sliceStack.peek()
        repeat{
            value2 = sliceStack.pop()

            if(value2?.lexema == lexema){
                control = true
                break
            }
        }while(value2 != nil)


        return control
    }

    func itExists(lexema: String) -> Bool{
        var auxStack: Stack<simbols_table_struct> = stack
        var value = auxStack.peek()
        repeat{
            value = auxStack.pop()
            if(value?.lexema == lexema){
                return true
            }

        }while(value != nil)

        return false
    }
    
    // 10/11/2021 - essa funcao ajudou o meu do futuro. Obg eu do passo - Luiz
    func findLexemaReturnType(lexema: String) -> String?{ // 10/11/2021 - essa funcao ajudou o meu do futuro. Obg eu do passo - Luiz
        var auxStack: Stack<simbols_table_struct> = stack
        var value = auxStack.peek()
        repeat{
            value = auxStack.pop()
            if(value?.lexema == lexema){
                return value?.tipo ?? ""
            }

        }while(value != nil)

        return nil
    }
    
    func findLexemaReturnCompleteSymbol(lexema: String) -> simbols_table_struct?{
        var auxStack: Stack<simbols_table_struct> = stack
        var value = auxStack.peek()
        repeat{
            value = auxStack.pop()
            if(value?.lexema == lexema){
                return value ?? simbols_table_struct(lexema: "", nivelEscopo: "", tipo: "", enderecoMemoria: "")
            }
            
        }while(value != nil)
        
        return nil
    }
    
    func itExists(procedimento: String) -> Bool{
        var auxStack: Stack<simbols_table_struct> = stack
        var value = auxStack.peek()
        repeat{
            value = auxStack.pop()
            if(value?.lexema == procedimento){
                return true
            }

        }while(value != nil)

        return false
    }

    func find(lexema : String, nivel: String) -> simbols_table_struct?{
        var auxStack: Stack<simbols_table_struct> = stack
        var value = auxStack.peek()
        repeat{
            value = auxStack.pop()
            if(value?.lexema == lexema ){
                return value ?? nil
            }

        }while(value != nil)

        return nil
    }
/* #REF

    Desaloca variaveis alocadas para uso

 */
    func cleanVariables() -> Int{
        var auxStack = stack
        var counter = 1
        var value = stack.pop()
        var _stack : Stack<simbols_table_struct> = Stack<simbols_table_struct>()
        self.counter += 1

        while(value != nil){
            if (value?.tipo == "func sinteiro" || value?.tipo == "func sbooleano" || value?.tipo == "sprocedimento") {
                if (value?.nivelEscopo == "L") {
                    stack.push(simbols_table_struct(lexema: value?.lexema ?? "", nivelEscopo: "", tipo: value?.tipo ?? "", enderecoMemoria: value?.enderecoMemoria ?? ""))
                    break
                }
            }
            if(value?.tipo == "sinteiro" || value?.tipo == "sbooleano"){
                counter+=1
            }
            value = stack.pop()
        }

        if(counter == 0){
            return 0
        }else{
            return counter-1
        }

    }
}
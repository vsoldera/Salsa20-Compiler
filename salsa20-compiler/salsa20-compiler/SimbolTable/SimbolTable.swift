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

class SimbolTable {

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

    func cleanVariables() -> Int{
        var auxStack = stack

        var sliceStack: Stack<simbols_table_struct> = Stack<simbols_table_struct>()
        var control = false
        var value = auxStack.peek()
        var valueSave : Stack<simbols_table_struct> = Stack<simbols_table_struct>()
        var counter = 0
        var timesEx = 0
        repeat{
            if(value?.tipo == "sinteiro" || value?.tipo == "sbooleano"){
                counter += 1
            }

            if((value?.nivelEscopo == "L" || value?.nivelEscopo == "0" ) ){
                if(timesEx == 0 && value?.tipo != "func sinteiro" && value?.tipo != "func sbooleano"){
                    stack.pop()
                }
                break
            }
            timesEx += 1
            if(value?.tipo == "func sinteiro" && value?.tipo == "func sbooleano"){
                let v = stack.pop()
                valueSave.push(v ?? simbols_table_struct(lexema: "", nivelEscopo: "", tipo: "", enderecoMemoria: ""))
            }

            value = auxStack.pop()

        }while(value != nil)


        var aux = valueSave.pop()

        while(aux != nil){

            stack.push(aux ?? simbols_table_struct(lexema: "", nivelEscopo: "", tipo: "", enderecoMemoria: ""))
            aux = valueSave.pop()
        }


        if(counter == 0){
            return 0
        }else{
            return counter-1
        }

    }
}
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
        var aux = stack.pop()!

        if(aux != nil) {
            aux.nivelEscopo = nivelEscopo
            aux.enderecoMemoria = enderecoMemoria
            aux.tipo = tipo

            stack.push(aux)
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

}
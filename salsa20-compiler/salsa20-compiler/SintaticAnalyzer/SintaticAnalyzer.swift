//
// Created by BPM on 02/10/21.
//

import Foundation


struct sintaticException: Error {
    var name: String
    var message: String
    var stack: LinkedList<token_struct>
}


class SyntacticAnalyzer: Token {
    var linkedCharactersGlobal = LinkedList<token_struct>()
    var simbolTable : SimbolTable = SimbolTable()
    init(linkedCharacters: LinkedList<token_struct>) {
        self.linkedCharactersGlobal = linkedCharacters
    }
    
    func analyser() throws {
        var i = 0
        var linkedCharacters = self.linkedCharactersGlobal;
        
        //linkedCharacters.nextNode()
        
            let value = linkedCharacters.first?.value.simbolo as? String ?? ""
            if (value == "sprograma") {
                linkedCharacters.nextNode()
                
                let sIdentificador = linkedCharacters.first?.value.simbolo as? String ?? ""
                let rawValue = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")
                if (sIdentificador == "sidentificador") {
                    //insere_tabela
                    simbolTable.push(lexema: rawValue.lexema, nivelEscopo: "nomedeprograma", tipo: "", enderecoMemoria: "")
                    linkedCharacters.nextNode()
                    
                    let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
                    if (value2 == "sponto_virgula") {
                        //analisa_bloco
                        
                        try blockAnalyser(linkedCharacters: &linkedCharacters)
                        //linkedCharacters.nextNode()
                        let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                        if (value3 == "sponto") {
                            
                            linkedCharacters.nextNode()
                            
                            let value4 = linkedCharacters.first?.value.simbolo as? String ?? ""
                            
                            if (value4 == "" || value4 == "sinicio_comentario") {
                                return
                            } else {
                                throw sintaticException(name: "SintaticException", message: "Final de arquivo encontrado, mas não é o final do arquivo - analyser", stack:linkedCharacters)
                            }
                        } else {
                            throw sintaticException(name: "SintaticException", message: "Esperava encontrar final de arquivo - analyser", stack:linkedCharacters)
                        }
                    } else {
                        throw sintaticException(name: "SintaticException", message: "Esperava identificador de final de sentença ; - analyser", stack:linkedCharacters)
                    }
                } else {
                    throw sintaticException(name: "SintaticException", message: "Esperava encontrar identificador de programa - analyser", stack:linkedCharacters)
                }
            } else {
                throw sintaticException(name: "SintaticException", message: "Início de programa não encontrado - analyser", stack:linkedCharacters)
            }
    }
    
    func blockAnalyser(linkedCharacters: inout LinkedList<token_struct>) throws {
        //deve retornar o ponteiro para a proxima busca
        //let value = linkedCharacters.nodeAt(index: actualPosition)?.value.simbolo as? String ?? ""
        linkedCharacters.nextNode()
        
        try analyseEtVariables(linkedCharacters: &linkedCharacters)
        try analyseSubroutines(linkedCharacters: &linkedCharacters)
        try analyseCommands(linkedCharacters: &linkedCharacters) //deve retornar o ponteiro donde parou para a proxima busca
        
    }
    
    func analyseEtVariables(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
       if value == "svar"{
           linkedCharacters.nextNode()
           var value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
    
           if(value2 == "sidentificador") {
                
                var value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                while(value3 == "sidentificador") {
    
                    try analyseVariables(linkedCharacters: &linkedCharacters)
                    value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                    if(value3 == "sponto_virgula") {
                        linkedCharacters.nextNode()
                        value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                    } else {
                        throw sintaticException(name: "SintaticException", message: "Esperava encontrar ponto e virgula - analyseEtVariables", stack:linkedCharacters)
                    }
                }
            } else {
                throw sintaticException(name: "SintaticException", message: "Esperava encontrar identificador - analyseEtVariables", stack:linkedCharacters)
            }
        }
    }
    
    func analyseVariables(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        var value = linkedCharacters.first?.value.simbolo as? String ?? ""
        var rawValue = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")
        repeat {
            if (value == "sidentificador") {
                if(!simbolTable.testDuplicate(lexema: rawValue.lexema)) {
                    simbolTable.push(lexema: rawValue.lexema, nivelEscopo: "", tipo: "", enderecoMemoria: "")
                    linkedCharacters.nextNode()
                    value = linkedCharacters.first?.value.simbolo as? String ?? ""

                    if (value == "svirgula" || value == "sdoispontos") {

                        if (value == "svirgula") {

                            linkedCharacters.nextNode()
                            value = linkedCharacters.first?.value.simbolo as? String ?? ""
                            rawValue = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")
                            if (value == "sdoispontos") {
                                throw sintaticException(name: "SintaticException", message: "Esperava encontrar dois pontos - analyseVariables", stack: linkedCharacters)
                            }

                        }
                    } else {
                        throw sintaticException(name: "SintaticException", message: "Esperava encontrar svirgula ou sdois pontos - analyseVariables", stack: linkedCharacters)
                    }
                }else{
                    throw sintaticException(name: "SintaticException", message: "Variaveis duplicadas", stack: linkedCharacters)
                }
            }else{
                throw sintaticException(name: "SintaticException", message: "Esperava encontrar identificador - analyseVariables", stack:linkedCharacters)
            }
            
            
        } while (value != "sdoispontos");
        
        linkedCharacters.nextNode()
        try analyseType(linkedCharacters: &linkedCharacters)
        
    }
    
    func analyseType(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value
        if (value?.simbolo != "sinteiro" && value?.simbolo != "sbooleano") {
            throw sintaticException(name: "SintaticException", message: "Esperava encontrar diferente de inteiro ou booleano - analyseType", stack:linkedCharacters)
        }else{
            simbolTable.insertIntoTheLastOne(nivelEscopo: "", tipo: value?.simbolo ?? "", enderecoMemoria: "")
        }
        linkedCharacters.nextNode()
    }
    
    //Olhar essa funcao
    func analyseCommands(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
            if (value == "sinicio" ) {
                linkedCharacters.nextNode()
                try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
                
                var value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
                
                while (value2 != "sfim") {
                    
                    if (value2 == "sponto_virgula") {
                        linkedCharacters.nextNode()
                        value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
    
                        if (value2 != "sfim") {
                            try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
                            value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
                        } else {
                            throw sintaticException(name: "SintaticException", message: "Esperava encontrar sfim - analyseCommands", stack: linkedCharacters)
                        }
                    }else{

                        //linkedCharacters.nextNode()
                        //value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
                        throw sintaticException(name: "SintaticException", message: "Esperava encontrar ; - analyseCommands", stack: linkedCharacters)
                    }

                    //print("\(value)")
                }
                linkedCharacters.nextNode()
                value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            }else {
                throw sintaticException(name: "SintaticException", message: "Esperava encontrar inicio - analyseCommands", stack:linkedCharacters)
            }
    }
    
    func analyseSimpleCommands(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if value == "sidentificador" {
            //analisar atrib chprocedimento
            try analyseChProcedure(linkedCharacters: &linkedCharacters)
        } else if value == "sse" {
            //analisa sse
            try analyseIf(linkedCharacters: &linkedCharacters)
        } else if value == "senquanto" {
            //analisa enquantp
            try analyseWhile(linkedCharacters: &linkedCharacters)
        } else if value == "sleia" {
            //analisa sleia
            try analyseRead(linkedCharacters: &linkedCharacters)
        } else if value == "sescreva" {
            //analisa escreva
            try analyseWrite(linkedCharacters: &linkedCharacters)
        } else {
            //analisa comandos
            try analyseCommands(linkedCharacters: &linkedCharacters)
        }
    }
    
    func analyseChProcedure(linkedCharacters: inout LinkedList<token_struct>) throws {
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if (value == "satribuicao") {
            //Analisa_atribuicao
            //TO_DO
            //PASSIVEL DE ERRO - LEMBRAR
            linkedCharacters.nextNode()
            try analyseExpression(linkedCharacters: &linkedCharacters)
            //analisa_expressao
        }
         else{
            //Chamada_procedimento
            //TO_DO
        }
    }
    
    func analyseRead(linkedCharacters: inout LinkedList<token_struct>) throws {
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if (value == "sabre_parenteses") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            if (value2 == "sidentificador") {
                //Lexico(token)
                let rawValue2 = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")
                if(simbolTable.itExists(lexema: rawValue2.lexema)){
                    linkedCharacters.nextNode()
                    let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""

                    if (value3 == "sfecha_parenteses") {
                        //Lexico(token)
                        linkedCharacters.nextNode()
                    } else {
                        throw sintaticException(name: "SintaticException", message: "Esperava encontrar fecha parenteses - analyseRead", stack:linkedCharacters)
                    }
                }else{
                    throw sintaticException(name: "SintaticException", message: "Identificador nao entrado - analyseRead", stack:linkedCharacters)
                }
            } else {
                throw sintaticException(name: "SintaticException", message: "Esperava econtrar identificador - analyseRead", stack:linkedCharacters)
            }
        } else {
            throw sintaticException(name: "SintaticException", message: "Esperava-se encontrar final de abre parenteses - analyseRead", stack:linkedCharacters)
        }
    }
    
    func analyseWrite(linkedCharacters: inout LinkedList<token_struct>) throws {
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if (value == "sabre_parenteses") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            let rawValue2 = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")

            if (value2 == "sidentificador") {

                if(simbolTable.itExists(lexema: rawValue2.lexema)){
                    linkedCharacters.nextNode()
                    let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                    if (value3 == "sfecha_parenteses") {
                        //Lexico(token)
                        linkedCharacters.nextNode()
                    } else {
                        throw sintaticException(name: "SintaticException", message: "Esperava encontrar fecha parenteses - analyseWrite", stack:linkedCharacters)
                    }
                }else{
                    throw sintaticException(name: "SintaticException", message: "Identificador nao encontrado - analyseWrite", stack:linkedCharacters)
                }
                //Lexico(token)

            } else {
                throw sintaticException(name: "SintaticException", message: "Esperava sidentificador - analyseWrite", stack:linkedCharacters)
            }
        }else {
            throw sintaticException(name: "SintaticException", message: "Esperava abre parenteses - analyseWrite", stack:linkedCharacters)
        }
    }
    
    func analyseWhile(linkedCharacters: inout LinkedList<token_struct>) throws {
        linkedCharacters.nextNode()

        //analisaExpressão
        try analyseExpression(linkedCharacters: &linkedCharacters)

        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if value == "sfaca" {
            linkedCharacters.nextNode()
            try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
        } else {
            throw sintaticException(name: "SintaticException", message: "Esperava encontrar sfaca - analyseWhile ", stack:linkedCharacters)
        }
    }
    
    func analyseIf(linkedCharacters: inout LinkedList<token_struct>) throws {
        linkedCharacters.nextNode()
        //analyse expression
        try analyseExpression(linkedCharacters: &linkedCharacters)
        
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if value == "sentao" {
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            //analisa comando simples
            try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
            let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
    
            if value3 == "ssenao" {
    
                linkedCharacters.nextNode()
                //analisa comando simples
                try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
            }
            
        } else {
            
            throw sintaticException(name: "SintaticException", message: "Esperava 'entao' - analyseIf", stack:linkedCharacters)
        }
    }
    
    func analyseSubroutines(linkedCharacters: inout LinkedList<token_struct>) throws {
        var flag  = 0
        //linkedCharacters.nextNode()
        var value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        while (value == "sprocedimento"
                || value == "sfuncao") {

            if (value == "sprocedimento") {
                //analisa_declaracao_procedimento
                try analyseProcedureDeclaration(linkedCharacters: &linkedCharacters)
                value = linkedCharacters.first?.value.simbolo as? String ?? ""
            } else {
                //analisa_declaracao_funcao
                try analyseFunctionDeclaration(linkedCharacters: &linkedCharacters)
                value = linkedCharacters.first?.value.simbolo as? String ?? ""
            }
            
            if (value == "sponto_virgula") {
                linkedCharacters.nextNode()
                value = linkedCharacters.first?.value.simbolo as? String ?? ""
            } else {
                throw sintaticException(name: "SintaticException", message: "Esperava econtrar ponto e virgula - analyseSubroutines", stack:linkedCharacters)
            }
        }
        
        if (flag == 1) {
            //Gera(auxrot, NULL, , )
        }
        
    }
    
    func analyseProcedureDeclaration(linkedCharacters: inout LinkedList<token_struct>) throws {
        //Lexico(token)
        linkedCharacters.nextNode()
        var NIVEL = "L"
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        let rawValue = linkedCharacters.first?.value
        if (value == "sidentificador") {
            //Lexico(token)
            if(!simbolTable.itExists(procedimento: rawValue?.lexema ?? "")){
                simbolTable.push(lexema: rawValue?.lexema ?? "", nivelEscopo: NIVEL, tipo: "IRA SER SUBSTITUIDO", enderecoMemoria: "IRA SER SUBSTITUIDO")
                linkedCharacters.nextNode()
                let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
                if (value2 == "sponto_virgula") {
                    //Analisa_bloco
                    try blockAnalyser(linkedCharacters: &linkedCharacters)
                } else {
                    throw sintaticException(name: "SintaticException", message: "Esperava econtrar ponto e virgula - analyseProcedureDeclaration", stack:linkedCharacters)
                }
            }else{
                throw sintaticException(name: "SintaticException", message: "Nome de Procedimento duplicado - analyseProcedureDeclaration", stack:linkedCharacters)
            }

        } else {
            throw sintaticException(name: "SintaticException", message: "Esperava econtrar identificador - analyseProcedureDeclaration ", stack:linkedCharacters)
        }
        NIVEL = "0"
    }
    
    func analyseFunctionDeclaration(linkedCharacters: inout LinkedList<token_struct>) throws {
        //Lexico(token)
        linkedCharacters.nextNode()
        var NIVEL = "L"
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if (value == "sidentificador") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            let rawValue = linkedCharacters.first?.value

            if(!simbolTable.itExists(procedimento: rawValue?.lexema ?? "")){
                simbolTable.push(lexema: rawValue?.lexema ?? "", nivelEscopo: NIVEL, tipo: "", enderecoMemoria: "IRA SER SUBSTITUIDO")
                if (value2 == "sdoispontos") {
                    //Lexico(token)
                    linkedCharacters.nextNode()
                    let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                    if (value3 ==  "sinteiro" ||
                            value3 == "sbooleano") {
                        simbolTable.insertIntoTheLastOne(nivelEscopo: NIVEL, tipo: "func "+value3, enderecoMemoria: "IRA SER SUBSTITUIDO")
                        //Lexico(token)
                        linkedCharacters.nextNode()
                        let value4 = linkedCharacters.first?.value.simbolo as? String ?? ""
                        if (value4 == "sponto_virgula") {
                            //blockAnalyser()
                            try blockAnalyser(linkedCharacters: &linkedCharacters)
                        }
                    } else {
                        throw sintaticException(name: "SintaticException", message: "Esperava encontrar um inteiro ou booleano - analyseFunctionDeclaration", stack:linkedCharacters)
                    }
                } else {
                    throw sintaticException(name: "SintaticException", message: "Esperava encontrar dois pontos - analyseFunctionDeclaration", stack:linkedCharacters)
                }
            }
        } else {
            throw sintaticException(name: "SintaticException", message: "Esperava encontrar um identificador - analyseFunctionDeclaration", stack:linkedCharacters)
        }
        NIVEL = ""
    }
    
    func analyseExpression(linkedCharacters: inout LinkedList<token_struct>) throws {
        try customProcessExpression(linkedCharacters: linkedCharacters)
        try analyseSimpleExpression(linkedCharacters: &linkedCharacters)

        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        if value == "smaior" || value == "smaiorig" || value == "sig" || value == "smenor" ||
                value == "smenorig" || value == "sdif" {
            //Lexico(token)
            linkedCharacters.nextNode()
            try analyseSimpleExpression(linkedCharacters: &linkedCharacters)
        }
    }

    //if u are here after this cold night (30/10/2021) u should definitely remove this shit :)
    func customProcessExpression(linkedCharacters: LinkedList<token_struct>){
        var list : Array<token_struct> = []
        var listCopy : LinkedList<token_struct> = LinkedList<token_struct>()
        //Here, friendodas, we can see a language that tries to helo, but, instead, kills us by faciliting the unfacilitating
        listCopy.setHead(el: linkedCharacters.first!)

        var value = listCopy.first?.value ?? token_struct(lexema: "", simbolo: "")

        while(value.simbolo != "sfaca" && value.simbolo != "sfim" && value.simbolo != "sponto_virgula"
                && value.simbolo != "sentao" ) {

            list.append(value)

            listCopy.nextNode()
            value = listCopy.first?.value ?? token_struct(lexema: "", simbolo: "")
        }

        //search for "-" before a snumero or sidentificador
        var listFinal : LinkedList<token_struct> = LinkedList<token_struct>()

        for i in 0..<list.count{
            if(list[i].simbolo == "smenos"){
                //listFinal.append(list[i])

                if((list[i+1].simbolo == "sidentificador" || list[i+1].simbolo == "snumero" ) ){
                    //tuptudurundawn
                    listFinal.append(token_struct(lexema: "-u", simbolo: "su_identificador"))
                }else{
                    listFinal.append(token_struct(lexema:list[i].lexema, simbolo: list[i].simbolo))
                }
            }else{
                listFinal.append(token_struct(lexema:list[i].lexema, simbolo: list[i].simbolo))
            }
        }
        let _posFixed = PosFixed()

        _posFixed.posFixedConvertion(tokens: listFinal)
       // print("Copy eeeeeeend")

    }
    
    func analyseSimpleExpression(linkedCharacters: inout LinkedList<token_struct>) throws{
        //linkedCharacters.nextNode()
        var value = linkedCharacters.first?.value.simbolo as? String ?? ""
    
        if(value == "smais" ||
          value == "smenos") {
            //Lexico(token)
            linkedCharacters.nextNode()
            //Analisa Termo()
            value = linkedCharacters.first?.value.simbolo as? String ?? ""
        }
        
        try analyseTerm(linkedCharacters: &linkedCharacters)
        value = linkedCharacters.first?.value.simbolo as? String ?? ""
        while(value == "smais" ||
                value == "smenos" ||
             value == "sou") {
            //Lexico(token)
            linkedCharacters.nextNode()
            //Analisa_termo()
            try analyseTerm(linkedCharacters: &linkedCharacters)
            value = linkedCharacters.first?.value.simbolo as? String ?? ""
        }
    }
    
    func analyseTerm(linkedCharacters: inout LinkedList<token_struct>) throws {
        try analyseFactor(linkedCharacters: &linkedCharacters)
        var value = linkedCharacters.first?.value.simbolo as? String ?? ""
        while(value == "smult"
                || value == "sdiv" || value == "se") {
            linkedCharacters.nextNode()
            try analyseFactor(linkedCharacters: &linkedCharacters)
            value = linkedCharacters.first?.value.simbolo as? String ?? ""
        }
    }
    
    func analyseFactor(linkedCharacters: inout LinkedList<token_struct>) throws {
        var value = linkedCharacters.first?.value
        if value?.simbolo == "sidentificador" {
            //analisa chamada funcao
            let ret = simbolTable.find(lexema: value?.lexema ?? "", nivel: "")
            if(ret != nil){
                if(ret?.tipo == "func sinteiro" || ret?.tipo == "func sbooleano"){
                    //analisa chamada de funcao
                }else{
                    linkedCharacters.nextNode()
                    value = linkedCharacters.first?.value
                }
            }else{
                throw sintaticException(name: "SintaticException", message: "Identificador nao encontrado - analyseFactor", stack:linkedCharacters)
            }
        }else if value?.simbolo == "snumero" {
            linkedCharacters.nextNode()
            value = linkedCharacters.first?.value
        }else if(value?.simbolo == "snao")  {
            linkedCharacters.nextNode()
            try analyseFactor(linkedCharacters: &linkedCharacters)
            value = linkedCharacters.first?.value
        }else if value?.simbolo  == "sabre_parenteses" {
            linkedCharacters.nextNode()
            try analyseExpression(linkedCharacters: &linkedCharacters)
            value = linkedCharacters.first?.value
            if value?.simbolo  == "sfecha_parenteses" {
                linkedCharacters.nextNode()
                value = linkedCharacters.first?.value
            } else {
                throw sintaticException(name: "SintaticException", message: "Esperava encontrar um fecha parenteses - analyseFactor", stack:linkedCharacters)
            }
    
        }else if value?.lexema == "sverdadeiro" || value?.lexema == "sfalso" {
            linkedCharacters.nextNode()
            value = linkedCharacters.first?.value
        } else {
            throw sintaticException(name: "SintaticException", message: "Esperava encontrar verdadeiro ou falso - analyseFactor", stack:linkedCharacters)
        }
        
        
        
    }
}

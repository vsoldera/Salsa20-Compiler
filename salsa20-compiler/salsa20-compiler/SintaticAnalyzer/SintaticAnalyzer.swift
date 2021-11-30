//
// Created by BPM on 02/10/21.
//

import Foundation


struct sintaticException: Error {
    var name: String
    var message: String
    var stack: LinkedList<token_struct>?
}


class SyntacticAnalyzer: Token {
    var linkedCharactersGlobal = LinkedList<token_struct>()
    var simbolTable : SimbolTable = SimbolTable()
    var rotule : Int = 1;
    var memoryAllocationPointer: Int = 0
    var codeGenerator : CodeGenerator = CodeGenerator()


    init(linkedCharacters: LinkedList<token_struct>) {
        linkedCharactersGlobal.removeAll()
        self.linkedCharactersGlobal = linkedCharacters
    }
    
    func analyser() throws {
//        var i = 0
        var linkedCharacters = self.linkedCharactersGlobal;
        codeGenerator.initProgram()
        memoryAllocationPointer += 1

        //linkedCharacters.nextNode()
        
            let value = linkedCharacters.first?.value.simbolo ?? ""
            if (value == "sprograma") {
                linkedCharacters.nextNode()
                
                let sIdentificador = linkedCharacters.first?.value.simbolo ?? ""
                let rawValue = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")
                if (sIdentificador == "sidentificador") {
                    //insere_tabela
                    simbolTable.push(lexema: rawValue.lexema, nivelEscopo: "nomedeprograma", tipo: "nomedeprograma", enderecoMemoria: "")
                    linkedCharacters.nextNode()
                    
                    let value2 = linkedCharacters.first?.value.simbolo ?? ""
                    if (value2 == "sponto_virgula") {
                        //analisa_bloco
                        
                        try blockAnalyser(linkedCharacters: &linkedCharacters)
                        //linkedCharacters.nextNode()
                        let value3 = linkedCharacters.first?.value.simbolo ?? ""
                        if (value3 == "sponto") {
                            
                            linkedCharacters.nextNode()
                            
                            let value4 = linkedCharacters.first?.value.simbolo ?? ""
                            
                            if (value4 == "" || value4 == "sinicio_comentario") {
                                let removedVariables = simbolTable.cleanVariables()
                                if(removedVariables > 0) {
                                    let lastValue = memoryAllocationPointer
                                    print(memoryAllocationPointer, removedVariables)
        
                                    memoryAllocationPointer = memoryAllocationPointer - removedVariables
        
                                    codeGenerator.generate("        ", "DALLOC", "\(memoryAllocationPointer)", "\(lastValue - memoryAllocationPointer)")
                                }
    
                                codeGenerator.generate("        ", "DALLOC", "0", "1")
                                codeGenerator.generate("        ", "HLT", "        ", "        ")
    
    
                                return
                            } else {
                                throw sintaticException(name: "Sintatic Exception", message: "Final de arquivo encontrado, mas não é o final do arquivo - analyser", stack:linkedCharacters)
                            }
                        } else {
                            throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar final de arquivo - analyser", stack:linkedCharacters)
                        }
                    } else {
                        throw sintaticException(name: "Sintatic Exception", message: "Esperava identificador de final de sentença ; - analyser", stack:linkedCharacters)
                    }
                } else {
                    throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar identificador de programa - analyser", stack:linkedCharacters)
                }
            } else {
                throw sintaticException(name: "Sintatic Exception", message: "Início de programa não encontrado - analyser", stack:linkedCharacters)
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
        var auxPointer = 0
        let value = linkedCharacters.first?.value.simbolo ?? ""
        
       if value == "svar"{
           linkedCharacters.nextNode()
           let value2 = linkedCharacters.first?.value.simbolo ?? ""
    
           if(value2 == "sidentificador") {
                
                var value3 = linkedCharacters.first?.value.simbolo ?? ""
                while(value3 == "sidentificador") {
                    auxPointer = memoryAllocationPointer  //para saber qual valor era do rotulo antes de voltar

                    try analyseVariables(linkedCharacters: &linkedCharacters)

                    codeGenerator.generate("        " , "ALLOC", "\(auxPointer)", "\(memoryAllocationPointer - auxPointer)")

                    //memoryAllocationPointer = auxPointer + memoryAllocationPointer

                    value3 = linkedCharacters.first?.value.simbolo ?? ""
                    if(value3 == "sponto_virgula") {
                        linkedCharacters.nextNode()
                        value3 = linkedCharacters.first?.value.simbolo ?? ""
                    } else {
                        throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar ponto e virgula - analyseEtVariables", stack:linkedCharacters)
                    }
                }
            } else {
                throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar identificador - analyseEtVariables", stack:linkedCharacters)
            }
        }
    }
    
    func analyseVariables(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        var value = linkedCharacters.first?.value.simbolo ?? ""
        var rawValue = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")
        repeat {
            if (value == "sidentificador") {
                if(!simbolTable.testDuplicate(lexema: rawValue.lexema)) {
                    simbolTable.push(lexema: rawValue.lexema, nivelEscopo: "", tipo: "", enderecoMemoria: "\(memoryAllocationPointer)")
                    memoryAllocationPointer += 1

                    linkedCharacters.nextNode()
                    value = linkedCharacters.first?.value.simbolo ?? ""

                    if (value == "svirgula" || value == "sdoispontos") {

                        if (value == "svirgula") {

                            linkedCharacters.nextNode()
                            value = linkedCharacters.first?.value.simbolo ?? ""
                            rawValue = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")
                            if (value == "sdoispontos") {
                                throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar dois pontos - analyseVariables", stack: nil)
                            }

                        }
                    } else {
                        print("VALOR: ", value)
                        throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar svirgula ou sdois pontos - analyseVariables", stack: linkedCharacters)
                    }
                }else{
                    throw sintaticException(name: "Sintatic Exception", message: "Variaveis duplicadas", stack: linkedCharacters)
                }
            }else{
                throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar identificador - analyseVariables", stack:linkedCharacters)
            }
            
            
        } while (value != "sdoispontos");
        
        linkedCharacters.nextNode()
        try analyseType(linkedCharacters: &linkedCharacters)
        
    }
    
    func analyseType(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value
        if (value?.simbolo != "sinteiro" && value?.simbolo != "sbooleano") {
            throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar diferente de inteiro ou booleano - analyseType", stack:linkedCharacters)
        }else{
            simbolTable.insertIntoTheLastOne(nivelEscopo: "", tipo: value?.simbolo ?? "", enderecoMemoria: "ignore")
        }
        linkedCharacters.nextNode()
    }
    
    //Olhar essa funcao
    
    func analyseCommands(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        
        let value = linkedCharacters.first?.value.simbolo ?? ""
            if (value == "sinicio" ) {
                linkedCharacters.nextNode()
                try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
                
                var value2 = linkedCharacters.first?.value.simbolo ?? ""
                
                while (value2 != "sfim" ) {

                    if (value2 == "sponto_virgula") {
                        linkedCharacters.nextNode()
                        value2 = linkedCharacters.first?.value.simbolo ?? ""
    
                        if (value2 != "sfim") {
                            try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
                            value2 = linkedCharacters.first?.value.simbolo ?? ""
                        }
                        // UM CAGAO DEIXOU UM THROW AQUI, DEIXOU A GENTE BUSCANDO ERRO DESDE - E FOI SO REMOVER QUE RESOLVEU
                        // AS 19h do 10/11/2021 até 04:00h 11/11/2021 - EU NAO VOU DORMIR, NEM O SALSA
                        // É A CULPA É DE ALGUM F*** BLAME XU (PS.: NAO FICOU PRA AJUDA #TO_MARCANDO_E_TO_VENDO)
                    }else {

                        //linkedCharacters.nextNode()
                        //value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
                        throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar ; - analyseCommands", stack: linkedCharacters)
                    }
                    //print("\(value)")
                }
                linkedCharacters.nextNode()
                value2 = linkedCharacters.first?.value.simbolo ?? ""
            }else {
                print("aoba")
                print("VALOR: ", value)
                throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar inicio - analyseCommands", stack:linkedCharacters)
            }
    }
    
    func analyseSimpleCommands(linkedCharacters: inout LinkedList<token_struct>) throws {
        //linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo ?? ""
        let token = linkedCharacters.first?.value
    
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
            codeGenerator.generate("        ", "RD", "        ", "        ")
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
        let _value = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")// para ser usado antes da atribuição
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo ?? ""
        
        if (value == "satribuicao") {
            //Analisa_atribuicao
            //TO_DO
            //PASSIVEL DE ERRO - LEMBRAR

            linkedCharacters.nextNode(); //AQUI

            let listCopy : LinkedList<token_struct> = LinkedList<token_struct>()


            listCopy.setHead(el: linkedCharacters.first!)

            try analyseExpression(linkedCharacters: &linkedCharacters)
            
            //ESSA FUNCAO TAMBEM GERA O CODIGO DE MAQUINA
            let typeExpression = try customProcessExpression(linkedCharacters: listCopy, goTo: linkedCharacters.first?.index ?? 0)

            let simbol = simbolTable.findLexemaReturnCompleteSymbol(lexema: _value.lexema)

            if(simbol != nil ){
                if(simbol?.tipo == "func sinteiro" || simbol?.tipo == "func sbooleano"){
                    codeGenerator.generate("        ", "STR", "0", "        ")
                }else{

                    if(typeExpression == simbol?.tipo || (typeExpression == "snumero" && simbol?.tipo == "sinteiro")) {
                        codeGenerator.generate("        ", "STR", "\(simbol?.enderecoMemoria ?? "")", "        ")
                    }else{
                        print("AQUI: ", typeExpression, (typeExpression) ,simbol?.tipo)
                        throw sintaticException(name: "Sintatic Exception", message: "Atribuição incorreta de tipo para variavel \(_value.lexema)", stack:linkedCharacters)
                    }
                }
            }

            //analisa_expressao
        }
         else {
            //Chamada_procedimento
            //TO_DO
             let simbol = simbolTable.findLexemaReturnCompleteSymbol(lexema: _value.lexema)

             if(simbol != nil ){
                 if(simbol?.tipo == "sprocedimento" || simbol?.tipo == "func sinteiro" || simbol?.tipo == "func sbooleano"){
                     codeGenerator.generate("        ", "CALL", simbol?.enderecoMemoria ?? "", "        ")
                 }
             }else{
                 throw sintaticException(name: "Sintatic Exception", message: "Identificador não encontrado - AnalyseChProcedure", stack:linkedCharacters)
             }
        }
    }
    
    func analyseRead(linkedCharacters: inout LinkedList<token_struct>) throws {
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo ?? ""
        
        if (value == "sabre_parenteses") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo ?? ""
            if (value2 == "sidentificador") {
                //Lexico(token)
                let rawValue2 = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")
                if(simbolTable.itExists(lexema: rawValue2.lexema)){
                    let simbolo = simbolTable.findLexemaReturnCompleteSymbol(lexema: rawValue2.lexema)

                    //Apenas leitura de tipos inteiros
                    if(simbolo?.tipo == "sinteiro"){
                        codeGenerator.generate("        ", "STR", "\(simbolo?.enderecoMemoria ?? "")", "        ")
                    }else if(simbolo?.tipo == "sbooleano"){
                        throw sintaticException(name: "Sintatic Exception", message: "Leitura de variáveis booleanas não permitida - AnalyseRead", stack:linkedCharacters)
                    }

                    linkedCharacters.nextNode()
                    let value3 = linkedCharacters.first?.value.simbolo ?? ""
                    
                    if (value3 == "sfecha_parenteses") {
                        //Lexico(token)
                        linkedCharacters.nextNode()
                    } else {
                        throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar fecha parenteses - analyseRead", stack:linkedCharacters)
                    }
                }else{
                    throw sintaticException(name: "Sintatic Exception", message: "Identificador nao entrado - analyseRead", stack:linkedCharacters)
                }
            } else {
                throw sintaticException(name: "Sintatic Exception", message: "Esperava econtrar identificador - analyseRead", stack:linkedCharacters)
            }
        } else {
            throw sintaticException(name: "Sintatic Exception", message: "Esperava-se encontrar final de abre parenteses - analyseRead", stack:linkedCharacters)
        }
    }
    
    func analyseWrite(linkedCharacters: inout LinkedList<token_struct>) throws {
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo ?? ""
        
        if (value == "sabre_parenteses") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo ?? ""
            let rawValue2 = linkedCharacters.first?.value ?? token_struct(lexema: "", simbolo: "")

            if (value2 == "sidentificador") {

                if(simbolTable.itExists(procedimento: rawValue2.lexema)){

                    let simbol = simbolTable.findLexemaReturnCompleteSymbol(lexema: rawValue2.lexema)
                    if(simbol?.tipo == "sinteiro"){
                        codeGenerator.generate("        ", "LDV", "\(simbol?.enderecoMemoria ?? "")", "        ")
                        codeGenerator.generate("        ", "PRN", "        ", "        ")
                    }

                    linkedCharacters.nextNode()
                    let value3 = linkedCharacters.first?.value.simbolo ?? ""
                    if (value3 == "sfecha_parenteses") {
                        //Lexico(token)
                        linkedCharacters.nextNode()
                    } else {
                        throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar fecha parenteses - analyseWrite", stack:linkedCharacters)
                    }
                }else{
                    throw sintaticException(name: "Sintatic Exception", message: "Identificador nao encontrado - analyseWrite", stack:linkedCharacters)
                }
                //Lexico(token)

            } else {
                throw sintaticException(name: "Sintatic Exception", message: "Esperava sidentificador - analyseWrite", stack:linkedCharacters)
            }
        }else {
            throw sintaticException(name: "Sintatic Exception", message: "Esperava abre parenteses - analyseWrite", stack:linkedCharacters)
        }
    }
    
    func analyseWhile(linkedCharacters: inout LinkedList<token_struct>) throws {
        var auxRot1, auxRot2 : Int

        auxRot1 = rotule
        codeGenerator.generate("\(self.rotule)       " , "NULL",  "        ",  "        ")
        self.rotule += 1
        linkedCharacters.nextNode()
        //analisaExpressão

        let listCopy : LinkedList<token_struct> = LinkedList<token_struct>()
        listCopy.setHead(el: linkedCharacters.first!)

        try analyseExpression(linkedCharacters: &linkedCharacters)
                
        try customProcessExpression(linkedCharacters: listCopy,  goTo: linkedCharacters.first?.index ?? 0)
        
        let value = linkedCharacters.first?.value.simbolo ?? ""
        
        if value == "sfaca" {
            auxRot2 = self.rotule
            codeGenerator.generate("        ","JMPF" ,  "\( self.rotule)",    "        ")
            self.rotule += 1
            linkedCharacters.nextNode()
            try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
            codeGenerator.generate("        ", "JMP" ,  "\(auxRot1)",   "        ")
            codeGenerator.generate("\(auxRot2)       " ,  "NULL",  "        ",  "        ")
        } else {
            throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar sfaca - analyseWhile ", stack:linkedCharacters)
        }
    }
    
    func analyseIf(linkedCharacters: inout LinkedList<token_struct>) throws {
        var auxRot: Int
        linkedCharacters.nextNode()
        //analyse expression

        let listCopy : LinkedList<token_struct> = LinkedList<token_struct>()
        listCopy.setHead(el: linkedCharacters.first!)

        try analyseExpression(linkedCharacters: &linkedCharacters)

        //ja vai processar e gerar o codigo de maquina:
        try customProcessExpression(linkedCharacters: listCopy, goTo: linkedCharacters.first?.index ?? 0)



        let value = linkedCharacters.first?.value.simbolo ?? ""
        
        var falseLabel = self.rotule
        var finalLabel = self.rotule
        
        //auxRot = self.rotule
        
        if value == "sentao" {
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo ?? ""
            //analisa comando simples
            codeGenerator.generate("        ", "JMPF", "\(falseLabel)", "        ")
            self.rotule += 1
            try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
            let value3 = linkedCharacters.first?.value.simbolo ?? ""


            if value3 == "ssenao" {
                finalLabel = self.rotule
                codeGenerator.generate("        ", "JMP", "\(finalLabel)", "        ")
                
                self.rotule+=1
                
                codeGenerator.generate("\(falseLabel)       ", "NULL", "        ", "        ")
                linkedCharacters.nextNode()
                //analisa comando simples
                try analyseSimpleCommands(linkedCharacters: &linkedCharacters)

                //codeGenerator.generate("\(self.rotule)       ", "NULL", "        ", "        ")

            }

        } else {
            
            throw sintaticException(name: "Sintatic Exception", message: "Esperava 'entao' - analyseIf", stack:linkedCharacters)
        }
        
       
        codeGenerator.generate("\(finalLabel)       ", "NULL", "        ", "        ")
            //self.rotule+=1
        

    }
    
    func analyseSubroutines(linkedCharacters: inout LinkedList<token_struct>) throws {
        var flag  = 0
        var auxRot = 0
        //linkedCharacters.nextNode()
        var value = linkedCharacters.first?.value.simbolo ?? ""

        if(value == "sprocedimento"
                || value == "sfuncao"){
            auxRot = rotule
            codeGenerator.generate( "        ", "JMP", "\(self.rotule)",    "        ")
            rotule += 1
            flag = 1
        }

        
        while (value == "sprocedimento"
                || value == "sfuncao") {

            if (value == "sprocedimento") {
                //analisa_declaracao_procedimento
                try analyseProcedureDeclaration(linkedCharacters: &linkedCharacters)
                value = linkedCharacters.first?.value.simbolo ?? ""
            } else {
                //analisa_declaracao_funcao
                try analyseFunctionDeclaration(linkedCharacters: &linkedCharacters)
                value = linkedCharacters.first?.value.simbolo ?? ""
            }
            
            if (value == "sponto_virgula") {
                linkedCharacters.nextNode()
                value = linkedCharacters.first?.value.simbolo ?? ""
            } else {
                throw sintaticException(name: "Sintatic Exception", message: "Esperava econtrar ponto e virgula - analyseSubroutines", stack:linkedCharacters)
            }


        }
        
        if (flag == 1) {
            codeGenerator.generate( "\(auxRot)       ",  "NULL",  "        ",  "        ")
        }
        
    }
    
    func analyseProcedureDeclaration(linkedCharacters: inout LinkedList<token_struct>) throws {
        //Lexico(token)
        linkedCharacters.nextNode()
        var NIVEL = "L"
        let value = linkedCharacters.first?.value.simbolo ?? ""
        let rawValue = linkedCharacters.first?.value
        if (value == "sidentificador") {
            //Lexico(token)
            if(!simbolTable.itExists(procedimento: rawValue?.lexema ?? "")){
                simbolTable.push(lexema: rawValue?.lexema ?? "", nivelEscopo: NIVEL, tipo: "sprocedimento", enderecoMemoria: "\(self.rotule)")

                codeGenerator.generate("\(self.rotule)       " , "NULL",  "        ",  "        ")
                self.rotule += 1

                linkedCharacters.nextNode()
                let value2 = linkedCharacters.first?.value.simbolo ?? ""
                if (value2 == "sponto_virgula") {
                    //Analisa_bloco
                    try blockAnalyser(linkedCharacters: &linkedCharacters)
                } else {
                    throw sintaticException(name: "Sintatic Exception", message: "Esperava econtrar ponto e virgula - analyseProcedureDeclaration", stack:linkedCharacters)
                }
            }else{
                throw sintaticException(name: "Sintatic Exception", message: "Nome de Procedimento duplicado - analyseProcedureDeclaration", stack:linkedCharacters)
            }

        } else {
            throw sintaticException(name: "Sintatic Exception", message: "Esperava econtrar identificador - analyseProcedureDeclaration ", stack:linkedCharacters)
        }

        let removedVariables = simbolTable.cleanVariables()
        if(removedVariables > 0) {
            let lastValue = memoryAllocationPointer
            print(memoryAllocationPointer, removedVariables)

            memoryAllocationPointer = memoryAllocationPointer - removedVariables

            codeGenerator.generate("        ", "DALLOC", "\(memoryAllocationPointer)", "\(lastValue - memoryAllocationPointer)")
        }
        codeGenerator.generate("        ", "RETURN", "        ", "        ")

        NIVEL = "0"
    }
    
    func analyseFunctionDeclaration(linkedCharacters: inout LinkedList<token_struct>) throws {
        //Lexico(token)
        linkedCharacters.nextNode()
        let NIVEL = "L"
        let value = linkedCharacters.first?.value.simbolo ?? ""
        
        if (value == "sidentificador") {
            //Lexico(token)
            let rawValue = linkedCharacters.first?.value

            if(!simbolTable.itExists(procedimento: rawValue?.lexema ?? "")){
                simbolTable.push(lexema: rawValue?.lexema ?? "", nivelEscopo: NIVEL, tipo: "", enderecoMemoria: "\(self.rotule)")

                codeGenerator.generate("\(self.rotule)       " , "NULL",  "        ",  "        ")
                self.rotule += 1

                linkedCharacters.nextNode()
                let value2 = linkedCharacters.first?.value.simbolo ?? ""
                if (value2 == "sdoispontos") {
                    //Lexico(token)
                    linkedCharacters.nextNode()
                    let value3 = linkedCharacters.first?.value.simbolo ?? ""
                    if (value3 ==  "sinteiro" ||
                            value3 == "sbooleano") {
                        simbolTable.insertIntoTheLastOne(nivelEscopo: NIVEL, tipo: "func "+value3, enderecoMemoria: "ignore")
                        //Lexico(token)
                        linkedCharacters.nextNode()
                        let value4 = linkedCharacters.first?.value.simbolo ?? ""
                        if (value4 == "sponto_virgula") {
                            //blockAnalyser()
                            try blockAnalyser(linkedCharacters: &linkedCharacters)
                        }
                    } else {
                        throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar um inteiro ou booleano - analyseFunctionDeclaration", stack:linkedCharacters)
                    }
                } else {
                    throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar dois pontos - analyseFunctionDeclaration", stack:linkedCharacters)
                }
            }
        } else {
            throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar um identificador - analyseFunctionDeclaration", stack:linkedCharacters)
        }
    
        let removedVariables = simbolTable.cleanVariables()
        if(removedVariables > 0) {
            let lastValue = memoryAllocationPointer
            print(memoryAllocationPointer, removedVariables)
        
            memoryAllocationPointer = memoryAllocationPointer - removedVariables
        
            codeGenerator.generate("        ", "DALLOC", "\(memoryAllocationPointer)", "\(lastValue - memoryAllocationPointer)")
        }
        codeGenerator.generate("        ", "RETURN", "        ", "        ")



    }
    
    func analyseExpression(linkedCharacters: inout LinkedList<token_struct>) throws {
       // try customProcessExpression(linkedCharacters: linkedCharacters)
        try analyseSimpleExpression(linkedCharacters: &linkedCharacters)

        let value = linkedCharacters.first?.value.simbolo ?? ""
        if value == "smaior" || value == "smaiorig" || value == "sig" || value == "smenor" ||
                value == "smenorig" || value == "sdif" {
            //Lexico(token)
            linkedCharacters.nextNode()
            try analyseSimpleExpression(linkedCharacters: &linkedCharacters)
        }
    }

    //if u are here after this cold night (30/10/2021) u should definitely remove this shit :)
    func customProcessExpression(linkedCharacters: LinkedList<token_struct>, goTo: Int) throws -> String{

        var list : Array<token_struct> = []
        let listCopy : LinkedList<token_struct> = LinkedList<token_struct>()
        //Here, friendodas, we can see a language that tries to helo, but, instead, kills us by faciliting the unfacilitating
        listCopy.setHead(el: linkedCharacters.first!)

        var value = listCopy.first?.value ?? token_struct(lexema: "", simbolo: "")
        var index = listCopy.first?.index ?? 0
        //fazendo slice
        while(index <= goTo) {
            
            list.append(value)

            listCopy.nextNode()
            value = listCopy.first?.value ?? token_struct(lexema: "", simbolo: "")
            index = listCopy.first?.index ?? 0
        }

        //search for "-" before a snumero or sidentificador
        let listFinal : LinkedList<token_struct> = LinkedList<token_struct>()

        //marcacoes para -u
        for i in 0..<list.count{
            if(i == 0 && (list[i].simbolo == "smais" || list[i].simbolo == "smenos" ) ){
                if(list[i].simbolo == "smenos"){
                    listFinal.append(token_struct(lexema:  "-u", simbolo: "su_identificador"))
                }else if(list[i].simbolo == "smais"){
                    listFinal.append(token_struct(lexema:  "+u", simbolo: "su_identificador"))
                }
                
            }else{
                if(list[i].simbolo == "smenos"){
                    //listFinal.append(list[i])

                    if(list[i-1].simbolo == "sabre_parenteses" && (list[i+1].simbolo == "sidentificador" || list[i+1].simbolo == "snumero" ) ){
                        //tuptudurundawn
                        listFinal.append(token_struct(lexema:  "-u", simbolo: "su_identificador"))
                    }else{
                        listFinal.append(token_struct(lexema:list[i].lexema, simbolo: list[i].simbolo))
                    }
                }/*else if(list[i].simbolo == "sverdadeiro" || list[i].simbolo == "sfalso"){
                    listFinal.append(token_struct(lexema:list[i].lexema, simbolo: "sbooleano"))
                }*/
                else{
                    listFinal.append(token_struct(lexema:list[i].lexema, simbolo: list[i].simbolo))
                }
            }
            
            
        }
        let _posFixed = PosFixed()

        _posFixed.posFixedConvertion(tokens: listFinal)
        try _posFixed.analyseExpression(simbolTable: simbolTable)
        
        for item in _posFixed.expression{
            let fromSimbolTable = self.simbolTable.findLexemaReturnCompleteSymbol(lexema: item.lexema)
            switch(item.simbolo){
                case "sidentificador":

                    if(fromSimbolTable?.tipo == "func sinteiro" || fromSimbolTable?.tipo == "func sbooleano" || fromSimbolTable?.tipo == "sprocedimento"){
                        codeGenerator.generate("        ", "CALL", fromSimbolTable?.enderecoMemoria ?? "", "        ")
                        if(fromSimbolTable?.tipo == "func sinteiro" || fromSimbolTable?.tipo == "func sbooleano"){
                            codeGenerator.generate("        ", "LDV", "0", "        ")
                        }
                    }else{
                        codeGenerator.generate("        ", "LDV", fromSimbolTable?.enderecoMemoria ?? "", "        ")
                    }
                    break
                case "snumero":
                    codeGenerator.generate("        ", "LDC", item.lexema, "        ")
                break
                case "smais":
                    codeGenerator.generate("        ", "ADD", "        ", "        ")
                    break
                case "smenos":
                    codeGenerator.generate("        ", "SUB", "        ", "        ")
                    break;
                case "smult":
                    codeGenerator.generate("        ", "MULT", "        ", "        ")
                break;
                case "sdiv":
                    codeGenerator.generate("        ", "DIVI", "        ", "        ")
                    break;
                case "su_identificador":
                    codeGenerator.generate("        ", "INV", "        ", "        ")
                    break;
                case "se":
                    codeGenerator.generate("        ", "AND", "        ", "        ")
                    break;
                case "sou":
                    codeGenerator.generate("        ", "OR", "        ", "        ")
                    break;
                case "snao":
                    codeGenerator.generate("        ", "NEG", "        ", "        ")
                    break;
                case "smenor":
                    codeGenerator.generate("        ", "CME", "        ", "        ")
                break;
                case "smaior":
                    codeGenerator.generate("        ", "CMA", "        ", "        ")
                    break;
                case "sdif":
                    codeGenerator.generate("        ", "CDIF", "        ", "        ")
                    break;
                case "smenorig":
                    codeGenerator.generate("        ", "CMEQ", "        ", "        ")
                    break;
                case "smaiorig":
                    codeGenerator.generate("        ", "CMAQ", "        ", "        ")
                    break;
                case "sig":
                    codeGenerator.generate("        ", "CEQ", "        ", "        ")
                break;
                case "sverdadeiro":
                    codeGenerator.generate("        ", "LDC", "1", "        ")
                break;
                case "sfalso":
                    codeGenerator.generate("        ", "LDC", "0", "        ")
                break;
                
                default:
                    codeGenerator.generate("        ", "NAO ACHOU", item.lexema, "        ")
                }
            
        }

        return _posFixed.typeExpression


    }
    
    func analyseSimpleExpression(linkedCharacters: inout LinkedList<token_struct>) throws{
        //linkedCharacters.nextNode()
        var value = linkedCharacters.first?.value.simbolo ?? ""
    
        if(value == "smais" || value == "smenos") {
            //Lexico(token)
            linkedCharacters.nextNode()
            value = linkedCharacters.first?.value.simbolo ?? ""
        }
        
        try analyseTerm(linkedCharacters: &linkedCharacters)
        value = linkedCharacters.first?.value.simbolo ?? ""
        while(value == "smais" ||
                value == "smenos" ||
             value == "sou") {
            //Lexico(token)
            linkedCharacters.nextNode()
            //Analisa_termo()
            try analyseTerm(linkedCharacters: &linkedCharacters)
            value = linkedCharacters.first?.value.simbolo ?? ""
        }
    }
    
    func analyseTerm(linkedCharacters: inout LinkedList<token_struct>) throws {
        try analyseFactor(linkedCharacters: &linkedCharacters)
        var value = linkedCharacters.first?.value.simbolo ?? ""
        while(value == "smult"
                || value == "sdiv" || value == "se") {
            linkedCharacters.nextNode()
            try analyseFactor(linkedCharacters: &linkedCharacters)
            value = linkedCharacters.first?.value.simbolo ?? ""
        }
    }
    
    func analyseFactor(linkedCharacters: inout LinkedList<token_struct>) throws {
        var value = linkedCharacters.first?.value
        if value?.simbolo == "sidentificador" {
            //analisa chamada funcao

            let ret = simbolTable.find(lexema: value?.lexema ?? "", nivel: "")
            if(ret != nil){
                if(ret?.tipo == "func sinteiro" || ret?.tipo == "func sbooleano" ){
                    //analisa chamada de funcao
                    linkedCharacters.nextNode()
                    value = linkedCharacters.first?.value
                }else{
                    linkedCharacters.nextNode()
                    value = linkedCharacters.first?.value
                }
            }else{
                throw sintaticException(name: "Sintatic Exception", message: "Identificador nao encontrado - analyseFactor", stack:linkedCharacters)
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
                throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar um fecha parenteses - analyseFactor", stack:linkedCharacters)
            }
    
        }else if value?.simbolo == "sverdadeiro" || value?.simbolo == "sfalso" {
            linkedCharacters.nextNode()
            value = linkedCharacters.first?.value
        } else {
            throw sintaticException(name: "Sintatic Exception", message: "Esperava encontrar verdadeiro ou falso - analyseFactor", stack:linkedCharacters)
        }
        
        
        
    }
}

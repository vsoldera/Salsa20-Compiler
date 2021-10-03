//
// Created by BPM on 02/10/21.
//

import Foundation


struct sintaticException: Error {
    var name: String
    var message: String
    var stack: LinkedList<String>
}


class SyntacticAnalyzer: Token {
    var linkedCharactersGlobal = LinkedList<String>()
    
    init(linkedCharacters: LinkedList<String>) {
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
    
                if (sIdentificador == "sidentificador") {
                    //insere_tabela
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
    
    func blockAnalyser(linkedCharacters: inout LinkedList<String>) throws {
        //deve retornar o ponteiro para a proxima busca
        //let value = linkedCharacters.nodeAt(index: actualPosition)?.value.simbolo as? String ?? ""
        linkedCharacters.nextNode()
        
        try analyseEtVariables(linkedCharacters: &linkedCharacters)
        try analyseSubroutines(linkedCharacters: &linkedCharacters)
        try analyseCommands(linkedCharacters: &linkedCharacters) //deve retornar o ponteiro donde parou para a proxima busca
        
    }
    
    func analyseEtVariables(linkedCharacters: inout LinkedList<String>) throws {
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
    
    func analyseVariables(linkedCharacters: inout LinkedList<String>) throws {
        //linkedCharacters.nextNode()
        var value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        repeat {
            if (value == "sidentificador") {
                linkedCharacters.nextNode()
                
                value = linkedCharacters.first?.value.simbolo as? String ?? ""
                
                if (value == "svirgula"
                        || value == "sdoispontos") {
                    
                    if (value == "svirgula") {
                        
                        linkedCharacters.nextNode()
                        value = linkedCharacters.first?.value.simbolo as? String ?? ""
                        
                        if (value == "sdoispontos") {
                            throw sintaticException(name: "SintaticException", message: "Esperava encontrar dois pontos - analyseVariables", stack:linkedCharacters)
                        }
                        
                    }
                }else{
                    throw sintaticException(name: "SintaticException", message: "Esperava encontrar svirgula ou sdois pontos - analyseVariables", stack:linkedCharacters)
                }
                
            }else{
                throw sintaticException(name: "SintaticException", message: "Esperava encontrar identificador - analyseVariables", stack:linkedCharacters)
            }
            
            
        } while (value != "sdoispontos");
        
        linkedCharacters.nextNode()
        try analyseType(linkedCharacters: &linkedCharacters)
        
    }
    
    func analyseType(linkedCharacters: inout LinkedList<String>) throws {
        //linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        if (value != "sinteiro" && value != "sbooleano") {
            throw sintaticException(name: "SintaticException", message: "Esperava encontrar diferente de inteiro ou booleano - analyseType", stack:linkedCharacters)
        }
        linkedCharacters.nextNode()
    }
    
    func analyseCommands(linkedCharacters: inout LinkedList<String>) throws {
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
                        } else {
                            throw sintaticException(name: "SintaticException", message: "Esperava encontrar sfim - analyseCommands", stack: linkedCharacters)
                        }
                    }
                    //linkedCharacters.nextNode()
                    //value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
                    print("\(value)")
                }
                linkedCharacters.nextNode()
                value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            }else {
                throw sintaticException(name: "SintaticException", message: "Esperava encontrar inicio - analyseCommands", stack:linkedCharacters)
            }
    }
    
    func analyseSimpleCommands(linkedCharacters: inout LinkedList<String>) throws {
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
    
    func analyseChProcedure(linkedCharacters: inout LinkedList<String>) throws {
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if (value == "satribuicao") {
            //Analisa_atribuicao
            //TO_DO
            //PASSIVEL DE ERRO - LEMBRAR
            linkedCharacters.nextNode()
            //try analyseFactor(linkedCharacters: &linkedCharacters)
        } else {
            //Chamada_procedimento
            //TO_DO
        }
    }
    
    func analyseRead(linkedCharacters: inout LinkedList<String>) throws {
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if (value == "sabre_parenteses") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            if (value2 == "sidentificador") {
                //Lexico(token)
                linkedCharacters.nextNode()
                let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                
                if (value3 == "sfecha_parenteses") {
                    //Lexico(token)
                    linkedCharacters.nextNode()
                } else {
                    throw sintaticException(name: "SintaticException", message: "Esperava encontrar fecha parenteses - analyseRead", stack:linkedCharacters)
                }
            } else {
                throw sintaticException(name: "SintaticException", message: "Esperava econtrar identificador - analyseRead", stack:linkedCharacters)
            }
        } else {
            throw sintaticException(name: "SintaticException", message: "Esperava-se encontrar final de abre parenteses - analyseRead", stack:linkedCharacters)
        }
    }
    
    func analyseWrite(linkedCharacters: inout LinkedList<String>) throws {
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if (value == "sabre_parenteses") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            if (value2 == "sidentificador") {
                //Lexico(token)
                linkedCharacters.nextNode()
                let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                if (value3 == "sfecha_parenteses") {
                    //Lexico(token)
                    linkedCharacters.nextNode()
                } else {
                    throw sintaticException(name: "SintaticException", message: "Esperava encontrar fecha parenteses - analyseWrite", stack:linkedCharacters)
                }
            } else {
                throw sintaticException(name: "SintaticException", message: "Esperava sidentificador - analyseWrite", stack:linkedCharacters)
            }
        }else {
            throw sintaticException(name: "SintaticException", message: "Esperava abre parenteses - analyseWrite", stack:linkedCharacters)
        }
    }
    
    func analyseWhile(linkedCharacters: inout LinkedList<String>) throws {
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
    
    func analyseIf(linkedCharacters: inout LinkedList<String>) throws {
        linkedCharacters.nextNode()
        //analyse expression
        try analyseExpression(linkedCharacters: &linkedCharacters)
        
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if value == "sentao" {
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            print("entrou senao")
            //analisa comando simples
            try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
            let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
    
            if value3 == "ssenao" {
                print("entrou senao")
    
                linkedCharacters.nextNode()
                //analisa comando simples
                try analyseSimpleCommands(linkedCharacters: &linkedCharacters)
            }
            
        } else {
            
            throw sintaticException(name: "SintaticException", message: "Esperava 'entao' - analyseIf", stack:linkedCharacters)
        }
    }
    
    func analyseSubroutines(linkedCharacters: inout LinkedList<String>) throws {
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
    
    func analyseProcedureDeclaration(linkedCharacters: inout LinkedList<String>) throws {
        //Lexico(token)
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        if (value == "sidentificador") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            if (value2 == "sponto_virgula") {
                //Analisa_bloco
               try blockAnalyser(linkedCharacters: &linkedCharacters)
            } else {
                throw sintaticException(name: "SintaticException", message: "Esperava econtrar ponto e virgula - analyseProcedureDeclaration", stack:linkedCharacters)
            }
        } else {
            throw sintaticException(name: "SintaticException", message: "Esperava econtrar identificador - analyseProcedureDeclaration ", stack:linkedCharacters)
        }
    }
    
    func analyseFunctionDeclaration(linkedCharacters: inout LinkedList<String>) throws {
        //Lexico(token)
        linkedCharacters.nextNode()
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        
        if (value == "sidentificador") {
            //Lexico(token)
            linkedCharacters.nextNode()
            let value2 = linkedCharacters.first?.value.simbolo as? String ?? ""
            if (value2 == "sdoispontos") {
                //Lexico(token)
                linkedCharacters.nextNode()
                let value3 = linkedCharacters.first?.value.simbolo as? String ?? ""
                if (value3 ==  "sinteiro" ||
                        value3 == "sbooleano") {
                    
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
        } else {
            throw sintaticException(name: "SintaticException", message: "Esperava encontrar um identificador - analyseFunctionDeclaration", stack:linkedCharacters)
        }
    }
    
    func analyseExpression(linkedCharacters: inout LinkedList<String>) throws {
        try analyseSimpleExpression(linkedCharacters: &linkedCharacters)
        let value = linkedCharacters.first?.value.simbolo as? String ?? ""
        if value == "smaior" || value == "smaiorig" || value == "sig" || value == "smenor" ||
                value == "smenorig" || value == "sdif" {
            //Lexico(token)
            linkedCharacters.nextNode()
            try analyseSimpleExpression(linkedCharacters: &linkedCharacters)
        }
    }
    
    func analyseSimpleExpression(linkedCharacters: inout LinkedList<String>) throws{
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
    
    func analyseTerm(linkedCharacters: inout LinkedList<String>) throws {
        try analyseFactor(linkedCharacters: &linkedCharacters)
        var value = linkedCharacters.first?.value.simbolo as? String ?? ""
        while(value == "smult"
                || value == "sdiv" || value == "se") {
            linkedCharacters.nextNode()
            try analyseFactor(linkedCharacters: &linkedCharacters)
            value = linkedCharacters.first?.value.simbolo as? String ?? ""
        }
    }
    
    func analyseFactor(linkedCharacters: inout LinkedList<String>) throws {
        var value = linkedCharacters.first?.value
        if value?.simbolo == "sidentificador" {
            //analisa chamada funcao
            linkedCharacters.nextNode()
            value = linkedCharacters.first?.value
    
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
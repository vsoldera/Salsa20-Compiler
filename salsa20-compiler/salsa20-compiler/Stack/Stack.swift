//
//  Stack.swift
//  salsa20-compiler
//
//  Created by Luiz Vinicius Ruoso on 30/10/21.
//

import Foundation

/*
#REF Implementa a estrutura e as opções  para geração de uma stack a partir de um
array basico. 

Em essencia essa struct/classe usa um array sempre removendo o ultimo dado disponivel.
*/


struct Stack<Element> {

    private var items: [Element] = []

    func peek() -> Element? {

        if (items.count == 0) {
            return nil

        }
        return items.last
    }

    mutating func pop() -> Element? {
        if (items.count == 0) {
            return nil

        }
        return items.removeLast()
    }

    
    mutating func push(_ element: Element) {
           items.append(element)
    }



}

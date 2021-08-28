//
// Created by Raven on 28/08/21.
//

import Foundation

struct value {
    var lexema: Any
    var simbolo: Any
}

// 1
public class Node<T> {
    // 2
    var value: value
    var next: Node<T>?
    weak var previous: Node<T>?

    // 3
    init(lexema: T, simbolo: T) {
        self.value.lexema = lexema
        self.value.simbolo = simbolo
    }
}

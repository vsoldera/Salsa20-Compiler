//
// Created by Raven on 28/08/21.
//

import Foundation

struct token_struct {
    var lexema: String
    var simbolo: String
}

// 1
public class Node<T> {
    // 2
    var value: token_struct
    var next: Node<T>?
    weak var previous: Node<T>?

    // 3
    init(lexema: T, simbolo: T) {
        self.value = token_struct(lexema: lexema as! String, simbolo: simbolo as! String)
    }
}

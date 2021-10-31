import Foundation

struct token_struct {
    var lexema: String
    var simbolo: String
}

// 1
public class Node<T> {
    // 2
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?

    // 3
    init(el: T) {
        self.value = el
    }
}

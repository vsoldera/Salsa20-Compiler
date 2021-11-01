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
    var index : Int = 0
    // 3
    init(el: T, n: Int) {
        self.value = el
        self.index = n
    }
}

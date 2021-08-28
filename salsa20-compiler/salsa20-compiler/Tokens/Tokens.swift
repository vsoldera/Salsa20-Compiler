//
// Created by Luiz Vinicius Ruoso on 28/08/21.
//

import Foundation
class Token {
    enum ArithmeticOperator: String {
    case mais = "+"
    case menos = "-"
    case vezes = "*"
    case dividido = "/"
    }

    enum RelationalOperator: String {
    case maior = ">"
    case menor = "<"
    case diferente = "!"
    }

    enum AssignmentOperator: String {
    case igual = "="
    }

    enum CaracterOperator: String {
    case abreChave = "{"
    case fechaChave = "}"
    case abreParenteses = "("
    case fechaParenteses = ")"
    }
}

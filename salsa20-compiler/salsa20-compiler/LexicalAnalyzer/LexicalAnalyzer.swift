//
// Created by Luiz Vinicius Ruoso on 28/08/21.
//

import Foundation

class LexicalAnalyzer: Token {

    
    override init(){

    }
    
    func openFile() throws {
        let filePath = Bundle.main.path(forResource: "theFile", ofType: "txt") ?? <#default value#>
        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        print(data)
    }


    func analyse(){


    }

}
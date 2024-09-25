extension Solutions {
    /// Lintcode: https://www.lintcode.com/problem/659/
    /// Neetcode: https://neetcode.io/problems/string-encode-and-decode
    static func _271_encode(_ strings: [String]) -> String {        
        let delimiter = "%"
        var result = ""

        for string in strings {
            let charCount = String(string.count)
            result.append(charCount)
            result.append(delimiter)
            result.append(string)
        }
        print("encoded string", result)
        return result
    }
    
    static func _271_decode(_ string: String) -> [String] {
        var result = [String]()
        enum ParsingStep { case int, delimiter, string }
        var parsingStep = ParsingStep.int
        let delimiter: Character = "%"
        var lettersLeftToParseInStringElement = 0
        var intString = ""
        var currentString = "" // the string that we're currently building to append to result

        for char in string {
            switch parsingStep {
                case .int: 
                    guard char != delimiter else { 
                        parsingStep = .delimiter
                        fallthrough
                    }
                    intString.append(char)
                case .delimiter: 
                    guard let lettersLeft = Int(intString) else {
                        fatalError("received invalid string: \(string). Failed at character: \(char)")
                    }
                    intString = ""
                    parsingStep = .string
                    lettersLeftToParseInStringElement = lettersLeft
                case .string: 
                    if lettersLeftToParseInStringElement == 1 {
                        currentString.append(char)
                        result.append(currentString)
                        currentString = ""
                        lettersLeftToParseInStringElement = 0
                        parsingStep = .int
                    } else if lettersLeftToParseInStringElement > 1 {
                        currentString.append(char)
                        lettersLeftToParseInStringElement -= 1
                    } else {
                        parsingStep = .int
                        result.append(currentString)
                        currentString = ""
                    }
            }
        }
        return result
    }
}

extension Solutions {
    static func evalRPN(_ tokens: [String]) -> Int {
        var stack = [Int]()

        for token in tokens {
            switch token {
                case "+": 
                stack.append(stack.popLast()! + stack.popLast()!)
                case "-": 
                let b = stack.popLast()
                let a = stack.popLast()
                stack.append(a! - b!)
                case "*": 
                stack.append(stack.popLast()! * stack.popLast()!)
                case "/":
                let b = stack.popLast()
                let a = stack.popLast()
                stack.append(a! / b!)
                default: 
                guard let int = Int(token) else {
                    fatalError("Invalid RPN statement")
                }
                stack.append(int)
            }
        }
        return stack[0]

        
    }
}

extension LinkedList: Equatable where Value: Equatable {
    public static func == (lhs: LinkedList<Value>, rhs: LinkedList<Value>) -> Bool {
        guard !lhs.isEmpty && !rhs.isEmpty else { return true }
        guard lhs.count == rhs.count else { return false }
        for (lValue, rValue) in zip(lhs, rhs) {
            if lValue != rValue { return false }
        }
        return true
    }
}

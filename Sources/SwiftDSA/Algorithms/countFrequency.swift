extension Sequence where Element: Hashable {
    /// count the amount of unique occurences of each value in a type
    public func countFrequency() -> [Element: Int] {
        var result = [Element: Int]()
        for element in self {
            result[element, default: 0] += 1
        }
        return result
    }
}



// MARK: Parallel version
@available(macOS 10.15, iOS 13, *)
extension Collection where Element: Hashable {
    /// Returns a dictionary of the count of each unique value in a collection
    ///
    /// >Time Complexity: O(n), but with parallel execution
    public func countFrequency() async -> [Element: Int] where Element: Sendable {
        let counter = FrequencyCounter<Element>()
        
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    await counter.increment(element)
                }
            }
        }
        
        return await counter.getCounts()
    }
}

private actor FrequencyCounter<Element: Hashable> {
    private var counts: [Element: Int] = [:]
    
    func increment(_ element: Element) {
        counts[element, default: 0] += 1
    }
    
    func getCounts() -> [Element: Int] {
        return counts
    }
}


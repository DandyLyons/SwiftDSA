extension Collection where Element: Hashable {
    /// Check for collection equality while ignoring order
    public func hasSameElements(as c2: Self) -> Bool {
        guard self.count == c2.count else { return false }
        let freq1 = self.countFrequency()
        let freq2 = c2.countFrequency()
        return freq1 == freq2
    }
}

// MARK: Parallel
extension Collection where Element: Hashable & Sendable, Self: Sendable {
    /// Check for collection equality while ignoring order
    @available(macOS 10.15, iOS 13, *)
    func hasSameElements(as c2: Self) async -> Bool {
        guard self.count == c2.count else { return false }
        async let freq1 = self.countFrequency()
        async let freq2 = c2.countFrequency()
        return (await freq1) == (await freq2)
    }
    
}


extension Algorithms {
    
    /// Determines if both collections have the same elements (regardless of order)
    ///
    /// >Time Complexity: O(n)
    public static func haveSameElements<C: Collection>(_ c1: C, _ c2: C) -> Bool where C.Element: Hashable {
        guard c1.count == c2.count else { return false }
        let freq1 = Algorithms.countFrequency(c1)
        let freq2 = Algorithms.countFrequency(c2)
        guard freq1 == freq2 else { return false }
        return true
    }
}

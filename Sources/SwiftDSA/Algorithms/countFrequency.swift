extension Algorithms {
    /// Returns a dictionary of the count each unique value in a dictionary
    ///
    /// >Time Complexity: O(n)
    public static func countFrequency<C: Collection>(_ c1: C) -> [C.Element: Int] {
        var result = [C.Element: Int]()
        for element in c1 {
            result[element, default: 0] += 1
        }
        return result
    }
}

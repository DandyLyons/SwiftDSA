extension XYGrid: CustomStringConvertible where Element: CustomStringConvertible {
    public var description: String {
        var result = ""
        result.append("[\n")
        
        for row in self.rows {
            let rowString: String = "[" + row.map { String(describing: $0) }
                .joined(separator: ", ")
            + "]\n"
            result.append(rowString)
        }
        result.append("\n]")
        
        return result
    }
}

extension XYGrid {
    public struct Coordinate: Hashable, Sendable, Codable {
        public var x: Int
        public var y: Int
        
        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
}

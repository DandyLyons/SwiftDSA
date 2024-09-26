import Testing
import SwiftDSA

@Suite
struct AlgorithmsTests {
    @Test func countFrequency() async throws {
        // create an array of random elements and random length
        let n = Int.random(in: 1...1000)
        var array = [Int]()
        for i in 0..<n {
            array.append(Int.random(in: -100...100))
        }
        
        let frequency = Algorithms.countFrequency(array)
        for (element, count) in frequency {
            #expect(array.count { $0 == element} == count)
        }
    }
}

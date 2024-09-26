import Testing
import SwiftDSA

@Suite
struct AlgorithmsTests {
    let array = (1...100_000).map { _ in Int.random(in: -100...100) }
    
    @Test func countFrequency() throws {
        let frequency = array.countFrequency()
        for (element, count) in frequency {
            #expect(array.count { $0 == element} == count)
        }
    }
    
    @Test func countFrequency_Parallel() async throws {
        let frequency = await array.countFrequency()
        for (element, count) in frequency {
            #expect(array.count { $0 == element} == count)
        }
    }
    
    @Test
    func haveSameElements() {
        let array1 = self.array
        let array2 = array1.shuffled()
        #expect(array1.hasSameElements(as: array2) == true)
    }
    
    @Test
    func haveSameElements_Parallel() async {
        let array1 = self.array
        
        let array2 = array1.shuffled()
        #expect(await array1.hasSameElements(as: array2) == true)
    }
}

import Foundation
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
    func hasSameElements() {
        let array1 = self.array
        let array2 = array1.shuffled()
        #expect(array1.hasSameElements(as: array2) == true)
        
        let set1 = Set(0..<1000)
        let set2 = Set(0..<1000)
        #expect(Array(set1).hasSameElements(as: Array(set2)))
    }
    
    @Test
    func haveSameElements_Parallel() async {
        let array1 = self.array
        
        let array2 = array1.shuffled()
        #expect(await array1.hasSameElements(as: array2) == true)
    }
    
    @Test func value_isEqualTo_by() {
        let array1 = self.array
        let array1Shuffled = array1.shuffled()
        #expect(array1 != array1Shuffled)
        
        struct Person: Equatable {
            let firstName: String
            let lastName: String
            let age: Int
            let id: UUID
        }
        let person1 = Person(firstName: "Blob", lastName: "McBlob", age: 34, id: UUID())
        let person2 = Person(firstName: "Blob", lastName: "McBlob", age: 34, id: UUID())
        #expect(person1 != person2)
        #expect(person1.id != person2.id)
        #expect(value(person1, isEqualTo: person2, by: \.firstName, \.lastName, \.age))
    }
}

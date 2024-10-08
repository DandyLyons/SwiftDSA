@testable import SwiftDSA
import Testing

@Suite struct LinkedListTests {
    @Test func isEmpty() {
        var list: LinkedList<Int> = []
        #expect(list.isEmpty == true)
        list.push(1)
        #expect(list.isEmpty == false)
        list.pop()
        #expect(list.isEmpty == true)
        list.append(2)
        #expect(list.isEmpty == false)
        list.removeLast()
        #expect(list.isEmpty == true)
        list.append(3)
        list.append(4)
        let firstNode = list.node(at: 0)!
        list.remove(after: firstNode)
        #expect(list.isEmpty == false)
        list.removeAll()
        #expect(list.isEmpty == true)
    }
    
    @Test func arrayLiteral() {
        let list: LinkedList = [1,2,3]
        #expect(list.count == 3)
        #expect(list.description == "1 -> 2 -> 3  ")
        
        let emptyList: LinkedList<Int> = []
        #expect(emptyList.count == 0)
        #expect(emptyList.isEmpty == true)
    }
    
    @Test func equatable() {
        var list1: LinkedList = [0, 1, 2]
        var list2: LinkedList = [0, 1, 2]
        #expect(list1 == list2)
        list1.push(3)
        #expect(list1 != list2)
        list2.push(3)
        #expect(list1 == list2)
        
        list1.append(4)
        #expect(list1 == [3, 0, 1, 2, 4])
        
        list1.append([5, 6])
        #expect(list1 == [3, 0, 1, 2, 4, 5, 6])
    }
    
    @Test func pop() {
        var list: LinkedList = [0, 1, 2, 3]
        list.pop()
        #expect(list == [1, 2, 3])
    }
    
    @Test func push() {
        var list = LinkedList<Int>()
        list.push(1)
        list.push(2)
        list.push(3)
        #expect(list.count == 3)
        #expect(list.description == "3 -> 2 -> 1  ")
    }
    
    @Test func append() {
        var list = LinkedList<Int>()
        list.append(0)
        #expect(list.count == 1)
        list.append(1)
        #expect(list.count == 2)
        #expect(list[0] == 0)
        #expect(list[1] == 1)
    }
    
    @Test func removeAll() {
        var list: LinkedList<Int> = [1, 2, 3]
        #expect(list.isEmpty == false)
        list.removeAll()
        #expect(list.isEmpty == true)
    }
    
    @Test func insertValueAfterNode() {
        var list: LinkedList<Int> = [0, 1]
        let firstNode = list.head!
        let secondNode = list.insert(2, after: firstNode)
        #expect(secondNode.value == 2)
        #expect(secondNode.next?.value == 1)
        #expect(list == [0, 2, 1])
        
        list.insert(3, after: secondNode)
        #expect(list == [0, 2, 3, 1])
    }
    
    @Test func subscriptByInt() {
        let list: LinkedList<Int> = [0, 1, 2, 3]
        for int in list {
            #expect(list[int] == int)
        }
        
    }
    
    @Test func removeLast() {
        var list: LinkedList = [0, 1, 2, 3]
        list.removeLast()
        #expect(list == [0, 1, 2])
    }
    
    @Test func nodeAtInt() {
        var list1: LinkedList = [0, 1, 2]
        let node1List1Ref1 = list1.node(at: 1)
        let node1List1Ref2 = list1.node(at: 1)
        #expect(node1List1Ref1 === node1List1Ref2)
        
        var list2 = list1
        let node1List2Ref1 = list2.node(at: 1)
        // copy on write: references should point to same objects
        // if no mutation has happened.
        #expect(node1List2Ref1 === node1List1Ref1)
        #expect(node1List2Ref1 === node1List1Ref2)
        list2.append(3) // mutation
        #expect(list2 == [0, 1, 2, 3])
        let node1List2Ref2 = list2.node(at: 1)
        
        // copy on write should cause references to point to different objects.
        #expect(node1List2Ref1 !== node1List2Ref2)
        #expect(node1List2Ref2 !== node1List1Ref1)
        #expect(node1List2Ref2 !== node1List1Ref2)
    }
    
    @Test func copyNodesIfNecessary() {
        var list: LinkedList = [0, 1, 2]
        let node0Copy1 = list.node(at: 0)
        let node1Copy1 = list.node(at: 1)
        let node2Copy1 = list.node(at: 2)
        
        // Copy on write: References should point to same object if
        // no mutation has occurred.
        let node0Copy2 = list.node(at: 0)
        let node1Copy2 = list.node(at: 1)
        let node2Copy2 = list.node(at: 2)
        #expect(node0Copy1 === node0Copy2)
        #expect(node1Copy1 === node1Copy2)
        #expect(node2Copy1 === node2Copy2)
        
        list.append(3) // mutation
        // Copy on write: References should NOT point to same object if
        // mutation HAS occurred.
        let node0Copy3 = list.node(at: 0)
        let node1Copy3 = list.node(at: 1)
        let node2Copy3 = list.node(at: 2)
        #expect(node0Copy1 !== node0Copy3)
        #expect(node1Copy1 !== node1Copy3)
        #expect(node2Copy1 !== node2Copy3)
    }
    
    @Test func initCollection() {
        let array = [0, 1, 2, 3]
        let linkedList = LinkedList(array)
        #expect(linkedList == [0, 1, 2, 3])
        #expect(linkedList.head?.value == 0)
        #expect(linkedList.tail?.value == 3)
    }
    
    @Test func reversedLinkedList() {
        let linkedList = LinkedList([0, 1, 2, 3])
        let reversedLinkedList = linkedList.reversedLinkedList()
        #expect(reversedLinkedList == [3, 2, 1, 0])
    }
    
    @Test func middleNode() {
        let list1: LinkedList = [1, 2, 3, 4]
        #expect(list1.middleNode()?.value == 3)
        
        let list2: LinkedList = [1, 2, 3]
        #expect(list2.middleNode()?.value == 2)
    }
    
    @Test func appendList() {
        var list1: LinkedList = [0, 1, 2]
        let list2: LinkedList = [3, 4, 5]
        list1.append(list2)
        #expect(list1 == [0, 1, 2, 3, 4, 5])
    }
}

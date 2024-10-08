
/// Merges two pre-sorted linked lists into one sorted linked list
///
/// >Precondition: Both input lists must be pre-sorted or else behavior is undefined.
public func mergeSorted<Value: Comparable>(_ list1: LinkedList<Value>, _ list2: LinkedList<Value>) -> LinkedList<Value> {
    var result = LinkedList<Value>()
    
    var currentList1 = list1.head
    var currentList2 = list2.head
    while currentList1 != nil && currentList2 != nil { // O(n) where n is the count of list1 or list2 (whichever is longest)
        if currentList1!.value < currentList2!.value {
            result.append(currentList1!.value) // O(1)
            currentList1 = currentList1?.next
        } else {
            result.append(currentList2!.value)
            currentList2 = currentList2?.next
        }
    }
    if currentList1 == nil {
        // append remaining currentList2 values
        while currentList2 != nil {
            result.append(currentList2!.value)
            currentList2 = currentList2?.next
        }
    } else {
        // currentList2 must be == nil
        while currentList1 != nil {
            result.append(currentList1!.value)
            currentList1 = currentList1?.next
        }
    }
    return result
}

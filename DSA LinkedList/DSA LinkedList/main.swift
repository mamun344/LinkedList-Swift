//
//  main.swift
//  DSA LinkedList
//
//  Created by Admin on 19/1/24.
//

import Foundation

func block(_ title: String, execution: ()->()){
    print("\n --- \(title) ---")
    execution()
}


public class Node<T> {
    public var value: T
    public var next: Node?
    
    public init(_ value: T, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next else {
            return "\(value)"
        }
        
        return "\(value) > \(next.description)"
    }
}


block("NODE") {
    let n1 = Node(3)
    let n2 = Node(5)
    let n3 = Node(7)
    
    n1.next = n2
    n2.next = n3
    
    print(n1)
}


public struct LinkedList<T> {
    
    public var head: Node<T>?
    public var tail: Node<T>?
    
    public init(head: Node<T>? = nil, tail: Node<T>? = nil) {
        self.head = head
        self.tail = tail
    }
    
    public var isEmpty: Bool {
        head == nil
    }

    public mutating func push(_ value: T){
        head = Node(value, next: head)
        
        if tail == nil {
            tail = head
        }
    }
    
    public mutating func append(_ value: T){
        if isEmpty {
            push(value)
        }
        else {
            tail?.next = Node(value)
            tail = tail?.next
        }
    }
    
    public func node(at index: Int)->Node<T>? {
        if index < 0 || isEmpty {
            return nil
        }
        
        var currentIndex: Int = 0
        var currentNode: Node<T>? = head

        while currentNode != nil, currentIndex < index {
            currentIndex += 1
            currentNode = currentNode?.next
        }
        
        return currentNode
    }
    
    @discardableResult
    public mutating func insert(_ value: T, after node: Node<T>) -> Node<T>? {
        if node.next == nil {
            append(value)
            return tail
        }
        else {
            node.next = Node(value, next: node.next)
            return node.next
        }
    }
    
    @discardableResult
    public mutating func insert(_ value: T, at index: Int) -> Node<T>? {
        if index == 0 {
            push(value)
            return head
        }
        else if let currentNode = node(at: index-1) {
            return insert(value, after: currentNode)
        }
        else {
            return nil
        }
    }
    
    @discardableResult
    public mutating func pop()->T? {
        defer {
            head = head?.next
            
            if isEmpty {
                tail = nil
            }
        }
        
        return head?.value
    }
    
    @discardableResult
    public mutating func removeLast()->T? {
        guard let head else { return nil }
        
        guard head.next != nil else { return pop() }
        
        var current: Node<T>? = head
        var next: Node<T>? = head

        while next?.next != nil {
            current = next
            next = next?.next
        }
        
        current?.next = nil
        tail = current
        
        return next?.value
    }
    
    @discardableResult
    public mutating func removeAfter(_ node: Node<T>)->T? {
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
    
    @discardableResult
    public mutating func remove(at index: Int)->T? {
        if index == 0 {
            return pop()
        }
        
        if index == 1, let head {
            return removeAfter(head)
        }

        guard let node = node(at: index-1) else {
            return nil
        }
        
        return removeAfter(node)
    }
}


extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head else {
            return "Empty Linked List"
        }
        
       return head.description
    }
}

extension LinkedList: Collection {
    
    public struct Index: Comparable {
        public var node: Node<T>?

        public static func == (lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (leftNode?, rightNode?):
                return leftNode === rightNode
                
            case (nil, nil):
                return true
                
            default:
                return false
            }
        }
       
        public static func < (lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            
            let rightNodes = sequence(first: lhs.node) { $0?.next }
            return rightNodes.contains { $0 === rhs.node }
        }
    }
    
    public var startIndex: Index {
        Index(node: head)
    }
    
    public var endIndex: Index {
        Index(node: tail?.next)
    }
    
    public subscript(position: Index) -> T {
        position.node!.value
    }
    
    public func index(after i: Index) -> Index {
        Index(node: i.node?.next)
    }
}



block("Push & Append") {
    var list = LinkedList<Int>()
    list.push(2)
    list.push(4)
    list.push(6)
    
    list.append(0)
    list.append(-2)

    print(list)
}


block("Get Insert") {
    var list = LinkedList<Int>()
    list.push(2)
    list.push(4)
    list.push(6)
    
    let aNode = list.node(at: 1)
    print(String(describing: aNode?.value))
    
    list.insert(5, after: aNode!)
    list.insert(7, after: aNode!)
    print(list)
}


block("Insert Index") {
    var list = LinkedList<Int>()
    list.push(2)
    list.push(4)
    list.push(6)
    
    list.insert(8, at: 1)
    list.insert(10, at: 2)

    print(list)
}

block("Pop") {
    var list = LinkedList<Int>()
    list.push(2)
    list.push(4)
    list.push(6)
    
    print(String(describing: list.pop()))
    
    print(list)
}

block("Remove Last") {
    var list = LinkedList<Int>()
    list.push(2)
    list.push(4)
    list.push(6)
    
    print(String(describing: list.removeLast()))
    
    print(list, list.head?.value, list.tail?.value)
}

block("Remove After") {
    var list = LinkedList<Int>()
    list.push(2)
    list.push(4)
    list.push(6)
    
    let node = list.node(at: 2)!
    
    print(String(describing: list.removeAfter(node)))
    print(list, list.head?.value, list.tail?.value)
}

block("Remove At") {
    var list = LinkedList<Int>()
    list.push(2)
    list.push(4)
    list.push(6)

    print(String(describing: list.remove(at: 3)))
    print(list, list.head?.value, list.tail?.value)
}

block("As Collection") {
    var list = LinkedList<Int>()
    list.push(2)
    list.push(4)
    list.push(6)
    list.push(8)

    print(list)
    print("first", list.first)
    print("start index", list[list.startIndex])
    
    let anIndex = list.index(list.startIndex, offsetBy: 1)
    print("an index", list[anIndex])

    
    print("prefix", Array(list.prefix(3)))
    print("suffix", Array(list.suffix(3)))
    
    let sum = list.reduce(0, +)
    print("sum", sum)

    let leftIndex = list.index(list.startIndex, offsetBy: 1)
    let rightIndex = list.index(list.startIndex, offsetBy: 1)
    
    print("is less", leftIndex < rightIndex)
    
    print("is equal",  leftIndex == rightIndex)
}



block("Challenges-Reverse") {
    var list = LinkedList<Int>()
    list.push(8)
    list.push(6)
    list.push(4)
    list.push(2)

    print(list)

    func printReverseListItem<T>(_ item: Node<T>?){
        guard let node = item else { return }
        printReverseListItem(node.next)
        print(node.value)
    }
  
    printReverseListItem(list.head)
}

block("Challenge: Middle") {
    var list = LinkedList<Int>()
    list.push(8)
    list.push(6)
    list.push(4)
    list.push(2)
    list.push(0)

    print(list)

    var slow = list.head
    var fast = list.head
    
    while fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }
    
    print(slow?.value)
}


block("Challenge: Reverse (by 2nd List)") {
    var list = LinkedList<Int>()
    list.push(8)
    list.push(6)
    list.push(4)
    list.push(2)
    
    print(list)
    
    var newList = LinkedList<Int>()
    
    var node = list.head
    
    while node != nil {
        newList.push(node!.value)
        node = node?.next
    }
    
    print(newList)
}

block("Challenge: Reverse (by Alter Direction)") {
    var list = LinkedList<Int>()
    list.push(8)
    list.push(6)
    list.push(4)
    list.push(2)
    
    print(list)
    
    list.tail = list.head
    
    var prevNode = list.head
    var currentNode = list.head?.next
    prevNode?.next = nil

    while currentNode != nil {
        let temp = prevNode
        
        prevNode = currentNode
        currentNode = currentNode?.next
        
        prevNode?.next = temp
    }
    
    list.head = prevNode
    
    print(list)
}

block("Challenge: Merge two Lists") {
    
//    var list1 = LinkedList<Int>.init(values2: 3, 5, 7)
      
    var list1 = LinkedList<Int>()
    list1.push(19)
    list1.push(17)
    list1.push(11)
    list1.push(9)
    list1.push(7)
    list1.push(5)
    list1.push(3)
    list1.push(1)
    
    print(list1)
    
    var list2 = LinkedList<Int>()
    list2.push(12)
    list2.push(10)
    list2.push(8)
    list2.push(6)
    list2.push(4)
    list2.push(2)
    
    print(list2)
    
    
    var mergedList = LinkedList<Int>()
    
    var current1_Node = list1.head
    var current2_Node = list2.head
    

    while current1_Node != nil, current2_Node != nil {
        if current1_Node!.value <= current2_Node!.value {
            mergedList.append(current1_Node!.value)
            current1_Node = current1_Node?.next
        }
        else {
            mergedList.append(current2_Node!.value)
            current2_Node = current2_Node?.next
        }
    }
    
    if current1_Node != nil {
        while current1_Node != nil {
            mergedList.append(current1_Node!.value)
            current1_Node = current1_Node?.next
        }
    }
    
    if current2_Node != nil {
        while current2_Node != nil {
            mergedList.append(current2_Node!.value)
            current2_Node = current2_Node?.next
        }
    }
    
    print(mergedList, mergedList.head?.value, mergedList.tail?.value)
}




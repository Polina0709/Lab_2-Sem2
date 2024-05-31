//
//  BTreeModel.swift
//  B-Tree
//
//  Created by Polya Melnik on 30.05.2024.
//
import Foundation
import SwiftUI

// Singleton pattern for BTreeModel
class BTreeModel: ObservableObject {
    static let shared = BTreeModel()
    
    private init() { }
    
    @Published var root: TreeNode?
    
    func addNode(value: Int) {
        if let root = self.root {
            self.root = InsertOperation().execute(on: root, value: value)
        } else {
            self.root = TreeNodeFactory.createNode(value: value)
        }
    }

    
    func searchNode(value: Int) -> TreeNode? {
        return SearchOperation().execute(on: self.root, value: value)
    }

    func removeNode(value: Int) {
        let command = RemoveNodeCommand(tree: self, value: value)
        command.execute()
    }
}

// Composite pattern for TreeNode
class TreeNode {
    var value: Int
    var left: TreeNode?
    var right: TreeNode?
    
    init(value: Int) {
        self.value = value
    }
}

// Abstract Factory for creating tree nodes
class TreeNodeFactory {
    static func createNode(value: Int) -> TreeNode {
        return TreeNode(value: value)
    }
}

// Strategy pattern for tree operations
protocol TreeOperation {
    associatedtype Output
    func execute(on tree: TreeNode?, value: Int) -> Output
}

class InsertOperation: TreeOperation {
    func execute(on tree: TreeNode?, value: Int) -> TreeNode? {
        guard let tree = tree else {
            return TreeNode(value: value)
        }
        
        if value < tree.value {
            tree.left = execute(on: tree.left, value: value)
        } else {
            tree.right = execute(on: tree.right, value: value)
        }
        
        return tree
    }
}

class SearchOperation: TreeOperation {
    func execute(on tree: TreeNode?, value: Int) -> TreeNode? {
        guard let tree = tree else { return nil }
        
        if value == tree.value {
            return tree
        } else if value < tree.value {
            return execute(on: tree.left, value: value)
        } else {
            return execute(on: tree.right, value: value)
        }
    }
}

// Command pattern for tree commands
protocol TreeCommand {
    func execute()
    func undo()
}

class RemoveNodeCommand: TreeCommand {
    private let tree: BTreeModel
    private let value: Int
    private var removedNode: TreeNode?

    init(tree: BTreeModel, value: Int) {
        self.tree = tree
        self.value = value
    }

    func execute() {
        removedNode = tree.searchNode(value: value)
        if removedNode != nil {
            tree.root = removeNode(tree.root, value: value)
        }
    }

    func undo() {
        if let node = removedNode {
            tree.addNode(value: node.value)
        }
    }

    private func removeNode(_ root: TreeNode?, value: Int) -> TreeNode? {
        guard let root = root else { return nil }

        if value < root.value {
            root.left = removeNode(root.left, value: value)
        } else if value > root.value {
            root.right = removeNode(root.right, value: value)
        } else {
            if root.left == nil {
                return root.right
            } else if root.right == nil {
                return root.left
            }

            root.value = minValue(root.right)
            root.right = removeNode(root.right, value: root.value)
        }
        return root
    }

    private func minValue(_ node: TreeNode?) -> Int {
        var minValue = node?.value ?? 0
        var current = node
        while let left = current?.left {
            minValue = left.value
            current = left
        }
        return minValue
    }
}

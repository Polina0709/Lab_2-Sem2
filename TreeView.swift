//
//  TreeView.swift
//  B-Tree
//
//  Created by Polya Melnik on 30.05.2024.
//

import SwiftUI

struct TreeView: View {
    var node: TreeNode?
    
    var body: some View {
        VStack {
            if let node = node {
                TreeNodeDecorator(decoratedNode: node).display()
                HStack {
                    TreeView(node: node.left)
                    TreeView(node: node.right)
                }
            } else {
                EmptyView()
            }
        }
    }
}

// Decorator pattern for tree nodes
class TreeNodeDecorator {
    private let decoratedNode: TreeNode
    
    init(decoratedNode: TreeNode) {
        self.decoratedNode = decoratedNode
    }
    
    func display() -> some View {
        Text("\(decoratedNode.value)")
            .padding()
            .background(Color.yellow)
            .cornerRadius(8)
    }
}

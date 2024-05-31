//
//  ContentView.swift
//  B-Tree
//
//  Created by Polya Melnik on 30.05.2024.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var treeModel = BTreeModel.shared
    @State private var caretaker = TreeCaretaker()
    @State private var inputValue: String = ""
    @State private var deleteValue: String = ""
    @State private var searchValue: String = ""
    @State private var searchResult: String = ""

    var body: some View {
        VStack {
            TextField("Enter value to add", text: $inputValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if let value = Int(inputValue) {
                    let command = AddNodeCommand(tree: treeModel, value: value)
                    caretaker.save(state: treeModel.root)
                    command.execute()
                }
                inputValue = ""
            }) {
                Text("Add Node")
            }
            .padding()

            HStack {
                TextField("Enter value to delete", text: $deleteValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    if let value = Int(deleteValue) {
                        let command = RemoveNodeCommand(tree: treeModel, value: value)
                        caretaker.save(state: treeModel.root)
                        command.execute()
                    }
                    deleteValue = ""
                }) {
                    Text("Delete Node")
                }
                .padding()
            }

            HStack {
                TextField("Enter value to search", text: $searchValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    if let value = Int(searchValue) {
                        if let node = treeModel.searchNode(value: value) {
                            searchResult = "Found node with value: \(node.value)"
                        } else {
                            searchResult = "Node with value \(value) not found"
                        }
                    }
                    searchValue = ""
                }) {
                    Text("Search Node")
                }
                .padding()
            }

            Text(searchResult)
                .padding()

            Button(action: {
                treeModel.root = caretaker.restore()
            }) {
                Text("Undo")
            }
            .padding()

            TreeView(node: treeModel.root)
                .padding()
        }
    }
    // Command pattern for tree commands
    class AddNodeCommand: TreeCommand {
        private let tree: BTreeModel
        private let value: Int
        
        init(tree: BTreeModel, value: Int) {
            self.tree = tree
            self.value = value
        }
        
        func execute() {
            tree.addNode(value: value)
        }
        
        func undo() {
            // Implement undo add node logic
            // For simplicity, this example does not provide undo functionality
        }
    }

    // Memento pattern for saving and restoring tree state
    class TreeCaretaker {
        private var mementos: [TreeMemento] = []
        
        func save(state: TreeNode?) {
            mementos.append(TreeMemento(state: state))
        }
        
        func restore() -> TreeNode? {
            return mementos.popLast()?.state
        }
    }

    class TreeMemento {
        let state: TreeNode?
        
        init(state: TreeNode?) {
            self.state = state
        }
    }
}

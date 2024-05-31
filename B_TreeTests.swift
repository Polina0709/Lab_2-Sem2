//
//  B_TreeTests.swift
//  B-TreeTests
//
//  Created by Polya Melnik on 30.05.2024.
//
import XCTest
@testable import B_Tree // Замість "YourAppName" введіть назву вашого додатку або модуля

class BTreeModelTests: XCTestCase {

    var treeModel: BTreeModel?

    override func setUp() {
        super.setUp()
        treeModel = BTreeModel.shared
    }

    override func tearDown() {
        treeModel = nil
        super.tearDown()
    }

    func testAddNode() {
        treeModel?.addNode(value: 5)
        treeModel?.addNode(value: 3)
        treeModel?.addNode(value: 7)
        treeModel?.addNode(value: 2)
        
        XCTAssertEqual(treeModel?.root?.value, 5)
        XCTAssertEqual(treeModel?.root?.left?.value, 3)
        XCTAssertEqual(treeModel?.root?.left?.left?.value, 2)
        XCTAssertEqual(treeModel?.root?.right?.value, 7)
    }

    func testRemoveNode() {
        treeModel?.addNode(value: 5)
        treeModel?.addNode(value: 3)
        treeModel?.addNode(value: 7)
        treeModel?.addNode(value: 2)

        treeModel?.removeNode(value: 3)
        XCTAssertNil(treeModel?.searchNode(value: 3))
        XCTAssertEqual(treeModel?.root?.left?.value, 2)
    }

    func testSearchNode() {
        treeModel?.addNode(value: 5)
        treeModel?.addNode(value: 3)
        treeModel?.addNode(value: 7)
        treeModel?.addNode(value: 2)

        let foundNode = treeModel?.searchNode(value: 7)
        XCTAssertNotNil(foundNode)
        XCTAssertEqual(foundNode?.value, 7)
    }
}


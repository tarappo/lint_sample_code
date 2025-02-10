//
//  lintTests.swift
//  lintTests
//
//  Created by Toshiyuki Hirata on 2025/02/02.
//

import Testing
import SwiftSyntax
import SwiftParser

struct lintTests {

    @Test func example() async throws {
        let source = """
        let a = 10
        let b = 20
        func testExample() {
        }
        func sample() {
        }
        """
        // ソースコードを構文ツリーに変換
        let sourceFile = Parser.parse(source: source)
        print(sourceFile)

        let finder = VariableFinder(targetVariable: "a")
        // 構文ツリーを巡回（対応する `visit` 関数を呼び出す）
        finder.walk(sourceFile)

        if finder.found {
            print("変数 '\(finder.targetVariable)' がコード内に存在します。")
        } else {
            print("変数 '\(finder.targetVariable)' は見つかりませんでした。")
        }
    }
 
    // Visitor
    class VariableFinder: SyntaxVisitor {
        let targetVariable: String
        var found = false
        
        init(targetVariable: String) {
            self.targetVariable = targetVariable
            // 構文解析の際の対象範囲（.allは暗黙的なノードも含めて解析）
            super.init(viewMode: .all)
        }

        // IdentifierPatternSyntax：識別子の構文ノード（変数、定数の識別子を解析するノード）
        override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
            if node.identifier.text == targetVariable {
                print("見つかった変数: \(node.identifier.text)")
                found = true
            }
            return .visitChildren
        }

        override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
            let functionName = node.name.text
            if functionName.hasPrefix("test") {
                print("見つかったテスト関数: \(functionName)")
            }
            return .visitChildren
        }
    }
}

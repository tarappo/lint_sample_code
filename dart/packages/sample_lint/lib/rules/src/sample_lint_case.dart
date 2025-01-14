import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

// サンプルLintケース
class SampleLintCase extends DartLintRule {
  const SampleLintCase() : super(code: _code);

  // IDEに表示されるメッセージ
  static const _code = LintCode(
      name: 'sample_lint_case',
      problemMessage: 'サンプルLintケース',
      errorSeverity: error.ErrorSeverity.WARNING);

  @override
  List<String> get filesToAnalyze => const ['test/**_test.dart'];

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    // functionの中身を探索
    context.registry.addFunctionDeclaration((node) {
      if (node.functionExpression.body is BlockFunctionBody) {
        final blockBody = node.functionExpression.body as BlockFunctionBody;
        _checkStatementsForGroup(blockBody.block.statements, reporter);
      }
    });
  }

  void _checkStatementsForGroup(
      List<Statement> statements, ErrorReporter reporter) {
    for (var statement in statements) {
      if (statement is !ExpressionStatement) {
        continue;
      }
      final expression = statement.expression;
      if (expression is !MethodInvocation) {
        continue;
      }
      if (expression.methodName.name != 'group') {
        continue;
      }

      for (var arg in expression.argumentList.arguments) {
        if (arg is StringLiteral) {
          final testGroupName = arg.stringValue!;
          if (testGroupName.contains("サンプル")) {
            reporter.atNode(arg, _code);
          }
        }
      }
    }
  }
}

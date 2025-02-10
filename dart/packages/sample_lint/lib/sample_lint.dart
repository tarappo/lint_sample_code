import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sample_lint/rules/src/sample_lint_case.dart';

PluginBase createPlugin() => _SampleLinter();

class _SampleLinter extends PluginBase {
  // 利用するカスタムルールをリストアップ
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const SampleLintCase(),
      ];
}

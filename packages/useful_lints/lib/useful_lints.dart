import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'lints/disposable_lints.dart';

// This is the entrypoint of our custom linter
PluginBase createPlugin() => _UsefulLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
class _UsefulLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        DisposableLintRule(),
      ];
}

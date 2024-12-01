import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const _changeNotifierChecker = TypeChecker.fromName('ChangeNotifier');

class DisposableLintRule extends DartLintRule {
  const DisposableLintRule() : super(code: _code);

  /// Metadata about the warning that will show-up in the IDE.
  /// This is used for `// ignore: code` and enabling/disabling the lint
  static const _code = LintCode(
    name: 'must_close_or_dispose_disposables',
    problemMessage:
        'You must close or dispose of your disposables in dispose()',
    errorSeverity: ErrorSeverity.ERROR,
    correctionMessage: 'Dispose of your disposables in dispose()',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration(
      (node) {
        if (node.extendsClause?.superclass.element?.name != 'State') return;
        final List<FieldDeclaration> changeNotifierProperties = node.members
            .where(
              (member) {
                if (member is! FieldDeclaration) return false;
                if (member.isStatic) return false;
                return member.fields.variables.any(
                  (element) {
                    final type = element.initializer?.staticType;
                    if (type == null) return false;

                    return _changeNotifierChecker.isAssignableFromType(type);
                  },
                );
              },
            )
            .whereType<FieldDeclaration>()
            .toList(growable: false);
        if (changeNotifierProperties.isEmpty) return;
        final disposeMethod = node.members.firstWhereOrNull(
          (member) {
            if (member is! MethodDeclaration) return false;
            return member.name.lexeme == 'dispose';
          },
        );
        if (disposeMethod == null) {
          for (var property in changeNotifierProperties) {
            reporter.atOffset(
              offset: property.offset,
              length: property.length,
              errorCode: _code,
            );
          }
          return;
        }
        final entities = disposeMethod.childEntities;
        final statements =
            entities.whereType<BlockFunctionBody>().first.block.statements;

        final changeNotifierPropertiesNames = changeNotifierProperties
            .expand((element) => element.fields.variables)
            .map((e) => e.name.lexeme)
            .toList();
        for (final name in changeNotifierPropertiesNames) {
          final statement = statements.firstWhereOrNull(
            (element) {
              if (element is! ExpressionStatement) return false;
              final expression = element.expression;
              if (expression is! MethodInvocation) return false;
              final target = expression.target;
              if (target is! SimpleIdentifier) return false;
              return target.name == name;
            },
          );
          if (statement == null) {
            final property = changeNotifierProperties.firstWhere(
              (element) => element.fields.variables.any(
                (element) => element.name.lexeme == name,
              ),
            );
            reporter.atOffset(
              offset: property.offset,
              length: property.length,
              errorCode: _code,
            );
          }
        }
      },
    );
  }
}

class _DisposeFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    final node = analysisError.data;
    if (node is! FieldDeclaration) return;
    final name = node.fields.variables.first.name;
    final disposeMethod =
        node.thisOrAncestorOfType<ClassDeclaration>()?.members.firstWhereOrNull(
      (element) {
        if (element is! MethodDeclaration) return false;
        return element.name.lexeme == 'dispose';
      },
    );
    if (disposeMethod == null) return;
    final statements = disposeMethod.childEntities
        .whereType<BlockFunctionBody>()
        .first
        .block
        .statements;
    final statement = statements.firstWhereOrNull(
      (element) {
        if (element is! ExpressionStatement) return false;
        final expression = element.expression;
        if (expression is! MethodInvocation) return false;
        final target = expression.target;
        if (target is! SimpleIdentifier) return false;
        return target.name == name;
      },
    );
    if (statement != null) return;
    final property = node.fields.variables.first;
    final offset = property.offset;
    final length = property.length;
    final source = resolver.source;
  }
}

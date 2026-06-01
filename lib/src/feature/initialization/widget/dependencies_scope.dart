import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/initialization/model/dependencies_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// {@template dependencies_scope}
/// A scope that provides composed [DependenciesContainer].
///
/// **Testing**:
///
/// To use [DependenciesScope] in tests, it is needed to wrap the widget with
/// [DependenciesScope], extend [TestDependenciesContainer] and provide the
/// dependencies that are needed for the test.
///
/// ```dart
/// class AuthDependenciesContainer extends TestDependenciesContainer {
///   // for example, use mocks created by mockito, or pass fake/real implementations
///   // via constructor.
///   @override
///   final MockAuthRepository authRepository = MockAuthRepository();
/// }
/// ```
/// {@endtemplate}
class const DependenciesScope({
  required super.child,

  /// Container with dependencies.
  required final DependenciesContainer dependencies,
  super.key,
}) extends InheritedWidget {
  /// {@macro dependencies_scope}
  this;

  /// Get the dependencies from the [context].
  static DependenciesContainer of(BuildContext context) => context.inhOf<DependenciesScope>(listen: false).dependencies;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DependenciesContainer>('dependencies', dependencies));
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => !identical(dependencies, oldWidget.dependencies);
}

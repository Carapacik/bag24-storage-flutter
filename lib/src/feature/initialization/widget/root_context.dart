import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/authentication/widget/authentication_scope.dart';
import 'package:bag24/src/feature/initialization/logic/composition_root.dart';
import 'package:bag24/src/feature/initialization/widget/bloc_scope.dart';
import 'package:bag24/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:bag24/src/feature/initialization/widget/material_context.dart';
import 'package:bag24/src/feature/settings/widget/settings_scope.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// {@template app}
/// [RootContext] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it can be
/// placed here.
/// {@endtemplate}
class const RootContext({
  /// The result from the [CompositionRoot], required to launch the application.
  required final CompositionResult compositionResult,
  super.key,
}) extends StatelessWidget {
  /// {@macro app}
  this;

  @override
  Widget build(BuildContext context) => DefaultAssetBundle(
    bundle: SentryAssetBundle(),
    child: DependenciesScope(
      dependencies: compositionResult.dependencies,
      child: const AuthenticationScope(
        child: SettingsScope(
          child: BlocScope(child: WindowSizeScope(child: MaterialContext())),
        ),
      ),
    ),
  );
}

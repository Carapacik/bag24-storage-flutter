import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/core/utils/logger/logger.dart';
import 'package:bag24/src/feature/luggage_order/widget/photo_rules_screen.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const TakePhotoScreen({super.key}) extends StatefulWidget {
  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState() extends State<TakePhotoScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _cameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_initializeCameraController(null));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      unawaited(cameraController.dispose());
    } else if (state == AppLifecycleState.resumed) {
      unawaited(_initializeCameraController(cameraController.description));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_controller?.dispose());
    super.dispose();
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      return await _controller!.setDescription(cameraDescription);
    } else {
      return await _initializeCameraController(cameraDescription);
    }
  }

  Future<void> _initializeCameraController(CameraDescription? cameraDescription) async {
    if (cameraDescription == null && _cameras == null) {
      _cameras = await availableCameras();
    }
    if (_cameras == null || _cameras!.isEmpty) {
      if (mounted) {
        showErrorMessage(context, context.l10n.camerasNotFound);
      }
      return;
    }
    final cameraController = CameraController(
      cameraDescription ?? _cameras![0],
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
    );

    _controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showErrorMessage(context, 'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      if (!mounted) {
        return;
      }
      switch (e.code) {
        case 'CameraAccessDenied':
          showErrorMessage(context, context.l10n.cameraAccessDenied);
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showErrorMessage(context, context.l10n.cameraAccessDeniedWithoutPrompt);
        case 'CameraAccessRestricted':
          // iOS only
          showErrorMessage(context, context.l10n.cameraAccessRestricted);
        case 'AudioAccessDenied':
          showErrorMessage(context, context.l10n.audioAccessDenied);
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showErrorMessage(context, context.l10n.audioAccessDeniedWithoutPrompt);
        case 'AudioAccessRestricted':
          // iOS only
          showErrorMessage(context, context.l10n.audioAccessRestricted);
        default:
          _showCameraException(e);
      }
    }

    if (mounted) {
      setState(() => _cameraInitialized = true);
    }
  }

  Future<void> _setFlashMode(FlashMode mode) async {
    if (_controller == null) {
      return;
    }

    try {
      await _controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    showErrorMessage(context, 'Error: ${e.code}\n${e.description}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: _controller != null && _controller!.value.isInitialized && _cameraInitialized
                  ? CameraPreview(_controller!)
                  : const CircularProgressIndicator.adaptive(),
            ),
            if (_cameraInitialized)
              Positioned(
                top: 12,
                left: 16,
                child: IconButton(
                  onPressed: () async => await _setFlashMode(
                    _controller?.value.flashMode == FlashMode.off ? FlashMode.auto : FlashMode.off,
                  ),
                  icon: SvgPicture.asset(Assets.svg.cameraFlash.path, height: 32, width: 32),
                ),
              ),
            Positioned(
              top: 12,
              right: 16,
              child: IconButton(
                onPressed: () async {
                  final WindowSize windowSize = WindowSizeScope.of(context, listen: false);
                  await windowSize.maybeMap(
                    compact: () => Navigator.of(context).push(
                      MaterialPageRoute<String>(builder: (context) => const PhotoRulesScreen(showPhotoButtons: false)),
                    ),
                    orElse: () => showDialog<String>(
                      context: context,
                      builder: (context) => const PhotoRulesScreen(showPhotoButtons: false),
                    ),
                  );
                },
                icon: SvgPicture.asset(Assets.svg.cameraTutorial.path, height: 32, width: 32),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Material(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton.filled(
                        onPressed: () async => await Navigator.of(context).maybePop(),
                        style: IconButton.styleFrom(backgroundColor: AppColors.darkBadgeBgSecondary),
                        icon: SvgPicture.asset(
                          Assets.svg.close.path,
                          height: 20,
                          width: 20,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final Logger logger = context.dependencies.logger;
                          try {
                            final XFile? image = await _controller?.takePicture();
                            if (context.mounted && image?.path != null) {
                              context.pop(image!.path);
                            }
                          } on Object catch (e) {
                            logger.error('Take picture error', error: e);
                          }
                        },
                        icon: SvgPicture.asset(Assets.svg.cameraButton.path, height: 64, width: 64),
                      ),
                      SizedBox(
                        height: 44,
                        width: 44,
                        child: _cameras == null || _cameras!.isEmpty || _cameras!.length < 2
                            ? null
                            : IconButton.filled(
                                onPressed: () async {
                                  if (_controller?.description == _cameras![0]) {
                                    await _onNewCameraSelected(_cameras![1]);
                                  } else if (_controller?.description == _cameras![1]) {
                                    await _onNewCameraSelected(_cameras![0]);
                                  }
                                },
                                style: IconButton.styleFrom(backgroundColor: AppColors.darkBadgeBgSecondary),
                                icon: SvgPicture.asset(
                                  Assets.svg.update.path,
                                  height: 20,
                                  width: 20,
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

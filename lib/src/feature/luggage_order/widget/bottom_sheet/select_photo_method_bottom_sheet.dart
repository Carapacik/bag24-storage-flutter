import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/regex.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

Future<String?> showSelectPhotoMethodBottomSheet(BuildContext context) => showCustomModalBottomSheet<String>(
  context: context,
  useRootNavigator: true,
  padding: const EdgeInsets.all(16),
  builder: (_) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTonalButton(
            onPressed: () async {
              final NavigatorState navigator = Navigator.of(context);
              final String? filePath = await context.pushNamed<String>(Routes.takePhoto.name);
              if (filePath == null) {
                return;
              }
              navigator.pop(filePath);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.takePhoto),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  Assets.svg.takePhotoAction.path,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomTonalButton(
            onPressed: () async {
              final NavigatorState navigator = Navigator.of(context);
              final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
              if (file == null) {
                return;
              }
              if (!AppRegExp.validPhotoExtensions.contains(p.extension(file.path).toLowerCase()) && context.mounted) {
                showErrorMessage(context, context.l10n.invalidImageExtension);
                return;
              }
              navigator.pop(file.path);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.chooseFromGallery),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  Assets.svg.gallery.path,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
);

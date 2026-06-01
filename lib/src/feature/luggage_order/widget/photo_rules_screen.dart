import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/core/utils/regex.dart';
import 'package:bag24/src/feature/luggage_order/widget/bottom_sheet/select_photo_method_bottom_sheet.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/info_container.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class const PhotoRulesScreen({final bool showPhotoButtons = true, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final List<({String description, String title})> rules = [
      (title: context.l10n.portraitPhotography, description: context.l10n.portraitPhotographyDescription),
      (title: context.l10n.lighting, description: context.l10n.lightingDescription),
    ];
    final List<Widget> children = [
      InfoContainer(title: context.l10n.luggagePhoto, text: context.l10n.toPlaceYourOrderCorrectly),
      const SizedBox(height: 20),
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        itemCount: rules.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.fromLTRB(60, 16, 0, 16),
          child: Divider(height: 1, thickness: 1, color: context.colors.borderPrimary),
        ),
        itemBuilder: (context, index) {
          return _RuleWidget(number: index + 1, title: rules[index].title, description: rules[index].description);
        },
      ),
    ];
    return windowSize.maybeMap(
      compact: () => Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            onPressed: () async => await Navigator.of(context).maybePop(),
            icon: SvgPicture.asset(
              Assets.svg.close.path,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.paddingOf(context).bottom + 90),
              children: [
                Text(context.l10n.howToPhotographLuggage, style: context.textStyles.title1Emphasized),
                const SizedBox(height: 24),
                ...children,
              ],
            ),
            PinnedBottomWidget(
              child: showPhotoButtons
                  ? GradientElevatedButton(
                      onPressed: () async {
                        final NavigatorState navigator = Navigator.of(context);
                        final String? photo = await showSelectPhotoMethodBottomSheet(context);
                        if (photo == null) {
                          return;
                        }
                        navigator.pop(photo);
                      },
                      child: Text(context.l10n.addPhoto),
                    )
                  : CustomTonalButton(onPressed: () => Navigator.of(context).pop(), text: context.l10n.close),
            ),
          ],
        ),
      ),
      orElse: () => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: windowSize.isCompact ? 16 : ((MediaQuery.sizeOf(context).width - compactMaxWidth) / 2 - 16),
        ),
        backgroundColor: context.colors.baseBgPrimary,
        surfaceTintColor: context.colors.baseBgPrimary,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(context.l10n.howToPhotographLuggage, style: context.textStyles.title1Emphasized),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: context.colors.iconPrimaryInverse, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(padding: EdgeInsets.zero, shrinkWrap: true, children: children),
              ),
              const SizedBox(height: 24),
              if (showPhotoButtons)
                Row(
                  children: [
                    Expanded(
                      child: CustomTonalButton(
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTonalButton(
                        onPressed: () async {
                          final NavigatorState navigator = Navigator.of(context);
                          final XFile? file = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 60,
                          );
                          if (file == null) {
                            return;
                          }
                          if (!AppRegExp.validPhotoExtensions.contains(p.extension(file.path).toLowerCase()) &&
                              context.mounted) {
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
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: CustomTonalButton(onPressed: () => Navigator.of(context).pop(), text: context.l10n.close),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _RuleWidget({required final int number, required final String title, required final String description})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          width: 44,
          child: DecoratedBox(
            decoration: ShapeDecoration(color: context.colors.buttonBgTertiary, shape: const CircleBorder()),
            child: Center(
              child: Text(
                number.toString(),
                style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textStyles.bodyEmphasized),
              const SizedBox(height: 4),
              Text(
                description,
                style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

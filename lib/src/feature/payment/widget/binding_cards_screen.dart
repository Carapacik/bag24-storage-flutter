import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:bag24/src/feature/payment/model/binding_model.dart';
import 'package:bag24/src/feature/payment/model/payment_system_enum.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:bag24/src/feature/shared_widgets/modal/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const BindingCardsScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BindingCardsBloc bloc = context.read<BindingCardsBloc>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<BindingCardsBloc, BindingCardsState>(
        listener: (context, state) {
          state.mapOrNull(
            failure: (s) => showCustomAppException(context, s.exception),
            success: (s) {
              if (s.isCardRemoved) {
                showSuccessMessage(context, context.l10n.cardDeletedSuccess);
              }
            },
          );
        },
        child: Scaffold(
          appBar: CustomAppBar(titleText: context.l10n.paymentMethods),
          body: BlocBuilder<BindingCardsBloc, BindingCardsState>(
            builder: (context, state) {
              return state.maybeMap(
                processing: (value) => ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) => const Shimmer(
                    child: ShimmerLoading(inProgress: true, child: SizedBox(height: 84, width: double.infinity)),
                  ),
                ),
                orElse: () {
                  if (state.cards.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Assets.images.wallet.path, width: 160, height: 160),
                            const SizedBox(height: 20),
                            Text(
                              context.l10n.noSavedCards,
                              style: context.textStyles.title2Emphasized,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              context.l10n.addCardPrompt,
                              style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + MediaQuery.paddingOf(context).bottom),
                    itemCount: state.cards.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final BindingModel card = state.cards[index];
                      return _CardItem(
                        key: ValueKey(card.id),
                        card: card,
                        onRemoveTap: () async {
                          final bool? result = await showCustomAlertDialog(
                            context: context,
                            title: context.l10n.deleteCardConfirmation,
                            content: context.l10n.autoPaymentDisableWarning,
                            actionText: context.l10n.delete,
                            cancelText: context.l10n.keepCard,
                            actionTextColor: context.colors.error,
                          );
                          if ((result ?? false) && context.mounted) {
                            bloc.add(BindingCardsEvent.removeCard(card.id));
                          }
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class const _CardItem({required final BindingModel card, required final VoidCallback onRemoveTap, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PaymentSystemEnum type = PaymentSystemEnum.fromString(card.cardType);
    return Material(
      color: context.colors.buttonBgTertiary,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SvgPicture.asset(type.imagePath, width: 44, height: 44),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(type.localizedText(context, card.last4), style: context.textStyles.bodyRegular)),
            const SizedBox(width: 12),
            IconButton(
              onPressed: onRemoveTap,
              icon: SvgPicture.asset(
                Assets.svg.trash.path,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

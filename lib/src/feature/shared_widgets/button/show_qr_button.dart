import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/widget/bottom_sheet/qr_code_bottom_sheet.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class const ShowQrButton({
  required final String orderId,
  required final OrderStatus orderStatus,
  final List<String> luggageIds = const <String>[],
  final bool needPay = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.buttonBgSecondaryInverse,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: context.colors.borderSecondary),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          if (orderStatus == OrderStatus.paying) {
            showInfoMessage(context, context.l10n.waitForPaymentConfirmation);
            return;
          }
          if ((orderStatus == OrderStatus.deposited || orderStatus == OrderStatus.partiallyWithdrawn) &&
              luggageIds.isEmpty) {
            showInfoMessage(context, context.l10n.forWithdrawLuggageSelectFromList);
          } else {
            await showQRCodeBottomSheet(context, orderId: orderId, orderStatus: orderStatus, luggageIds: luggageIds);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  QrImageView(
                    size: 80,
                    eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: context.colors.iconPrimaryInverse),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: context.colors.iconPrimaryInverse,
                    ),
                    data: orderId,
                  ),
                  Positioned.fill(
                    child: Align(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(color: context.colors.baseBgPrimary, shape: const CircleBorder()),
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.svg.maximize.path,
                              height: 16,
                              width: 16,
                              colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(switch (orderStatus) {
                      OrderStatus.pending => context.l10n.showQRCodeToEmployeeForPayAndDeposit,
                      OrderStatus.created => context.l10n.showQRCodeToEmployeeForPayAndDeposit,
                      OrderStatus.deleted => '',
                      OrderStatus.declined => '',
                      OrderStatus.paying => context.l10n.showQRCodeToEmployeeForDeposit,
                      OrderStatus.paid => context.l10n.showQRCodeToEmployeeForDeposit,
                      OrderStatus.depositing => context.l10n.showQRCodeToEmployeeForDeposit,
                      OrderStatus.deposited =>
                        needPay
                            ? context.l10n.showQRCodeToEmployeeForPayAndWithdraw
                            : context.l10n.showQRCodeToEmployeeForWithdraw,
                      OrderStatus.withdrawing =>
                        needPay
                            ? context.l10n.showQRCodeToEmployeeForPayAndWithdraw
                            : context.l10n.showQRCodeToEmployeeForWithdraw,
                      OrderStatus.partiallyWithdrawn =>
                        needPay
                            ? context.l10n.showQRCodeToEmployeeForPayAndWithdraw
                            : context.l10n.showQRCodeToEmployeeForWithdraw,
                      OrderStatus.withdrawn => '',
                    }, style: context.textStyles.subheadlineRegular),
                    Text(
                      context.l10n.codeUpdatedEveryMinutes(10),
                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

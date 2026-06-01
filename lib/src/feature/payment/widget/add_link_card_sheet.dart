import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/payment/model/binding_model.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class const AddLinkCardBottomSheet({final bool showBindCardSwitch = true, final bool showAutoCharge = false, super.key})
    extends StatefulWidget {
  @override
  State<AddLinkCardBottomSheet> createState() => _AddLinkCardBottomSheetState();
}

class _AddLinkCardBottomSheetState() extends State<AddLinkCardBottomSheet> {
  bool _enableAutoCharge = false;
  bool _isBindCard = false;
  bool _isAutoCharge = false;

  @override
  void initState() {
    super.initState();
    if (!widget.showBindCardSwitch) {
      _enableAutoCharge = true;
      _isAutoCharge = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.l10n.doYouWantToSaveCardToPay, style: context.textStyles.title3Emphasized),
        const SizedBox(height: 16),
        if (widget.showBindCardSwitch) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.linkCardToYourAccount, style: context.textStyles.bodyRegular),
              const SizedBox(width: 10),
              StatefulBuilder(
                builder: (context, setStateSB) {
                  return CupertinoSwitch(
                    value: _isBindCard,
                    onChanged: (value) {
                      setState(() {
                        _isBindCard = value;
                        if (widget.showAutoCharge) {
                          _isAutoCharge = value;
                          _enableAutoCharge = value;
                        }
                      });
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (widget.showAutoCharge) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.enableAutoPayment,
                    style: context.textStyles.bodyRegular.copyWith(
                      color: _enableAutoCharge ? null : context.colors.textTertiary,
                    ),
                  ),
                  if (!_enableAutoCharge)
                    Text(
                      context.l10n.enableCardBinding,
                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              CupertinoSwitch(
                value: _isAutoCharge,
                onChanged: _enableAutoCharge ? (value) => setState(() => _isAutoCharge = value) : null,
              ),
            ],
          ),
          const SizedBox(height: 22),
        ],
        SizedBox(
          width: double.infinity,
          child: GradientElevatedButton(
            onPressed: () {
              context.pop(BindingResult(isBindCard: _isBindCard, isAutoCharge: _isAutoCharge));
            },
            text: context.l10n.toContinue,
          ),
        ),
        SizedBox(height: MediaQuery.paddingOf(context).bottom),
      ],
    );
  }
}

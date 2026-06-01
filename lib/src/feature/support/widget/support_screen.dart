import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/location/model/location_model.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/input_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/round_checkbox.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:bag24/src/feature/shared_widgets/text_field/text_field.dart';
import 'package:bag24/src/feature/support/bloc/contact_support/contact_support_bloc.dart';
import 'package:bag24/src/feature/support/model/contact_support_data.dart';
import 'package:bag24/src/feature/support/model/service_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const SupportScreen({final String? airport, final String? orderId, super.key}) extends StatefulWidget {
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState() extends State<SupportScreen> {
  String? _selectedAirport;
  ServiceType _selectedService = ServiceType.storageCamera;
  late final TextEditingController _topicController = TextEditingController();
  late final TextEditingController _commentController = TextEditingController();
  final List<ServiceType> _services = ServiceType.values;

  final ValueNotifier<String?> _airportError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _serviceError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _topicError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _commentError = ValueNotifier<String?>(null);
  late final Listenable _formListenable;

  @override
  void initState() {
    super.initState();
    _selectedAirport = widget.airport;
    _formListenable = Listenable.merge([_topicController, _commentController])..addListener(_onChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.orderId != null && widget.orderId!.isNotEmpty) {
        _topicController.value = TextEditingValue(text: context.l10n.orderByNumber(widget.orderId!));
      }
    });
  }

  void _onChange() {
    _airportError.value = null;
    _serviceError.value = null;
    _topicError.value = null;
    _commentError.value = null;
  }

  late final List<String? Function(ContactSupportData data)> _validators = [
    (data) => _commentError.value = data.isValidComment(context),
    (data) => _topicError.value = data.isValidTopic(context),
    (data) => _serviceError.value = data.isValidService(context),
    (data) => _airportError.value = data.isValidAirport(context),
  ];

  bool _validate(BuildContext context, ContactSupportData data) {
    var result = true;
    String? message;
    for (final String? Function(ContactSupportData data) validator in _validators) {
      final String? validMessage = validator(data);
      if (validMessage != null) {
        result = false;
        message = validMessage;
      }
    }
    if (message != null) {
      showErrorMessage(context, message);
    }
    return result;
  }

  @override
  void dispose() {
    _airportError.dispose();
    _serviceError.dispose();
    _topicError.dispose();
    _commentError.dispose();
    _topicController.dispose();
    _commentController.dispose();
    _formListenable.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final selectAirportButton = CustomInputButton(
      value: _selectedAirport,
      label: context.l10n.airport,
      onTap: () async {
        final Location? result = await context.pushNamed<Location>(Routes.selectAirport.name);
        if (result == null) {
          return;
        }
        _airportError.value = null;
        setState(() => _selectedAirport = result.name);
      },
    );
    final selectServiceTypeButton = CustomInputButton(
      value: _selectedService.localizedText(context),
      label: context.l10n.service,
      onTap: () async {
        final ServiceType? result = await showCustomModalBottomSheet<ServiceType>(
          context: context,
          useRootNavigator: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(context.l10n.selectService, style: context.textStyles.title3Emphasized),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _services.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () => context.pop(_services[index]),
                  title: Text(_services[index].localizedText(context), style: context.textStyles.bodyRegular),
                  leading: RoundCheckbox(
                    value: _services[index] == _selectedService,
                    onChanged: (_) => context.pop(_services[index]),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ),
        );
        if (result == null) {
          return;
        }
        _serviceError.value = null;
        setState(() => _selectedService = result);
      },
    );
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<ContactSupportBloc, ContactSupportState>(
        listener: (context, state) {
          state.mapOrNull(
            failure: (s) => showCustomAppException(context, s.exception),
            success: (_) {
              showSuccessMessage(context, context.l10n.messageSentSuccessfully);
              Navigator.of(context).pop();
            },
          );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(titleText: context.l10n.sendMessage),
          body: Stack(
            fit: StackFit.expand,
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (windowSize.isCompact) ...[
                    selectAirportButton,
                    const SizedBox(height: 16),
                    selectServiceTypeButton,
                  ] else
                    Row(
                      children: [
                        Expanded(child: selectAirportButton),
                        const SizedBox(width: 16),
                        Expanded(child: selectServiceTypeButton),
                      ],
                    ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: _topicError,
                    builder: (context, value, child) {
                      return CustomTextField(
                        controller: _topicController,
                        errorText: value,
                        labelText: context.l10n.topic,
                        maxLength: 150,
                        textInputAction: TextInputAction.next,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: _commentError,
                    builder: (context, value, child) {
                      return CustomTextField(
                        controller: _commentController,
                        errorText: value,
                        labelText: context.l10n.comment,
                        maxLines: 3,
                        maxLength: 500,
                        textInputAction: TextInputAction.send,
                      );
                    },
                  ),
                  const SafeArea(child: SizedBox(height: 90)),
                ],
              ),
              BlocBuilder<ContactSupportBloc, ContactSupportState>(
                builder: (context, state) {
                  return ListenableBuilder(
                    listenable: _formListenable,
                    builder: (context, child) {
                      final bool isButtonEnabled =
                          !state.inProgress &&
                          (_selectedAirport != null &&
                              _topicController.text.isNotEmpty &&
                              _commentController.text.isNotEmpty);
                      return PinnedBottomWidget(
                        isTransparentBg: true,
                        child: SizedBox(
                          width: double.infinity,
                          child: GradientElevatedButton(
                            onPressed: isButtonEnabled
                                ? () {
                                    final data = ContactSupportData(
                                      airport: _selectedAirport ?? '',
                                      service: _selectedService.localizedText(context),
                                      topic: _topicController.text.trim(),
                                      comment: _commentController.text.trim(),
                                    );
                                    if (!_validate(context, data)) {
                                      return;
                                    }
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    context.read<ContactSupportBloc>().add(ContactSupportEvent.send(data));
                                  }
                                : null,
                            text: context.l10n.send,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

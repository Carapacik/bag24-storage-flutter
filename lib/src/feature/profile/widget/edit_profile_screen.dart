import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:bag24/src/feature/profile/model/profile_edit_data.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:bag24/src/feature/shared_widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const EditProfileScreen({super.key}) extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState() extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController = TextEditingController();
  late final TextEditingController _lastNameController = TextEditingController();
  final ValueNotifier<String?> _firstNameError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _lastNameError = ValueNotifier<String?>(null);
  late final Listenable _formListenable;

  @override
  void initState() {
    super.initState();
    _formListenable = Listenable.merge([_firstNameController, _lastNameController])..addListener(_onChange);
  }

  void _onChange() {
    _firstNameError.value = null;
    _lastNameError.value = null;
  }

  late final List<String? Function(ProfileEditData data)> _validators = [
    (data) => _firstNameError.value = data.isValidFirstName(context),
    (data) => _lastNameError.value = data.isValidLastName(context),
  ];

  bool _validate(BuildContext context, ProfileEditData data) {
    var result = true;
    for (final String? Function(ProfileEditData data) validator in _validators) {
      final String? validMessage = validator(data);
      if (validMessage != null) {
        result = false;
      }
    }
    return result;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameError.dispose();
    _lastNameError.dispose();
    _formListenable.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        state.mapOrNull(
          idle: (s) {
            _firstNameController.value = TextEditingValue(text: s.firstName);
            _lastNameController.value = TextEditingValue(text: s.lastName);
          },
          success: (_) {
            showSuccessMessage(context, context.l10n.dataIsSaved);
            context.pop(true);
          },
          failure: (s) => showCustomAppException(context, s.exception),
        );
      },
      builder: (context, state) {
        return FullScreenLoading(
          inProgress: state.inProgress,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: CustomAppBar(titleText: context.l10n.myData),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                        valueListenable: _firstNameError,
                        builder: (context, value, child) {
                          return CustomTextField(
                            controller: _firstNameController,
                            errorText: value,
                            labelText: context.l10n.name,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder(
                        valueListenable: _lastNameError,
                        builder: (context, value, child) {
                          return CustomTextField(
                            controller: _lastNameController,
                            errorText: value,
                            labelText: context.l10n.surname,
                          );
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: GradientElevatedButton(
                          onPressed: () {
                            final data = ProfileEditData(
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                            );
                            if (!_validate(context, data)) {
                              return;
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<EditProfileBloc>().add(
                              EditProfileEvent.save(_firstNameController.text.trim(), _lastNameController.text.trim()),
                            );
                          },
                          text: context.l10n.save,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

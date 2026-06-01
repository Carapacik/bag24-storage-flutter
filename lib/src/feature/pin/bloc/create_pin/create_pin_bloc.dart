import 'dart:io';

import 'package:bag24/src/feature/pin/data/pin_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';

part 'create_pin_bloc.freezed.dart';
part 'create_pin_event.dart';
part 'create_pin_state.dart';

final class CreatePinBloc({required final IPinRepository _pinRepository}) extends Bloc<CreatePinEvent, CreatePinState> {
  this : super(const CreatePinState.idle(pin: '')) {
    on<CreatePinEvent>(
      (event, emit) async => await switch (event) {
        final _CreatePinChanged e => _pinChanged(e, emit),
      },
    );
  }

  Future<void> _pinChanged(_CreatePinChanged event, Emitter<CreatePinState> emitter) async {
    if (state.savedPin != null && event.pin.length == 4) {
      if (state.savedPin == event.pin) {
        await _pinRepository.setPin(event.pin);
        List<BiometricType>? availableBiometrics;
        if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
          final localAuth = LocalAuthentication();
          availableBiometrics = await localAuth.getAvailableBiometrics();
        }
        emitter(
          CreatePinState.success(
            pin: event.pin,
            savedPin: event.pin,
            availableBiometrics: availableBiometrics ?? const [],
          ),
        );
        return;
      }
      emitter(CreatePinState.failure(pin: event.pin, savedPin: state.savedPin));
      emitter(const CreatePinState.idle(pin: ''));
      return;
    }
    if (event.pin.length == 4) {
      emitter(state.copyWith(pin: '', savedPin: event.pin));
      return;
    }
    emitter(CreatePinState.idle(pin: event.pin, savedPin: state.savedPin));
  }
}

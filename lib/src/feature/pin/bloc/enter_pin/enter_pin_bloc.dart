import 'package:bag24/src/feature/pin/data/pin_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'enter_pin_bloc.freezed.dart';
part 'enter_pin_event.dart';
part 'enter_pin_state.dart';

final class EnterPinBloc({required final IPinRepository _pinRepository}) extends Bloc<EnterPinEvent, EnterPinState> {
  this : super(const EnterPinState.idle(pin: '')) {
    on<EnterPinEvent>(
      (event, emit) async => await switch (event) {
        final _EnterPinChanged e => _pinChanged(e, emit),
      },
    );
  }

  Future<void> _pinChanged(_EnterPinChanged event, Emitter<EnterPinState> emitter) async {
    if (event.pin.length == 4) {
      final String? savedPin = await _pinRepository.getPin();
      if (savedPin == event.pin) {
        emitter(EnterPinState.success(pin: event.pin));
        return;
      }
      emitter(EnterPinState.failure(pin: event.pin));
      await Future<void>.delayed(const Duration(milliseconds: 600));
      emitter(const EnterPinState.idle(pin: ''));
      return;
    }
    emitter(EnterPinState.idle(pin: event.pin));
  }
}

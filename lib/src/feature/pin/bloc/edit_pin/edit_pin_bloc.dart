import 'package:bag24/src/feature/pin/data/pin_repository.dart';
import 'package:bag24/src/feature/pin/model/edit_pin_type.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_pin_bloc.freezed.dart';
part 'edit_pin_event.dart';
part 'edit_pin_state.dart';

final class EditPinBloc({required final IPinRepository _pinRepository}) extends Bloc<EditPinEvent, EditPinState> {
  this : super(const EditPinState.idle(pin: '', type: EditPinType.oldPin)) {
    on<EditPinEvent>(
      (event, emit) async => await switch (event) {
        final _EditPinChanged e => _pinChanged(e, emit),
      },
    );
  }

  Future<void> _pinChanged(_EditPinChanged event, Emitter<EditPinState> emitter) async {
    if (state.type == EditPinType.oldPin && event.pin.length == 4) {
      final String? oldPin = await _pinRepository.getPin();
      if (event.pin == oldPin) {
        emitter(const EditPinState.idle(type: EditPinType.newPin, pin: ''));
        return;
      }
      emitter(EditPinState.failure(type: state.type, pin: event.pin));
      await Future<void>.delayed(const Duration(milliseconds: 600));
      emitter(EditPinState.idle(type: state.type, pin: ''));
      return;
    }
    if (state.savedPin != null && event.pin.length == 4 && state.type == EditPinType.repeatPin) {
      if (state.savedPin == event.pin) {
        await _pinRepository.setPin(event.pin);
        emitter(EditPinState.success(type: state.type, pin: event.pin, savedPin: event.pin));
        return;
      }
      emitter(EditPinState.failure(type: state.type, pin: event.pin, savedPin: state.savedPin));
      await Future<void>.delayed(const Duration(milliseconds: 600));
      emitter(EditPinState.idle(type: state.type, pin: '', savedPin: state.savedPin));
      return;
    }
    if (event.pin.length == 4 && state.type == EditPinType.newPin) {
      emitter(EditPinState.idle(type: EditPinType.repeatPin, pin: '', savedPin: event.pin));
      return;
    }
    emitter(EditPinState.idle(type: state.type, pin: event.pin, savedPin: state.savedPin));
  }
}

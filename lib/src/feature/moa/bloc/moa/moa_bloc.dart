import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/moa/data/moa_repository.dart';
import 'package:bag24/src/feature/payment/data/payment_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'moa_bloc.freezed.dart';
part 'moa_event.dart';
part 'moa_state.dart';

final class MOABloc({
  required final IMOARepository _moaRepository,
  required final IPaymentRepository _paymentRepository,
}) extends Bloc<MOAEvent, MOAState> {
  this : super(const MOAState.processing(isMoaAvailable: null, miles: -1)) {
    on<MOAEvent>(
      (event, emit) async => await switch (event) {
        final _MOAEventStart e => _start(e, emit),
        final _MOAEventRegister e => _register(e, emit),
      },
    );

    add(const MOAEvent.start());
  }

  Future<void> _start(_MOAEventStart event, Emitter<MOAState> emitter) async {
    emitter(const MOAState.processing(isMoaAvailable: null, miles: -1));
    await ExceptionHandler.handle(
      () async {
        final bool isMoaAvailable = await _paymentRepository.initPayments.then((v) => v.moa);
        if (!isMoaAvailable) {
          emitter(MOAState.success(isMoaAvailable: isMoaAvailable, miles: -1));
          return;
        }
        var miles = -1;
        emitter(MOAState.processing(isMoaAvailable: isMoaAvailable, miles: state.miles));
        try {
          miles = await _moaRepository.miles;
        } on Object {
          // Miles error or user not found in MOA
        }
        emitter(MOAState.success(isMoaAvailable: state.isMoaAvailable, miles: miles));
      },
      onError: (exception, stackTrace) =>
          emitter(MOAState.failure(isMoaAvailable: state.isMoaAvailable, miles: state.miles, exception: exception)),
      onDone: () => emitter(MOAState.idle(isMoaAvailable: state.isMoaAvailable, miles: state.miles)),
    );
  }

  Future<void> _register(_MOAEventRegister event, Emitter<MOAState> emitter) async {
    emitter(MOAState.processing(isMoaAvailable: state.isMoaAvailable, miles: state.miles));
    await ExceptionHandler.handle(
      () async {
        final bool isMoaAvailable = await _paymentRepository.initPayments.then((v) => v.moa);
        if (!isMoaAvailable) {
          emitter(
            MOAState.failure(
              isMoaAvailable: isMoaAvailable,
              miles: -1,
              exception: const AppException.unknown('Сервис не доступен'),
            ),
          );
          return;
        }
        await _moaRepository.registerMoa();
        emitter(MOAState.processing(isMoaAvailable: isMoaAvailable, miles: state.miles));
        final int miles = await _moaRepository.miles;
        emitter(MOAState.success(isMoaAvailable: state.isMoaAvailable, miles: miles));
      },
      onError: (exception, stackTrace) =>
          emitter(MOAState.failure(isMoaAvailable: state.isMoaAvailable, miles: state.miles, exception: exception)),
      onDone: () => emitter(MOAState.idle(isMoaAvailable: state.isMoaAvailable, miles: state.miles)),
    );
  }
}

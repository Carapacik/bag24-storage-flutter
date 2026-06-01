import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'moa_sms_code_bloc.freezed.dart';
part 'moa_sms_code_event.dart';
part 'moa_sms_code_state.dart';

final class MOASmsCodeBloc({required final IOrderRepository _orderRepository, required final String _orderId})
    extends Bloc<MOASmsCodeEvent, MOASmsCodeState> {
  this : super(const MOASmsCodeState.idle()) {
    on<MOASmsCodeEvent>(
      (event, emit) async => await switch (event) {
        final _MOASmsCodeEventSend e => _send(e, emit),
        final _MOASmsCodeEventResend e => _resend(e, emit),
      },
    );
  }

  Future<void> _send(_MOASmsCodeEventSend event, Emitter<MOASmsCodeState> emitter) async {
    if (event.code.length != 4) {
      return;
    }
    emitter(const MOASmsCodeState.processing());
    await ExceptionHandler.handle(
      () async {
        await _orderRepository.confirmMOA(_orderId, event.code);
        emitter(const MOASmsCodeState.success());
      },
      onError: (exception, stackTrace) => emitter(MOASmsCodeState.failure(exception: exception)),
      onDone: () => emitter(const MOASmsCodeState.idle()),
    );
  }

  Future<void> _resend(_MOASmsCodeEventResend event, Emitter<MOASmsCodeState> emitter) async {
    emitter(const MOASmsCodeState.processing());
    await ExceptionHandler.handle(
      () async {
        await _orderRepository.resendMOACode(_orderId);
        emitter(const MOASmsCodeState.idle());
      },
      onError: (exception, stackTrace) => emitter(MOASmsCodeState.failure(exception: exception)),
      onDone: () => emitter(const MOASmsCodeState.idle()),
    );
  }
}

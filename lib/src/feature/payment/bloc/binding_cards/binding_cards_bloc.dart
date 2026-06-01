import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/payment/data/payment_repository.dart';
import 'package:bag24/src/feature/payment/model/binding_model.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'binding_cards_bloc.freezed.dart';
part 'binding_cards_event.dart';
part 'binding_cards_state.dart';

final class BindingCardsBloc({required final IPaymentRepository _paymentRepository})
    extends Bloc<BindingCardsEvent, BindingCardsState> {
  this : super(const BindingCardsState.processing(cards: [])) {
    on<BindingCardsEvent>(
      (event, emit) async => await switch (event) {
        final _BindingCardsEventStart e => _start(e, emit),
        final _BindingCardsEventRemoveCard e => _removeCard(e, emit),
      },
    );

    add(const BindingCardsEvent.start());
  }

  Future<void> _start(_BindingCardsEventStart event, Emitter<BindingCardsState> emitter) async {
    emitter(const BindingCardsState.processing(cards: []));
    await ExceptionHandler.handle(
      () async {
        final List<BindingModel> cards = await _paymentRepository.bindingCards;
        emitter(BindingCardsState.success(cards: cards));
      },
      onError: (exception, stackTrace) => emitter(BindingCardsState.failure(cards: state.cards, exception: exception)),
      onDone: () => emitter(BindingCardsState.idle(cards: state.cards)),
    );
  }

  Future<void> _removeCard(_BindingCardsEventRemoveCard event, Emitter<BindingCardsState> emitter) async {
    emitter(BindingCardsState.processing(cards: state.cards));
    await ExceptionHandler.handle(
      () async {
        await _paymentRepository.deleteBingingCard(event.cardId);
        emitter(
          BindingCardsState.success(
            cards: List.of(state.cards)..removeWhere((e) => e.id == event.cardId),
            isCardRemoved: true,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(BindingCardsState.failure(cards: state.cards, exception: exception)),
      onDone: () => emitter(BindingCardsState.idle(cards: state.cards)),
    );
  }
}

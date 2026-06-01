part of 'moa_bloc.dart';

@Freezed()
sealed class const MOAState._() with _$MOAState {
  const factory idle({required bool? isMoaAvailable, required int miles}) = _MOAStateIdle;

  const factory processing({required bool? isMoaAvailable, required int miles}) = _MOAStateProcessing;

  const factory success({required bool? isMoaAvailable, required int miles}) = _MOAStateSuccess;

  const factory failure({required bool? isMoaAvailable, required int miles, required AppException exception}) =
      _MOAStateFailure;

  bool get isJoined => (isMoaAvailable ?? false) && miles >= 0;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}

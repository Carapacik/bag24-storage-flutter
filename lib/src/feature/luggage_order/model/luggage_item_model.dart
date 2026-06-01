class const LuggageItemModel({
  required final String photo,
  required final String rateId,
  required final String? specialOfferId,
  final bool needAdditionalLuggage = true,
  final bool createOrder = false,
  final String? id,
}) {
  LuggageItemModel copyWith({required String id, required String photoId}) => LuggageItemModel(
    id: id,
    photo: photoId,
    rateId: rateId,
    specialOfferId: specialOfferId,
    needAdditionalLuggage: needAdditionalLuggage,
    createOrder: createOrder,
  );
}

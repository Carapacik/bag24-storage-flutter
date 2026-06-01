import 'package:bag24/src/feature/luggage_order/model/special_offer.dart';
import 'package:rest_client/storage/dto/special_offer_dto.dart';

final List<SpecialOffer> mockSpecialOffers = mockSpecialOffersDto.map(SpecialOffer.decode).toList();

List<SpecialOfferDto> mockSpecialOffersDto = [
  const SpecialOfferDto(id: '1', name: 'Summer Special', days: 7, basePrice: 5000),
  const SpecialOfferDto(id: '2', name: 'Weekend Getaway', days: 3, basePrice: 3000),
  const SpecialOfferDto(id: '3', name: 'Extended Stay', days: 14, basePrice: 10000),
];

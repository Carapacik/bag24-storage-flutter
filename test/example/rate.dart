import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:rest_client/storage/dto/rate_data_dto.dart';

import 'special_offer.dart';

final List<RateData> mockRates = mockRatesDto.map(RateData.decode).toList();

List<RateDataDto> mockRatesDto = [
  RateDataDto(
    id: 'rate1',
    title: 'Rate 1',
    description: 'Description for Rate 1',
    initialPrice: 10,
    prolongingPrice: 5,
    defaultValue: true,
    sizeDescription: '',
    specialOffers: mockSpecialOffersDto,
  ),
  RateDataDto(
    id: 'rate2',
    title: 'Rate 2',
    description: 'Description for Rate 2',
    initialPrice: 15,
    prolongingPrice: 7,
    defaultValue: false,
    sizeDescription: '',
    specialOffers: mockSpecialOffersDto,
  ),
  RateDataDto(
    id: 'rate3',
    title: 'Rate 3',
    description: 'Description for Rate 3',
    initialPrice: 20,
    prolongingPrice: 10,
    defaultValue: true,
    sizeDescription: '',
    specialOffers: mockSpecialOffersDto,
  ),
  RateDataDto(
    id: 'rate4',
    title: 'Rate 4',
    description: 'Description for Rate 4',
    initialPrice: 25,
    prolongingPrice: 12,
    defaultValue: false,
    sizeDescription: '',
    specialOffers: mockSpecialOffersDto,
  ),
];

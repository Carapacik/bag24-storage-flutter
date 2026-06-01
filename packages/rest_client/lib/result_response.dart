import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/account/dto/token_dto.dart';
import 'package:rest_client/banners/dto/banner_dto.dart';
import 'package:rest_client/file_storage/dto/upload_file_dto.dart';
import 'package:rest_client/locations/dto/location_dto.dart';
import 'package:rest_client/order/dto/create_order_response.dart';
import 'package:rest_client/order/dto/get_payments_response.dart';
import 'package:rest_client/order/dto/luggage_response.dart';
import 'package:rest_client/order/dto/order_dto.dart';
import 'package:rest_client/order/dto/order_item_dto.dart';
import 'package:rest_client/order/dto/order_qr_dto.dart';
import 'package:rest_client/order/dto/order_status_response.dart';
import 'package:rest_client/order/dto/pay_order_response.dart';
import 'package:rest_client/order/dto/payment_data_dto.dart';
import 'package:rest_client/order/dto/receipts_list_dto.dart';
import 'package:rest_client/payment/dto/binding_list_dto.dart';
import 'package:rest_client/payment/dto/init_payments_dto.dart';
import 'package:rest_client/state/dto/get_state_response.dart';
import 'package:rest_client/storage/dto/storage_dto.dart';
import 'package:rest_client/user/dto/miles_response_dto.dart';
import 'package:rest_client/user/dto/user_dto.dart';

class const ResultResponse<T>({
  @ResultResponseConverter() required final T result,
  required final String message,
  required final int? errorCode,
}) {
  factory fromJson(Map<String, dynamic> json) => ResultResponse<T>(
    result: ResultResponseConverter<T>().fromJson(json['result']),
    message: json['message'].toString(),
    errorCode: json['errorCode'] as int?,
  );

  // Возникает ошибка если не сделать
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => <String, dynamic>{
    'result': ResultResponseConverter<T>().toJson(result),
    'message': message,
    'errorCode': errorCode,
  };
}

class const ResultResponseConverter<T>() extends JsonConverter<T, Object?> {
  @override
  T fromJson(Object? json) {
    if (json is Map<String, dynamic>) {
      if (T == TokenDto) {
        return TokenDto.fromJson(json) as T;
      }
      if (T == LocationListDto) {
        return LocationListDto.fromJson(json) as T;
      }
      if (T == UserDto) {
        return UserDto.fromJson(json) as T;
      }
      if (T == UserRawDto) {
        return UserRawDto.fromJson(json) as T;
      }
      if (T == MilesResponseDto) {
        return MilesResponseDto.fromJson(json) as T;
      }
      if (T == StorageListDto) {
        return StorageListDto.fromJson(json) as T;
      }
      if (T == StorageDto) {
        return StorageDto.fromJson(json) as T;
      }
      if (T == BannerListDto) {
        return BannerListDto.fromJson(json) as T;
      }
      if (T == OrderListDto) {
        return OrderListDto.fromJson(json) as T;
      }
      if (T == CreateOrderResponse) {
        return CreateOrderResponse.fromJson(json) as T;
      }
      if (T == OrderDto) {
        return OrderDto.fromJson(json) as T;
      }
      if (T == OrderItemDto) {
        return OrderItemDto.fromJson(json) as T;
      }
      if (T == OrderQrDto) {
        return OrderQrDto.fromJson(json) as T;
      }
      if (T == LuggageResponse) {
        return LuggageResponse.fromJson(json) as T;
      }
      if (T == OrderStatusResponse) {
        return OrderStatusResponse.fromJson(json) as T;
      }
      if (T == BindingListDto) {
        return BindingListDto.fromJson(json) as T;
      }
      if (T == PayOrderResponse) {
        return PayOrderResponse.fromJson(json) as T;
      }
      if (T == GetPaymentsResponse) {
        return GetPaymentsResponse.fromJson(json) as T;
      }
      if (T == PaymentDataDto) {
        return PaymentDataDto.fromJson(json) as T;
      }
      if (T == ReceiptsListDto) {
        return ReceiptsListDto.fromJson(json) as T;
      }
      if (T == InitPaymentsDto) {
        return InitPaymentsDto.fromJson(json) as T;
      }
      if (T == UploadFileDto) {
        return UploadFileDto.fromJson(json) as T;
      }
      if (T == GetStateResponse) {
        return GetStateResponse.fromJson(json) as T;
      }
    }
    return json as T;
  }

  @override
  Object? toJson(T object) => object;
}

import 'dart:async';
import 'dart:io';

import 'package:bag24/src/core/components/prefs_storage/photo_rules/photo_rules_data_source.dart';
import 'package:bag24/src/feature/luggage_order/model/luggage_item_model.dart';
import 'package:bag24/src/feature/order/model/order_detail.dart';
import 'package:bag24/src/feature/order/model/order_item.dart';
import 'package:bag24/src/feature/order/model/order_qr.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/model/orders_status.dart';
import 'package:bag24/src/feature/order/model/receipt.dart';
import 'package:collection/collection.dart';
import 'package:rest_client/file_storage/file_storage_client.dart';
import 'package:rest_client/order/dto/create_order_command.dart';
import 'package:rest_client/order/dto/luggage_command.dart';
import 'package:rest_client/order/dto/withdraw_command.dart';
import 'package:rest_client/order/order_client.dart';
import 'package:uuid/uuid.dart';

abstract interface class IOrderRepository() {
  Future<List<OrderItem>> getOrders({required OrdersStatus status, int offset = 0, int limit = 20});

  Future<OrderDetail> getOrder(String orderId);

  Future<bool> get isShownPhotoRules;

  Future<void> setPhotoRulesShown();

  Future<String> uploadPhoto({required String path});

  Future<void> changeOrder(String orderId, {required bool isAutoCharge});

  Future<String> createOrder(String storageId, List<String> photoIds, List<LuggageItemModel> luggageList);

  Future<void> deleteOrder(String orderId);

  Future<void> cancelPayment(String orderId);

  Future<void> refundOrder(String orderId);

  Future<void> confirmMOA(String orderId, String code);

  Future<void> resendMOACode(String orderId);

  Future<void> addLuggage(
    String orderId, {
    required String rateId,
    required String? specialOfferId,
    required String photoId,
  });

  Future<void> editLuggage(
    String orderId, {
    required String rateId,
    required String? specialOfferId,
    required String luggageId,
    required String photoId,
  });

  Future<void> deleteLuggage(String orderId, {required String luggageId});

  Future<List<Receipt>> getReceipts(String orderId);

  Future<OrderStatus> getStatus(String orderId);

  Future<OrderQrModel> depositOrder(String orderId);

  Future<OrderQrModel> withdrawOrder(String orderId, {required List<String> luggageIds});
}

class const OrderRepository({
  required final OrderClient _orderClient,
  required final FileStorageClient _fileStorageClient,
  required final IPhotoRulesDataSource _photoRulesDataSource,
}) implements IOrderRepository {
  @override
  Future<List<OrderItem>> getOrders({required OrdersStatus status, int offset = 0, int limit = 20}) => _orderClient
      .getOrders(status: status.json, offset: offset, limit: limit)
      .then((dto) => dto.result.orders.map(OrderItem.decode).toList(growable: false));

  @override
  Future<OrderDetail> getOrder(String orderId) =>
      _orderClient.getOrder(orderId: orderId).then((dto) => OrderDetail.decode(dto.result));

  @override
  Future<bool> get isShownPhotoRules => _photoRulesDataSource.getPhotoRules().then((v) => v ?? false);

  @override
  Future<void> setPhotoRulesShown() => _photoRulesDataSource.setPhotoRules(isPhotoRulesShown: true);

  @override
  Future<String> uploadPhoto({required String path}) =>
      _fileStorageClient.uploadFile(file: File(path)).then((dto) => dto.result.id);

  @override
  Future<void> changeOrder(String orderId, {required bool isAutoCharge}) =>
      _orderClient.changeOrder(orderId: orderId, autocharge: isAutoCharge);

  @override
  Future<String> createOrder(String storageId, List<String> photoIds, List<LuggageItemModel> luggageList) async {
    final Iterable<LuggageCommand> luggageCommandList = luggageList.mapIndexed(
      (index, e) => LuggageCommand(rateId: e.rateId, specialOfferId: e.specialOfferId, photoId: photoIds[index]),
    );
    return await _orderClient
        .createOrder(
          body: CreateOrderCommand(storageId: storageId, luggage: luggageCommandList.toList()),
        )
        .then((dto) => dto.result.id);
  }

  @override
  Future<void> deleteOrder(String orderId) => _orderClient.deleteOrder(orderId: orderId);

  @override
  Future<void> refundOrder(String orderId) => _orderClient.refundOrder(requestId: const Uuid().v4(), orderId: orderId);

  @override
  Future<void> cancelPayment(String orderId) => _orderClient.cancelPayment(orderId: orderId);

  @override
  Future<void> confirmMOA(String orderId, String code) =>
      _orderClient.confirmMOA(requestId: const Uuid().v4(), orderId: orderId, code: code);

  @override
  Future<void> resendMOACode(String orderId) => _orderClient.resendMOACode(orderId: orderId);

  @override
  Future<void> addLuggage(
    String orderId, {
    required String rateId,
    required String? specialOfferId,
    required String photoId,
  }) async => await _orderClient.addLuggage(
    orderId: orderId,
    body: LuggageCommand(rateId: rateId, photoId: photoId, specialOfferId: specialOfferId),
  );

  @override
  Future<void> editLuggage(
    String orderId, {
    required String rateId,
    required String? specialOfferId,
    required String luggageId,
    required String photoId,
  }) => _orderClient.updateLuggage(
    orderId: orderId,
    luggageId: luggageId,
    body: LuggageCommand(rateId: rateId, photoId: photoId, specialOfferId: specialOfferId),
  );

  @override
  Future<void> deleteLuggage(String orderId, {required String luggageId}) =>
      _orderClient.deleteLuggage(orderId: orderId, luggageId: luggageId);

  @override
  Future<List<Receipt>> getReceipts(String orderId) => _orderClient
      .getReceipts(orderId: orderId)
      .then((dto) => dto.result.receipts.map(Receipt.decode).toList(growable: false));

  @override
  Future<OrderStatus> getStatus(String orderId) =>
      _orderClient.getStatus(orderId: orderId).then((dto) => OrderStatus.fromString(dto.result.status.json!));

  @override
  Future<OrderQrModel> depositOrder(String orderId) =>
      _orderClient.depositOrder(orderId: orderId).then((dto) => OrderQrModel.decode(dto.result));

  @override
  Future<OrderQrModel> withdrawOrder(String orderId, {required List<String> luggageIds}) => _orderClient
      .withdrawOrder(
        orderId: orderId,
        body: WithdrawCommand(luggageIds: luggageIds),
      )
      .then((dto) => OrderQrModel.decode(dto.result));
}

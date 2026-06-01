import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:rest_client/order/dto/order_status_dto.dart';

enum OrderStatus(final String json) {
  pending('PENDING'),
  created('CREATED'),
  paying('PAYING'),
  paid('PAID'),
  depositing('DEPOSITING'),
  deposited('DEPOSITED'),
  withdrawing('WITHDRAWING'),
  withdrawn('WITHDRAWN'),
  partiallyWithdrawn('PARTIALLY_WITHDRAWN'),
  declined('DECLINED'),
  deleted('DELETED');

  factory decode(OrderStatusDto status) => OrderStatus.values.firstWhere((e) => e.json == status.json);

  factory fromString(String value) => OrderStatus.values.firstWhere((e) => e.json == value);

  Color color(BuildContext context) => switch (this) {
    OrderStatus.pending ||
    OrderStatus.created ||
    OrderStatus.declined ||
    OrderStatus.depositing ||
    OrderStatus.deposited => context.colors.infoLight,
    OrderStatus.paying => context.colors.warningLight,
    OrderStatus.paid ||
    OrderStatus.partiallyWithdrawn ||
    OrderStatus.withdrawing ||
    OrderStatus.withdrawn => context.colors.successLight,
    OrderStatus.deleted => context.colors.errorLight,
  };

  Color textColor(BuildContext context) => switch (this) {
    OrderStatus.pending ||
    OrderStatus.created ||
    OrderStatus.declined ||
    OrderStatus.depositing ||
    OrderStatus.deposited => context.colors.info,
    OrderStatus.paying => context.colors.warning,
    OrderStatus.paid ||
    OrderStatus.partiallyWithdrawn ||
    OrderStatus.withdrawing ||
    OrderStatus.withdrawn => context.colors.success,
    OrderStatus.deleted => context.colors.error,
  };

  String localizedText(BuildContext context) => switch (this) {
    OrderStatus.pending || OrderStatus.created || OrderStatus.declined => context.l10n.placed,
    OrderStatus.paying => context.l10n.paymentNotCompleted,
    OrderStatus.paid => context.l10n.paid,
    OrderStatus.depositing => context.l10n.inProcessing,
    OrderStatus.deposited => context.l10n.inStorage,
    OrderStatus.partiallyWithdrawn => context.l10n.partiallyIssued,
    OrderStatus.withdrawing => context.l10n.inProcessing,
    OrderStatus.withdrawn => context.l10n.issuedSingle,
    OrderStatus.deleted => context.l10n.cancelled,
  };
}

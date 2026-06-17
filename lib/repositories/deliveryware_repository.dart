import 'package:chopper/chopper.dart';
import 'package:dewa_app/environment_config.dart';
import 'package:dewa_app/models/shopware/dewa_shop_config.dart';
import 'package:logging/logging.dart';

import '/api/deliveryware_service.dart';
import '/models/full_order.dart';
import '/models/shopware/association.dart';
import '/models/shopware/attributes/dewa_shop.dart';
import '/models/shopware/attributes/dewa_shop_order.dart';
import '/models/shopware/attributes/order_address.dart';
import '/models/shopware/attributes/order_customer.dart';
import '/models/shopware/attributes/order_delivery.dart';
import '/models/shopware/attributes/order_line_item.dart';
import '/models/shopware/attributes/order_transaction.dart';
import '/models/shopware/attributes/payment_method.dart';
import '/models/shopware/attributes/sales_channel.dart';
import '/models/shopware/attributes/shipping_method.dart';
import '/models/shopware/attributes/state_machine_state.dart';
import '/models/shopware/data.dart';
import '/models/shopware/data_request.dart';
import '/models/shopware/data_response.dart';
import '/models/shopware/filter.dart';
import '/models/shopware/order_time.dart';
import '../models/shopware/attributes/order.dart';

export '/models/shopware/data_response.dart';

/// Repository for fetching data from the API.
class DeliverywareRepository {
  static final Logger _log = Logger('DeliverywareRepository');

  DeliverywareService dataSource;

  DeliverywareRepository(this.dataSource);

  Future<Map> getContext() async {
    _log.fine('getContext()');
    final response = await dataSource.getContext();
    _log.fine('getContext() response: ${response.body}');
    return response.body;
  }

  Future<DataResponse> getDataResponse(DataRequest request) async {
    Response<DataResponse>? response;

    response = await dataSource.getDataResponse(request);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final errString = 'Failed to get data response: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }
  }

  Future<DewaShopConfig> getDewaShopConfig() async {
    Response<dynamic>? response;

    response = await dataSource.getDewaShopConfig();

    return response.body as DewaShopConfig;
  }

  Future<DataResponse> getDeliverers(String shopId) async {
    final request = DataRequest(
      ids: shopId,
      associations: [
        const Association(name: 'deliverers'),
      ],
    );

    return getDataResponse(request);
  }

  Future<DewaShop> getDewaShop(String shopId) async {
    final request = DataRequest(
      ids: shopId,
      associations: const [
        Association(name: 'deliverers'),
        Association(name: 'category'),
        Association(name: 'products'),
        Association(name: 'salesChannels'),
      ],
    );

    final response = await getDataResponse(request);

    return response.data.first.attributes as DewaShop;
  }

  Future<List<FullOrder>> getOrders(
    String shopId, {
    bool showCompletedOnly = false,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? orderWhitelistPaymentMethods,
  }) async {
    final request = DataRequest(
      ids: shopId,
      associations: [
        Association(
          name: 'shopOrders',
          filter: [
            Filter(
              field: 'order.versionId',
              value: EnvironmentConfig.liveVersion,
              type: 'equals',
            ),
            Filter(type: 'multi', operator: 'OR', queries: [
              Filter(
                field: 'order.transactions.stateMachineState.technicalName',
                value: 'paid',
                type: 'equals',
              ),
              if (orderWhitelistPaymentMethods != null)
                Filter(
                  field: 'order.transactions.paymentMethodId',
                  value: orderWhitelistPaymentMethods.join('|'),
                ),
            ]),
            if (!showCompletedOnly)
              Filter(
                field: 'order.stateMachineState.technicalName',
                value: 'open|in_progress',
              )
            else
              Filter(
                field: 'order.stateMachineState.technicalName',
                value: 'completed',
              ),
            if (startDate != null && endDate != null)
              Filter(
                field: 'order.orderDateTime',
                type: 'range',
                parameters: {
                  'gte': startDate.toIso8601String(),
                  'lte': endDate.toIso8601String(),
                },
              ),
          ],
          associations: const [
            Association(name: 'deliverer'),
            Association(
              name: 'order',
              associations: [
                Association(name: 'lineItems'),
                Association(name: 'billingAddress'),
                Association(name: 'currency'),
                Association(name: 'deliveries', associations: [
                  Association(name: 'shippingMethod'),
                  Association(name: 'shippingOrderAddress'),
                  Association(name: 'stateMachineState')
                ]),
                Association(name: 'transactions', associations: [
                  Association(name: 'paymentMethod'),
                  Association(name: 'stateMachineState')
                ]),
                Association(name: 'stateMachineState'),
              ],
            ),
          ],
        ),
      ],
    );

    _log.finest(request);

    final response = await getDataResponse(request);

    final orders = response.included
        .where((e) => e.type == 'order')
        .map((e) => e.copyWith<Order>())
        .toList();

    _log.fine(orders);

    final dewaShopOrders = response.included
        .where((e) => e.type == 'dewa_shop_order')
        .map((e) => e.copyWith<DewaShopOrder>())
        .toList();

    final stateMachineStates = response.included
        .where((e) => e.type == 'state_machine_state')
        .map((e) => e.copyWith<StateMachineState>())
        .toList();

    final orderCustomers = response.included
        .where((e) => e.type == 'order_customer')
        .map((e) => e.copyWith<OrderCustomer>())
        .toList();

    final orderAddresses = response.included
        .where((e) => e.type == 'order_address')
        .map((e) => e.copyWith<OrderAddress>())
        .toList();

    _log.finest(orderAddresses);

    final orderTransactions = response.included
        .where((e) => e.type == 'order_transaction')
        .map((e) => e.copyWith<OrderTransaction>())
        .toList();

    final paymentMethods = response.included
        .where((e) => e.type == 'payment_method')
        .map((e) => e.copyWith<PaymentMethod>())
        .toList();

    final orderDeliveries = response.included
        .where((e) => e.type == 'order_delivery')
        .map((e) => e.copyWith<OrderDelivery>())
        .toList();

    _log.finest(orderDeliveries);

    final shippingMethods = response.included
        .where((e) => e.type == 'shipping_method')
        .map((e) => e.copyWith<ShippingMethod>())
        .toList();

    final orderLineItems = response.included
        .where((e) => e.type == 'order_line_item')
        .map((e) => e.copyWith<OrderLineItem>())
        .toList();

    final fullOrders = dewaShopOrders.map((e) {
      // collect additional order data
      final order =
          orders.singleWhere((element) => element.id == e.attributes!.orderId);
      final orderCustomer = orderCustomers
          .singleWhere((element) => element.attributes?.orderId == order.id);
      final orderTransaction = orderTransactions
          .singleWhere((element) => element.attributes?.orderId == order.id);
      final paymentMethod = paymentMethods.singleWhere((element) =>
          orderTransaction.attributes!.paymentMethodId == element.id);
      final orderDelivery = orderDeliveries
          .singleWhere((element) => element.attributes?.orderId == order.id);
      final orderAddress = orderAddresses
          .where((element) => element.id == orderDelivery.attributes!.shippingOrderAddressId)
          .first;
      final shippingMethod = shippingMethods.singleWhere((element) =>
          element.id == orderDelivery.attributes!.shippingMethodId);
      final lineItems = orderLineItems
          .where((element) => element.attributes!.orderId == order.id)
          .toList();

      // collect states
      final deliveryState = stateMachineStates.singleWhere(
          (element) => element.id == orderDelivery.attributes!.stateId);
      final transactionState = stateMachineStates.singleWhere(
          (element) => element.id == orderTransaction.attributes!.stateId);
      final orderState = stateMachineStates
          .singleWhere((element) => element.id == order.attributes!.stateId);

      return FullOrder(
        order: order.attributes,
        dewaShopOrder: e.attributes,
        orderCustomer: orderCustomer.attributes,
        orderAddress: orderAddress.attributes,
        orderTransaction: orderTransaction.attributes,
        paymentMethod: paymentMethod.attributes,
        orderDelivery: orderDelivery.attributes,
        shippingMethod: shippingMethod.attributes,
        orderLineItems: lineItems.map((e) => e.attributes!).toList(),
        orderState: orderState.attributes,
        deliveryState: deliveryState.attributes,
        transactionState: transactionState.attributes,
        dewaShopOrderId: e.id,
        orderId: order.id,
        orderDeliveryId: orderDelivery.id,
        orderTransactionId: orderTransaction.id,
      );
    }).toList();

    return Future.value(fullOrders);
  }

  Future<DataResponse> getPrinters(String shopId) async {
    final request = DataRequest(
      ids: shopId,
      associations: [
        const Association(name: 'printers'),
      ],
    );

    return getDataResponse(request);
  }

  Future<List<Data<SalesChannel>>> getSalesChannels() async {
    final request = DataRequest(associations: [
      const Association(name: 'domains'),
      const Association(name: 'type'),
    ]);

    Response<DataResponse>? response;

    response = await dataSource.getSalesChannels(request);

    // ignore: unnecessary_null_comparison
    if (response != null && response.isSuccessful && response.body != null) {
      return Future.value(
          response.body!.data.map((e) => e.copyWith<SalesChannel>()).toList());
    } else {
      final errString = 'Failed to get data response: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }
  }

  Future<List<Data<DewaShop>>> getShops() async {
    final request = DataRequest();

    final response = await getDataResponse(request);

    _log.fine('got shops: $response');

    return Future.value(
        response.data.map((e) => e.copyWith<DewaShop>()).toList());
  }

  Future<String> getVersionId() async {
    final salesChannels = await getSalesChannels();

    final salesChannel = salesChannels.firstWhere(
        (element) => element.attributes!.name == 'Dewa Shop',
        orElse: () => salesChannels.first);

    return Future.value(salesChannel.attributes!.homeCmsPageVersionId);
  }

  Future<StateMachineState> postCancelOrder(String orderId) async {
    _log.fine('postCancelOrder()');

    Response<StateMachineState>? response;

    response = await dataSource.postCancelOrder(orderId);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final errString = 'Failed to get state response: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }
  }

  Future<StateMachineState> postCompleteOrder(String orderId) async {
    _log.fine('postCompleteOrder()');

    Response<StateMachineState>? response;

    response = await dataSource.postCompleteOrder(orderId);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final errString = 'Failed to get state response: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }
  }

  Future<StateMachineState> postPaidOrder(String orderTransactionId) async {
    _log.fine('postPaidOrder()');

    Response<StateMachineState>? response;

    response = await dataSource.postPaidOrder(orderTransactionId);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final errString = 'Failed to get state response: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }
  }

  Future<StateMachineState> postProcessOrder(String orderId) async {
    _log.fine('postProcessOrder()');

    Response<StateMachineState>? response;

    response = await dataSource.postProcessOrder(orderId);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final errString = 'Failed to get state response: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }
  }

  Future<StateMachineState> postShipOrder(String orderDeliveryId) async {
    _log.fine('postShipOrder()');

    Response<StateMachineState>? response;

    response = await dataSource.postShipOrder(orderDeliveryId);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final errString = 'Failed to get state response: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }
  }

  /// post heartbeat to server to let it know the terminal is still alive
  Future<Response> postShopUpdate(String shopId) async {
    _log.fine('postShopUpdate($shopId)');

    Response<dynamic> response;

    response = await dataSource.postShopUpdate(shopId);

    _log.fine('postShopUpdate($shopId): ${response.bodyString}');

    if (!response.isSuccessful) {
      final errString = 'Failed to post shop update: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }

    return response;
  }

  Future<void> updateActiveState(
    String shopId, {
    bool? active,
    bool? collectActive,
    bool? deliveryActive,
    bool? searchPortalActive,
  }) async {
    _log.fine(
        'updateActiveState($shopId, active: $active, collectActive: $collectActive, deliveryActive: $deliveryActive, searchPortalActive: $searchPortalActive)');

    Response<dynamic>? response;

    response = await dataSource.patchShop(shopId, {
      'id': shopId,
      if (active != null) 'active': active,
      if (collectActive != null) 'collectActive': collectActive,
      if (deliveryActive != null) 'deliveryActive': deliveryActive,
      if (searchPortalActive != null) 'searchPortalActive': searchPortalActive,
    });

    if (!response.isSuccessful) {
      final errString = 'Failed to post shop update: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }

    return;
  }

  Future<OrderTime> updateOrderTime(String dewaShopOrderId, int minutes) async {
    _log.fine('updateOrderTime()');

    Response<dynamic>? response;

    response = await dataSource.getOrderTime(dewaShopOrderId, minutes);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final errString =
          'Failed to update time and get order time response: ${response.statusCode}';
      _log.severe(errString, response.error);
      throw Exception(errString);
    }
  }
}

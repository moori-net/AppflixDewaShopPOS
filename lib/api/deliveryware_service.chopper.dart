// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliveryware_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$DeliverywareService extends DeliverywareService {
  _$DeliverywareService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = DeliverywareService;

  @override
  Future<Response<dynamic>> getContext() {
    final Uri $url = Uri.parse('store-api/context');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<DataResponse>> getDataResponse(DataRequest request) {
    final Uri $url = Uri.parse('api/search/dewa-shop');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<DataResponse, DataResponse>(
      $request,
      requestConverter: convertDataRequest,
      responseConverter: convertDataResponse,
    );
  }

  @override
  Future<Response<DataResponse>> getOrders(DataRequest request) {
    final Uri $url = Uri.parse('api/search/order');
    final $body = request;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<DataResponse, DataResponse>(
      $request,
      requestConverter: convertDataRequest,
      responseConverter: convertDataResponse,
    );
  }

  @override
  Future<Response<dynamic>> getOrderTime(
    String dewaShopOrderId,
    int minutes,
  ) {
    final Uri $url =
        Uri.parse('api/dewa/order-time/${dewaShopOrderId}/${minutes}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>(
      $request,
      responseConverter: convertOrderTimeResponse,
    );
  }

  @override
  Future<Response<DataResponse>> getSalesChannels(DataRequest request) {
    final Uri $url = Uri.parse('api/search/sales-channel');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<DataResponse, DataResponse>(
      $request,
      requestConverter: convertDataRequest,
      responseConverter: convertDataResponse,
    );
  }

  @override
  Future<Response<DewaShopConfig>> getDewaShopConfig() {
    final Uri $url =
        Uri.parse('api/_action/system-config?domain=AppflixDewaShop.config');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<DewaShopConfig, DewaShopConfig>(
      $request,
      responseConverter: convertDewaShopConfigResponse,
    );
  }

  @override
  Future<Response<dynamic>> patchShop(
    String shopId,
    Map<dynamic, dynamic> body,
  ) {
    final Uri $url = Uri.parse('api/dewa-shop/${shopId}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>(
      $request,
      requestConverter: convertMapRequest,
    );
  }

  @override
  Future<Response<StateMachineState>> postCancelOrder(String orderId) {
    final Uri $url = Uri.parse('api/_action/order/${orderId}/state/cancel');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<StateMachineState, StateMachineState>(
      $request,
      responseConverter: convertStateResponse,
    );
  }

  @override
  Future<Response<StateMachineState>> postCompleteOrder(String orderId) {
    final Uri $url = Uri.parse('api/_action/order/${orderId}/state/complete');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<StateMachineState, StateMachineState>(
      $request,
      responseConverter: convertStateResponse,
    );
  }

  @override
  Future<Response<StateMachineState>> postPaidOrder(String orderTransactionId) {
    final Uri $url = Uri.parse(
        'api/_action/order_transaction/${orderTransactionId}/state/paid');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<StateMachineState, StateMachineState>(
      $request,
      responseConverter: convertStateResponse,
    );
  }

  @override
  Future<Response<StateMachineState>> postProcessOrder(String orderId) {
    final Uri $url = Uri.parse('api/_action/order/${orderId}/state/process');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<StateMachineState, StateMachineState>(
      $request,
      responseConverter: convertStateResponse,
    );
  }

  @override
  Future<Response<StateMachineState>> postShipOrder(String orderDeliveryId) {
    final Uri $url =
        Uri.parse('api/_action/order_delivery/${orderDeliveryId}/state/ship');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<StateMachineState, StateMachineState>(
      $request,
      responseConverter: convertStateResponse,
    );
  }

  @override
  Future<Response<dynamic>> postShopUpdate(String shopId) {
    final Uri $url = Uri.parse('api/dewa/update-shop/${shopId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}

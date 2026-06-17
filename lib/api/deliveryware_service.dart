import 'package:chopper/chopper.dart';

import '/models/shopware/attributes/state_machine_state.dart';
import '/models/shopware/data_request.dart';
import '/models/shopware/data_response.dart';
import '/models/shopware/dewa_shop_config.dart';
import 'converters.dart';

// This is necessary for the generator to work.
part 'deliveryware_service.chopper.dart';

@ChopperApi()
abstract class DeliverywareService extends ChopperService {
  @Get(path: 'store-api/context')
  Future<Response> getContext();

  @FactoryConverter(
    response: convertDataResponse,
    request: convertDataRequest,
  )
  @Post(path: 'api/search/dewa-shop')
  Future<Response<DataResponse>> getDataResponse(@Body() DataRequest request);

  @Get(path: 'api/search/order')
  @FactoryConverter(response: convertDataResponse, request: convertDataRequest)
  Future<Response<DataResponse>> getOrders(@Body() DataRequest request);

  @Get(path: 'api/dewa/order-time/{dewaShopOrderId}/{minutes}')
  @FactoryConverter(response: convertOrderTimeResponse)
  Future<Response> getOrderTime(@Path('dewaShopOrderId') String dewaShopOrderId,
      @Path('minutes') int minutes);

  @Post(path: 'api/search/sales-channel')
  @FactoryConverter(request: convertDataRequest, response: convertDataResponse)
  Future<Response<DataResponse>> getSalesChannels(@Body() DataRequest request);

  @Get(path: 'api/_action/system-config?domain=AppflixDewaShop.config')
  @FactoryConverter(response: convertDewaShopConfigResponse)
  Future<Response<DewaShopConfig>> getDewaShopConfig();

  @FactoryConverter(request: convertMapRequest)
  @Patch(path: 'api/dewa-shop/{shopId}')
  Future<Response> patchShop(@Path('shopId') String shopId, @Body() Map body);

  /// cancel order
  @Post(
    path: 'api/_action/order/{orderId}/state/cancel',
    optionalBody: true,
  )
  @FactoryConverter(response: convertStateResponse)
  Future<Response<StateMachineState>> postCancelOrder(
      @Path('orderId') String orderId);

  /// move to order complete
  @Post(
    path: 'api/_action/order/{orderId}/state/complete',
    optionalBody: true,
  )
  @FactoryConverter(response: convertStateResponse)
  Future<Response<StateMachineState>> postCompleteOrder(
      @Path('orderId') String orderId);

  /// move to paid/finish
  @Post(
    path: 'api/_action/order_transaction/{orderTransactionId}/state/paid',
    optionalBody: true,
  )
  @FactoryConverter(response: convertStateResponse)
  Future<Response<StateMachineState>> postPaidOrder(
      @Path('orderTransactionId') String orderTransactionId);

  /// move to preparation
  @Post(
    path: 'api/_action/order/{orderId}/state/process',
    optionalBody: true,
  )
  @FactoryConverter(response: convertStateResponse)
  Future<Response<StateMachineState>> postProcessOrder(
      @Path('orderId') String orderId);

  /// move to delivery/takeaway
  @FactoryConverter(response: convertStateResponse)
  @Post(
    path: 'api/_action/order_delivery/{orderDeliveryId}/state/ship',
    optionalBody: true,
  )
  Future<Response<StateMachineState>> postShipOrder(
      @Path('orderDeliveryId') String orderDeliveryId);

  @Get(path: 'api/dewa/update-shop/{shopId}')
  Future<Response> postShopUpdate(@Path('shopId') String shopId);

  // A helper method that helps instantiating the service. You can omit this method and use the generated class directly instead.
  static DeliverywareService create([ChopperClient? client]) =>
      _$DeliverywareService(client);
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:dewa_app/models/shopware/dewa_shop_config.dart';

import '/models/shopware/attributes/state_machine_state.dart';
import '/models/shopware/data_request.dart';
import '/models/shopware/data_response.dart';
import '/models/shopware/order_time.dart';

Request convertDataRequest(Request req) {
  final body = req.body;
  if (body is DataRequest) {
    return req.copyWith(body: json.encode(body.toJson()));
  }
  return req;
}

Response<DataResponse> convertDataResponse(Response res) =>
    res.copyWith<DataResponse>(
      body: DataResponse.fromJson(decode(res.bodyBytes)),
    );

Response<DewaShopConfig> convertDewaShopConfigResponse(Response res) =>
    res.copyWith<DewaShopConfig>(
      body: DewaShopConfig.fromJson(decode(res.bodyBytes)),
    );

Request convertMapRequest(Request req) {
  final body = req.body;
  if (body is Map) {
    return req.copyWith(body: json.encode(body));
  }
  return req;
}

Response<OrderTime> convertOrderTimeResponse(Response res) =>
    res.copyWith<OrderTime>(
      body: OrderTime.fromJson(decode(res.bodyBytes)),
    );

Response<StateMachineState> convertStateResponse(Response res) =>
    res.copyWith<StateMachineState>(
      body: StateMachineState.fromJson(decode(res.bodyBytes)),
    );

dynamic decode(Uint8List data) {
  return json.decode(utf8.decode(data));
}

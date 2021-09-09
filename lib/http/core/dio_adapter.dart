import 'package:bili_app/http/core/hi_error.dart';
import 'package:bili_app/http/core/hi_net_adapter.dart';
import 'package:bili_app/http/request/base_reqeust.dart';
import 'package:dio/dio.dart';

///Dio适配器
class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseReqeust reqeust) async {
    var response, options = Options(headers: reqeust.header);
    var error;
    try {
      if (reqeust.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(reqeust.url(), options: options);
      } else if (reqeust.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(reqeust.url(), data: reqeust.params, options: options);
      } else if (reqeust.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(reqeust.url(), data: reqeust.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      ///抛出HiNetError
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, reqeust));
    }
    return buildRes(response, reqeust);
  }

  ///构建HiNetResponse
  Future<HiNetResponse<T>> buildRes<T>(
      Response? response, BaseReqeust reqeust) {
    return Future.value(HiNetResponse(
        data: response?.data,
        reqeust: reqeust,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response));
  }
}

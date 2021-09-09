import 'package:bili_app/http/core/hi_net_adapter.dart';
import 'package:bili_app/http/request/base_reqeust.dart';

///测试适配器，mock 数据
class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseReqeust request) {
    return Future.delayed(Duration(microseconds: 1000), () {
      return HiNetResponse(
          request: request,
          data: {"code": 0, "message": 'success'} as T,
          statusCode: 403);
    });
  }
}

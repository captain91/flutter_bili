import 'package:bili_app/http/core/dio_adapter.dart';
import 'package:bili_app/http/core/hi_error.dart';
import 'package:bili_app/http/core/hi_net_adapter.dart';
// import 'package:bili_app/http/core/mock_adapter.dart';
import 'package:bili_app/http/request/base_reqeust.dart';

///1.支持网络库插拔设计
///2.基于配置请求，简洁易用
///3.Adapter设计，扩展性强
///4.统一异常和返回处理
class HiNet {
  HiNet._();
  static HiNet? _instance;

  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  Future fire(BaseReqeust reqeust) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(reqeust);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      //其他异常
      error = e;
      printLog(e);
    }
    if (response == null) {
      printLog(error);
    }
    var result = response?.data;
    printLog(result);
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(BaseReqeust reqeust) async {
    ///使用 Dio 发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(reqeust);
  }

  void printLog(log) {
    print('hi_net' + log.toString());
  }
}

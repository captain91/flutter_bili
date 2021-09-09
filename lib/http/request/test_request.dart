import 'package:bili_app/http/request/base_reqeust.dart';

class TestRequest extends BaseReqeust {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return 'uapi/test/test';
  }
}

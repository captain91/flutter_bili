enum HttpMethod { GET, POST, DELETE }

/// 基础请求
abstract class BaseReqeust {
  //查询参数 https://api.xxxx/test?requstPrams=11
  //path 请求 https://api.xxxxx/test/11
  var pathParams;
  var useHttps = true;
  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();
  String path();
  String url() {
    Uri uri;
    var pathStr = path();
    //拼接 path 参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    //http和https切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    print('url:${uri.toString()}');
    return uri.toString();
  }

  bool needLogin();

  Map<String, String> params = Map();

  ///添加参数
  BaseReqeust add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = Map();

  ///添加header
  BaseReqeust addHeader(String k, Object v) {
    params[k] = v.toString();
    return this;
  }
}
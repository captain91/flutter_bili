import 'package:bili_app/http/core/hi_net.dart';
import 'package:bili_app/http/request/base_request.dart';
import 'package:bili_app/http/request/like_request.dart';

class LikeDao {
  //https://api.devio.org/uapi/fa/like/BV1A5411L71X
  static like(String vid, bool like) async {
    BaseRequest request = like ? LikeRequest() : CancelLikeRquest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return result;
  }
}

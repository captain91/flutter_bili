import 'package:bili_app/http/core/hi_net.dart';
import 'package:bili_app/http/request/profile_request.dart';
import 'package:bili_app/model/profile_mo.dart';

class ProfileDao {
  //https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return ProfileMo.fromJson(result['data']);
  }
}

import 'package:bili_app/http/core/hi_net.dart';
import 'package:bili_app/http/request/notice_request.dart';
import 'package:bili_app/model/notice_mo.dart';

class NoticeDao {
  // https://api.devio.org/uapi/notice?pageIndex=1&pageSize=1
  static noticeList({int pageIndex = 1, int pageSize = 10}) async {
    NoticeRequest request = NoticeRequest();
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return NoticeMo.fromJson(result['data']);
  }
}

import 'package:bili_app/http/core/hi_net.dart';
import 'package:bili_app/http/request/ranking_request.dart';
import 'package:bili_app/model/ranking_mo.dart';

class RankingDao {
  //https://api.devio.org/uapi/fa/ranking?sort=like&pageIndex=1&pageSize=40
  static get(String sort, {int pageIndex = 1, int pageSize = 1}) async {
    RankingRequest request = RankingRequest();
    request
        .add("sort", sort)
        .add("pageIndex", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print("Ranking:$result");
    return RankingMo.fromJson(result['data']);
  }
}

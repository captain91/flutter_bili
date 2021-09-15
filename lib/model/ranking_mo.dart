import 'package:bili_app/model/video_model.dart';

class RankingMo {
  int? total;
  late List<VideoModel> videoList;

  RankingMo({this.total, required this.videoList});

  RankingMo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      videoList = new List<VideoModel>.empty(growable: true);
      json['list'].forEach((v) {
        videoList.add(new VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['list'] = this.videoList.map((v) => v.toJson()).toList();
    return data;
  }
}

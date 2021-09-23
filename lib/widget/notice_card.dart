import 'package:bili_app/model/home_mo.dart';
import 'package:bili_app/model/video_model.dart';
import 'package:bili_app/navigator/hi_navigator.dart';
import 'package:bili_app/util/view_util.dart';
import 'package:flutter/material.dart';

class NoticeCard extends StatelessWidget {
  final BannerMo bannerMo;
  const NoticeCard({Key? key, required this.bannerMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          handleBannerClick(bannerMo);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
          child: Row(
            children: [_buildIcon(), hiSpace(width: 10), _buildContents()],
          ),
        ));
  }

  _buildIcon() {
    var iconData = bannerMo.type == 'video'
        ? Icons.ondemand_video_outlined
        : Icons.card_giftcard;
    return Icon(
      iconData,
      size: 30,
    );
  }

  _buildContents() {
    return Flexible(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(bannerMo.title, style: TextStyle(fontSize: 16)),
            Text(dateMonthAndDay(bannerMo.createTime),
                style: TextStyle(color: Colors.grey))
          ],
        ),
        hiSpace(height: 5),
        Text(bannerMo.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis)
      ],
    ));
  }

  void handleBannerClick(BannerMo bannerMo) {
    if (bannerMo.type == 'video') {
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
          args: {'videoMo': VideoModel(vid: bannerMo.url)});
    } else {
      print('type:${bannerMo.type} ,url:${bannerMo.url}');
      HiNavigator.getInstance().openH5(bannerMo.url);
    }
  }
}

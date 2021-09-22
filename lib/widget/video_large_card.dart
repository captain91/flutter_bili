import 'package:bili_app/model/video_model.dart';
import 'package:bili_app/navigator/hi_navigator.dart';
import 'package:bili_app/util/format_util.dart';
import 'package:bili_app/util/view_util.dart';
import 'package:flutter/material.dart';

class VideoLargeCard extends StatelessWidget {
  final VideoModel videoModel;

  const VideoLargeCard({Key? key, required this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.detail, args: {"videoMo": videoModel});
      },
      child: Container(
        child: Row(
          children: [
            _itemImage(context),
          ],
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(videoModel.cover,
              width: height * (16 / 9), height: height),
          Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  durationTransform(videoModel.duration),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ))
        ],
      ),
    );
  }
}

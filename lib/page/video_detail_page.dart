import 'dart:io';

import 'package:bili_app/barrage/hi_barrage.dart';
import 'package:bili_app/barrage/hi_socket.dart';
import 'package:bili_app/http/core/hi_error.dart';
import 'package:bili_app/http/dao/favorite_dao.dart';
import 'package:bili_app/http/dao/like_dao.dart';
import 'package:bili_app/http/dao/video_detail_dao.dart';
import 'package:bili_app/model/video_detail_mo.dart';
import 'package:bili_app/model/video_model.dart';
import 'package:bili_app/util/toast.dart';
import 'package:bili_app/util/view_util.dart';
import 'package:bili_app/widget/appbar.dart';
import 'package:bili_app/widget/expandable_content.dart';
import 'package:bili_app/widget/hi_tab.dart';
import 'package:bili_app/widget/navigation_bar.dart';
import 'package:bili_app/widget/video_header.dart';
import 'package:bili_app/widget/video_large_card.dart';
import 'package:bili_app/widget/video_toolbar.dart';
import 'package:bili_app/widget/video_view.dart';
import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论299"];
  VideoDetailMo? videoDetailMo;
  VideoModel? videoModel;
  List<VideoModel> videoList = [];
  var _barrageKey = GlobalKey<HiBarrageState>();

  @override
  void initState() {
    super.initState();
    //黑色状态栏 仅安卓
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;

    _loadDetail();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: videoModel?.url != null
              ? Column(
                  children: [
                    //iOS 黑色状态栏
                    NavigationBar(
                      color: Colors.black,
                      statusStyle: StatusStyle.LIGHT_CONTENT,
                      height: Platform.isAndroid ? 0 : 46,
                    ),
                    _buildVideoView(),
                    _buildTabNavigation(),
                    Flexible(
                        child: TabBarView(
                      controller: _controller,
                      children: [
                        _buildDetailList(),
                        Container(
                          child: Text('敬请期待...'),
                        )
                      ],
                    ))
                  ],
                )
              : Container()),
    );
  }

  _buildVideoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
      barrageUI: HiBarrage(vid: model.vid, key: _barrageKey, autoPlay: true),
    );
  }

  _buildTabNavigation() {
    //使用Material实现阴影效果
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((name) {
        return Tab(
          text: name,
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  buildContents() {
    return [
      VideoHeader(owner: videoModel!.owner),
      ExpandableContent(mo: videoModel!),
      VideoToolBar(
        detailMo: videoDetailMo,
        videoModel: videoModel!,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailMo result = await VideoDetailDao.get(videoModel!.vid);
      print(result);
      setState(() {
        videoDetailMo = result;
        //更新旧数据
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void _doLike() async {
    try {
      var result = await LikeDao.like(videoModel!.vid, !videoDetailMo!.isLike);
      print(result);
      videoDetailMo!.isLike = !videoDetailMo!.isLike;
      if (videoDetailMo!.isLike) {
        videoModel!.like += 1;
      } else {
        videoModel!.like -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  void _onUnLike() {}

  void _onFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel!.vid, !videoDetailMo!.isFavorite);
      print(result);
      videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite;
      if (videoDetailMo!.isFavorite) {
        videoModel!.favorite += 1;
      } else {
        videoModel!.favorite -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildVideoList() {
    return videoList
        .map((VideoModel mo) => VideoLargeCard(videoModel: mo))
        .toList();
  }
}

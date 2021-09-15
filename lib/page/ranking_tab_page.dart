import 'package:bili_app/http/core/hi_error.dart';
import 'package:bili_app/http/dao/ranking_dao.dart';
import 'package:bili_app/model/ranking_mo.dart';
import 'package:bili_app/model/video_model.dart';
import 'package:bili_app/util/color.dart';
import 'package:bili_app/util/toast.dart';
import 'package:bili_app/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RankingTabPage extends StatefulWidget {
  final String sortKey;

  const RankingTabPage({Key? key, required this.sortKey}) : super(key: key);

  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState extends State<RankingTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  bool _loading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print('dis:$dis');
      //当距离底部不足300时加载更多
      if (dis < 300 && !_loading) {
        print('------_loadData---');
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _loadData,
      color: primary,
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: StaggeredGridView.countBuilder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              crossAxisCount: 1,
              itemCount: videoList.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoCard(videoMo: videoList[index]);
              },
              staggeredTileBuilder: (int index) {
                return StaggeredTile.fit(1);
              })),
    );
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('Ranking:currentIndex:$currentIndex');
    try {
      RankingMo result = await RankingDao.get(widget.sortKey,
          pageIndex: currentIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            //合成一个新数组
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

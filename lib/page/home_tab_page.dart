import 'package:bili_app/core/hi_base_tab_state.dart';

import 'package:bili_app/http/dao/home_dao.dart';
import 'package:bili_app/model/home_mo.dart';
import 'package:bili_app/model/video_model.dart';

import 'package:bili_app/widget/hi_banner.dart';
import 'package:bili_app/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState
    extends HiBaseTabState<HomeMo, VideoModel, HomeTabPage> {
  @override
  void initState() {
    super.initState();
    print(widget.categoryName);
    print(widget.bannerList);
  }

  _banner(List<BannerMo> bannerList) {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(bannerList));
  }

  @override
  get contentChild => StaggeredGridView.countBuilder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      crossAxisCount: 2,
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        //有banner时第一个item位置显示banner
        if (widget.bannerList != null && index == 0) {
          return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: _banner(widget.bannerList!));
        } else {
          return VideoCard(videoMo: dataList[index]);
        }
      },
      staggeredTileBuilder: (int index) {
        if (widget.bannerList != null && index == 0) {
          return StaggeredTile.fit(2);
        } else {
          return StaggeredTile.fit(1);
        }
      });

  @override
  Future<HomeMo> getData(int pageIndex) async {
    HomeMo result = await HomeDao.get(widget.categoryName,
        pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeMo result) {
    return result.videoList;
  }
}

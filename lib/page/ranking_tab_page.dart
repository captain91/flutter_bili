import 'package:bili_app/core/hi_base_tab_state.dart';
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
  final String sort;

  const RankingTabPage({Key? key, required this.sort}) : super(key: key);

  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState
    extends HiBaseTabState<RankingMo, VideoModel, RankingTabPage> {
  @override
  get contentChild => StaggeredGridView.countBuilder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10),
      crossAxisCount: 1,
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return VideoCard(videoMo: dataList[index]);
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(1);
      });

  @override
  Future<RankingMo> getData(int pageIndex) async {
    RankingMo result =
        await RankingDao.get(widget.sort, pageIndex: pageIndex, pageSize: 1);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingMo result) {
    return result.list;
  }
}

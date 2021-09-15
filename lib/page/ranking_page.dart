import 'package:bili_app/page/ranking_tab_page.dart';
import 'package:bili_app/util/view_util.dart';
import 'package:bili_app/widget/hi_tab.dart';
import 'package:bili_app/widget/loading_container.dart';
import 'package:bili_app/widget/navigation_bar.dart';
import 'package:flutter/material.dart';

///排行
class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with TickerProviderStateMixin {
  static const TABS = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"}
  ];

  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: TABS.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingContainer(
      child: Column(
        children: [
          NavigationBar(
            height: 50,
            child: Container(
              alignment: Alignment.center,
              child: _tabBar(),
            ),
            color: Colors.white,
            statusStyle: StatusStyle.DARK_CONTENT,
          ),
          Flexible(
              child: TabBarView(
                  controller: _controller,
                  children: TABS.map((tab) {
                    return RankingTabPage(sortKey: tab['key'].toString());
                  }).toList())),
        ],
      ),
    ));
  }

  _tabBar() {
    return HiTab(
      TABS.map<Tab>((tab) {
        return Tab(
          text: tab['name'],
        );
      }).toList(),
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      controller: _controller,
    );
  }
}

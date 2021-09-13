import 'package:bili_app/db/hi_cache.dart';
import 'package:bili_app/http/dao/login_dao.dart';
import 'package:bili_app/model/video_model.dart';
import 'package:bili_app/page/home_page.dart';
import 'package:bili_app/page/login_page.dart';
import 'package:bili_app/page/registration_page.dart';
import 'package:bili_app/page/video_detail_page.dart';
import 'package:bili_app/util/color.dart';
import 'package:bili_app/util/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigator/hi_navigator.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        //进行初始化
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          //定义route
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : Scaffold(body: Center(child: CircularProgressIndicator()));

          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: white),
          );
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRouthPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRouthPath> {
  final GlobalKey<NavigatorState> navigatorKey;

  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      pages.clear();
      page = pageWrap(HomePage(
        onJumpToDetail: (videoModel) {
          this.videoModel = videoModel;
          notifyListeners();
        },
      ));
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage(onJumpToLogin: () {
        _routeStatus = RouteStatus.login;
        notifyListeners();
      }));
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage(
        onJumpRegistration: () {
          _routeStatus = RouteStatus.registration;
          notifyListeners();
        },
        onSuccess: () {
          _routeStatus = RouteStatus.home;
          notifyListeners();
        },
      ));
    }
    tempPages = [...tempPages, page];
    pages = tempPages;

    return WillPopScope(
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          if ((route.settings as MaterialPage).child is LoginPage) {
            if (!hasLogin) {
              showToast('请先登录');
              return false;
            }
          }
          if (!route.didPop(result)) {
            return false;
          }
          pages.removeLast();
          return true;
        },
      ),
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
    );
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Future<void> setNewRoutePath(BiliRouthPath path) async {}
}

class BiliRouthPath {
  final String location;
  BiliRouthPath.home() : location = "/";
  BiliRouthPath.detail() : location = "/detail";
}

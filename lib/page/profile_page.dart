import 'package:bili_app/http/core/hi_error.dart';
import 'package:bili_app/http/dao/profile_dao.dart';
import 'package:bili_app/model/profile_mo.dart';
import 'package:bili_app/util/toast.dart';
import 'package:bili_app/util/view_util.dart';
import 'package:bili_app/widget/hi_blur.dart';
import 'package:bili_app/widget/hi_flexible_header.dart';
import 'package:flutter/material.dart';

///我的
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileMo? _profileMo;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      controller: _controller,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('标题$index'),
          );
        },
        itemCount: 100,
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                titlePadding: EdgeInsets.only(left: 0),
                title: _buildHead(),
                background: Stack(
                  children: [
                    Positioned.fill(
                        child: cachedImage(
                            'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
                    Positioned.fill(child: HiBlur(sigma: 20)),
                    // Positioned(child: child)
                  ],
                )),
          )
        ];
      },
    ));
  }

  void _loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      print(result);
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildHead() {
    if (_profileMo == null) return Container();
    return HiFlexibleHeader(
        name: _profileMo!.name,
        face: _profileMo!.face,
        controller: _controller);
  }
}

import 'dart:async';
import 'dart:math';

import 'package:bili_app/barrage/barrage_item.dart';
import 'package:bili_app/barrage/hi_socket.dart';
import 'package:bili_app/barrage/ibarrage.dart';
import 'package:bili_app/model/barrage_model.dart';
import 'package:flutter/material.dart';

enum BarrageStatus { play, pause }

class HiBarrage extends StatefulWidget {
  final int lineCount;
  final String vid;
  final int speed; //毫秒
  final double top;
  final bool autoPlay;

  const HiBarrage(
      {Key? key,
      this.lineCount = 4,
      required this.vid,
      this.speed = 800,
      this.top = 10,
      this.autoPlay = false})
      : super(key: key);

  @override
  HiBarrageState createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  late HiSocket _hiSocket;
  late double _height;
  late double _width;
  List<BarrageItem> _barrageItemList = []; //弹幕widget集合
  List<BarrageModel> _barrageModelList = []; //弹幕模型
  int _barrageIndex = 0; //第几条弹幕
  Random _random = Random();
  BarrageStatus? _barrageStatus;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket();
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    _hiSocket.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width / 16 * 9;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          //防止Stack的child为空
          Container()
        ]..addAll(_barrageItemList),
      ),
    );
  }

  ///处理消息，instant=true 马上发送
  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }

    //收到新的弹幕后播放
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }
    //收到新的弹幕后播放
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    print('action:Play');
    if (_timer != null && (_timer?.isActive ?? false)) return;
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        //将发送的弹幕将集合中剔除
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
        print('start:${temp.content}');
      } else {
        print('All barrage are sent.');
        //弹幕发送完毕后关闭定时器
        _timer?.cancel();
      }
    });
  }

  void addBarrage(BarrageModel temp) {}

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    //清空屏幕上的弹幕
    _barrageItemList.clear();
    setState(() {});
    print('action:pause');
    _timer?.cancel();
  }

  @override
  void send(String message) {
    if (message == null) return;
    _hiSocket.send(message);
    _handleMessage(
        [BarrageModel(content: message, vid: '-1', priority: 1, type: 1)]);
  }
}

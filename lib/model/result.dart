import 'package:json_annotation/json_annotation.dart';

// result.g.dart 将在我们运行生成命令后自动生成
part 'result.g.dart';

///这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()
class Result {
  //定义构造方法
  Result(this.code, this.method, this.requestPrams);
  //定义字段
  int code;
  String method;
  String requestPrams;

  //固定格式，不同的类使用不同的mixin即可
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  //固定格式
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}


import 'dart:ffi';

class Owner {
  String? name;
  String? face;
  int? fans;
  Owner({this.name, this.face, this.fans});
  //将 map 转成 mo
  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
  }

  //将 mo 转 map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['name'] = this.name;
    data['face'] = this.face;
    data['fans'] = this.fans;
    return data;
  }
}

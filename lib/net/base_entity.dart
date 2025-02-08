import 'package:flutter/foundation.dart';
import 'package:flutter_deer/generated/json/base/json_convert_content.dart';
import 'package:flutter_deer/res/constant.dart';

// 定义一个抽象类作为数据模型的基础，所有需要转换的数据模型都应该继承自这个类
abstract class BaseModel {
  factory BaseModel.fromJson(Map<String, dynamic> json) => throw UnimplementedError();
}


class BaseEntity<T> {

  BaseEntity(this.code, this.message, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    code = json[Constant.code] as int?;
    message = json[Constant.message] as String;
    if (json.containsKey(Constant.data)) {
      data = _generateOBJ<T>(json[Constant.data] as Object?);
    }
    // debugPrint('打印data: ${data}');
  }

  int? code;
  late String message;
  T? data;

  T? _generateOBJ<O>(Object? json) {
    if (json == null) {
      return null;
    }
    // print('对象的类型是: ${T.runtimeType is Type}');
    // debugPrint('打印类型T: ${json is Map}');
    debugPrint('打印类型T: ${T.toString()}');
    // debugPrint('打印json tostring: ${json.toString()}');
    if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    }else if (T.toString() == 'Map<String, dynamic>') {
      return json as T;
    } else {
      /// List类型数据由fromJsonAsT判断处理
      return JsonConvert.fromJsonAsT<T>(json);
    }
  }
}

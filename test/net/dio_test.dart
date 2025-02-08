import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deer/login/models/captcha_entity.dart';
import 'package:flutter_deer/net/intercept.dart';
import 'package:flutter_deer/net/net.dart';
import 'package:flutter_deer/res/constant.dart';
import 'package:flutter_deer/shop/models/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sp_util/sp_util.dart';
// import 'package:test/test.dart' as test2;
import 'package:shared_preferences/shared_preferences.dart';

void initDio() {
  final List<Interceptor> interceptors = <Interceptor>[];

  /// 统一添加身份验证请求头
  interceptors.add(AuthInterceptor());

  /// 刷新Token
  interceptors.add(TokenInterceptor());

  /// 打印Log(生产模式去除)
  if (!Constant.inProduction) {
    interceptors.add(LoggingInterceptor());
  }

  /// 适配数据(根据自己的数据结构，可自行选择添加)
  // interceptors.add(AdapterInterceptor());
  configDio(
    baseUrl: 'http://192.168.15.104:8888/',
    interceptors: interceptors,
  );
}

void main() {
  // 确保绑定已初始化
  TestWidgetsFlutterBinding.ensureInitialized();
  // Dio dio;
  // setUp(() async {
  //   // 设置 SharedPreferences 的模拟初始值
  //   SharedPreferences.setMockInitialValues({
  //     'accessToken':
  //         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiYzE5ODY5OTAtOGE3NC00ZGI2LThjMWYtYmM2NTBhZTg1MjdmIiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6IuWwj-WHhiIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJ0cmFkZSIsImF1ZCI6WyJHVkEiXSwiZXhwIjoxNzM5NTE3NzY1LCJuYmYiOjE3Mzg5MTI5NjV9.IZMzt18yo21bfJ9vzL5vJqTLdOVwm-qwHVeyjyHLkS0',
  //   });
  //   initDio();
  //   // 初始化 SpUtil
  //   await SpUtil.getInstance();
  // });

  group('base', () {
    Dio dio;
    setUp(() {
      /// 测试配置
      /// 测试配置 /base/captcha
      dio = DioUtils.instance.dio;
      dio.options.baseUrl = 'http://192.168.15.104:8888/';
    });
    // initDio();
    // 设置 SharedPreferences 的模拟初始值
    // SharedPreferences.setMockInitialValues({
    //   'exampleKey': 'exampleValue',
    // });

    /// sp初始化
    // await SpUtil.getInstance();

    test('captcha', () async {
      await DioUtils.instance.requestNetwork<Map<dynamic, dynamic>>(
          Method.post, 'base/captcha', onSuccess: (data) {
        // 打印完整的响应内容
        debugPrint('Response Data: ${data!.keys}');
        // debugPrint('Response Data: ${data!['captchaId']}');
        // 打印完整的响应内容
        // debugPrint('Response Code: ${data.statusCode}');
        // debugPrint('Response Headers: ${data.headers}');
        // debugPrint('Response Data: ${data.data}');
        // expect(data?.name, '唯鹿');
      }, onError: (code, msg) {
        debugPrint('报错信息：$code, $msg');
      });
    });

    test('orders', () async {
      final queryParameters = {
        'page': 1,
        'pageSize': 10,
      };
      var accessToken = SpUtil.getString(Constant.accessToken);
      debugPrint('token: $accessToken');
      await DioUtils.instance.requestNetwork<Map<String, dynamic>>(
          Method.get, 'tradeOrders/getTradeOrdersList',
          queryParameters: queryParameters, onSuccess: (data) {
        // 打印完整的响应内容
        debugPrint('Response Data: ${data!.keys}');
        // debugPrint('Response Data: ${data!['captchaId']}');
        // 打印完整的响应内容
        // debugPrint('Response Code: ${data.statusCode}');
        // debugPrint('Response Headers: ${data.headers}');
        // debugPrint('Response Data: ${data.data}');
        // expect(data?.name, '唯鹿');
      }, onError: (code, msg) {
        debugPrint('报错信息：$code, $msg');
      });
    });
  });
}

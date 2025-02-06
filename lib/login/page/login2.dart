// 登录页面2,表单字段有 用户名,密码,验证码,登录按钮，其中用户名和密码是必填项，验证码是2位图片验证码
// 验证码请求服务端接口返回请求网址:http://192.168.11.131:8866/api/base/captcha 请求方法:POST，响应字段：
// {
//     "code": 0,
//     "data": {
//         "captchaId": "fGbru3Mmeuy2bMxXm2z8",
//         "picPath": "data:image/png;base64,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",
//         "captchaLength": 2,
//         "openCaptcha": true
//     },
//     "msg": "验证码获取成功"
// }
// 验证码获取的picPath是base64编码的图片，需要解码后显示
// 登录按钮是登录按钮，点击后进行登录
// 登录按钮的样式是 背景颜色为蓝色，文字颜色为白色，文字为登录
// 登录按钮的点击事件是进行登录，登录成功后跳转到主页
// 登录按钮的点击事件是进行登录，登录成功后跳转到主页
// 验证码是2位图片验证码，点击后进行验证码的刷新
// 登录按钮提交时候，进行表单的校验，校验验证码是否正确，正确才进行登录。
// 登录成功后，跳转到主页
// 登录请求网址:http://192.168.11.131:8866/api/base/login 请求方法:POST，请求字段{"username":"admin","password":"123456","captcha":"81","captchaId":"fGbru3Mmeuy2bMxXm2z8","openCaptcha":true}
// 验证码从服务端获取到的内容直接显示图片展示
// 使用工具类DioUtils.instance.requestNetwork进行网络请求
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';

class LoginPage2 extends StatefulWidget {


  const LoginPage2({super.key});
  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<StatefulWidget> {
  // 表单key
  final _formKey = GlobalKey<FormState>();
  
  // 控制器
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  // 验证码相关
  String _captchaId = '';
  String _captchaImage = '';
  
  @override
  void initState() {
    super.initState();
    _getCaptcha();
  }

  // 获取验证码
  void _getCaptcha() async {
    await DioUtils.instance.requestNetwork<Map<dynamic, dynamic>>(
        Method.post, HttpApi.captcha,
        onSuccess: (data) {
          // 打印完整的响应内容
          debugPrint('Response Data: ${data!['captchaId']}');
          setState(() {
            _captchaId = data!['captchaId'] as String;
            _captchaImage = data!['picPath'] as String;
          });
        },
        onError: (code, msg) {
          debugPrint('报错信息：$code, $msg');
        }
    );
  }

  // 登录方法
  void _login() async {
    if(_formKey.currentState!.validate()) {
      try {
        var response = await DioUtils.instance.requestNetwork<Map<dynamic, dynamic>>(
          Method.post,
            HttpApi.login,
            onSuccess: (data) {
              // 打印完整的响应内容
              debugPrint('Response Data: $data');
              // 登录成功,跳转到主页
              Navigator.pushReplacementNamed(context, '/home');

            },
            onError: (code, msg) {
              debugPrint('报错信息：$code, $msg');
            },
          params: {
            'username': _usernameController.text,
            'password': _passwordController.text,
            'captcha': _captchaController.text,
            'captchaId': _captchaId,
            'openCaptcha': true
          }
        );
      } catch(e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: '用户名'),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return '请输入用户名';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '密码'),
                obscureText: true,
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _captchaController,
                      decoration: InputDecoration(labelText: '验证码'),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return '请输入验证码';
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: _getCaptcha,
                    child: Image.memory(
                      base64Decode(_captchaImage.split(',')[1]),
                      width: 100,
                      height: 40,
                    ),
                  )
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text('登录'),
              )
            ],
          ),
        ),
      ),
    );
  }
}



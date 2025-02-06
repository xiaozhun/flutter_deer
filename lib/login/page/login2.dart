import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  String _captchaId = '';
  String _captchaImage = '';
  bool _isCaptchaLoading = true;
  bool _isCaptchaError = false;

  @override
  void initState() {
    super.initState();
    _getCaptcha();
  }

  // 获取验证码
  void _getCaptcha() async {
    setState(() {
      _isCaptchaLoading = true;
      _isCaptchaError = false;
    });

    try {
      var response = await DioUtils.instance.requestNetwork<Map<String, dynamic>>(
        Method.post,
        HttpApi.captcha,
        onSuccess: (data) {
          if (data != null && data['captchaId'] is String && data['picPath'] is String) {
            setState(() {
              _captchaId = data!['captchaId'] as String;
              _captchaImage = data!['picPath'] as String;
            });
          } else {
            throw Exception('Invalid captcha response');
          }
        },
        onError: (code, msg) {
          debugPrint('报错信息：$code, $msg');
          setState(() {
            _isCaptchaError = true;
          });
        },
      );
    } catch (e) {
      debugPrint('获取验证码失败: $e');
      setState(() {
        _isCaptchaError = true;
      });
    } finally {
      setState(() {
        _isCaptchaLoading = false;
      });
    }
  }

  // 登录方法
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        var response = await DioUtils.instance.requestNetwork<Map<String, dynamic>>(
          Method.post,
          HttpApi.login,
          params: {
            'username': _usernameController.text,
            'password': _passwordController.text,
            'captcha': _captchaController.text,
            'captchaId': _captchaId,
            'openCaptcha': true,
          },
          onSuccess: (data) {
            debugPrint('Response Data: $data');
            Navigator.pushReplacementNamed(context, '/home');
          },
          onError: (code, msg) {
            debugPrint('登录失败: $code, $msg');
            setState(() {
              _isCaptchaError = true; // 标记验证码错误状态
            });
            _getCaptcha(); // 登录失败后重新获取验证码
          },
        );
      } catch (e) {
        print(e);
        setState(() {
          _isCaptchaError = true; // 标记验证码错误状态
        });
        _getCaptcha(); // 登录失败后重新获取验证码
      }
    }
  }

  Widget _buildCaptchaImage(BuildContext context) {
    if (_isCaptchaLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_isCaptchaError) {
      return Column(
        children: [
          Text('验证码加载失败，请点击刷新'),
          ElevatedButton(
            onPressed: _getCaptcha,
            child: Text('刷新验证码'),
          ),
        ],
      );
    } else {
      try {
        Uint8List bytes = base64Decode(_captchaImage.split(',')[1]);
        return Image.memory(bytes, width: 100, height: 40);
      } catch (e) {
        debugPrint('Base64 decode error: $e');
        return Column(
          children: [
            Text('验证码加载失败，请点击刷新'),
            ElevatedButton(
              onPressed: _getCaptcha,
              child: Text('刷新验证码'),
            ),
          ],
        );
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
                  if (value == null || value.isEmpty) {
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
                  if (value == null || value.isEmpty) {
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
                        if (value == null || value.isEmpty) {
                          return '请输入验证码';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  _buildCaptchaImage(context),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text('登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
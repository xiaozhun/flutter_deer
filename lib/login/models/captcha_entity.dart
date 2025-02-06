import '../../generated/json/base/json_field.dart';


@JsonSerializable()
class CaptchaEntity{

  CaptchaEntity({required this.captchaId, required this.picPath, required this.captchaLength, required this.openCaptcha});

   CaptchaEntity.fromJson(Map<String, dynamic> json) {
    captchaId = json['captchaId'] as String;
    picPath = json['picPath'] as String;
    captchaLength = json['captchaLength'] as int;
    openCaptcha = json['openCaptcha'] as bool;
  }

  late String captchaId;
  late String picPath;
  late int captchaLength;
  late bool openCaptcha;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['captchaId'] = captchaId;
    data['picPath'] = picPath;
    data['captchaLength'] = captchaLength;
    data['openCaptcha'] = openCaptcha;
    return data;
  }
}
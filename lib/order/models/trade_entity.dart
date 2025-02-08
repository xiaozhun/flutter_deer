class Trade {
  String tradeId;
  String useruuid;
  String exchange;
  String tradedate;
  String stockCode;
  double tradeprice;
  int tradenumber;
  String tradetype;
  double fees;
  String state;
  String finished;
  String ftfupdate;
  String ftfuptime;
  double profit;
  String sellId;
  String sellState;
  String source;
  String rulename;
  String upprofittime;
  String upprofitdate;
  double profitrate;
  double zhiying;
  double zhisun;
  String mark;
  String clientId;
  int isTruesale;

  Trade({
    required this.tradeId,
    required this.useruuid,
    required this.exchange,
    required this.tradedate,
    required this.stockCode,
    required this.tradeprice,
    required this.tradenumber,
    required this.tradetype,
    required this.fees,
    required this.state,
    required this.finished,
    required this.ftfupdate,
    required this.ftfuptime,
    required this.profit,
    required this.sellId,
    required this.sellState,
    required this.source,
    required this.rulename,
    required this.upprofittime,
    required this.upprofitdate,
    required this.profitrate,
    required this.zhiying,
    required this.zhisun,
    required this.mark,
    required this.clientId,
    required this.isTruesale,
  });

  // 从JSON映射到实体类
  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      tradeId: json['tradeId'] as String? ?? '',
      useruuid: json['useruuid'] as String? ?? '',
      exchange: json['exchange'] as String? ?? '',
      tradedate: json['tradedate'] as String? ?? '',
      stockCode: json['stockCode'] as String? ?? '',
      tradeprice: (json['tradeprice'] as num?)?.toDouble() ?? 0.0,
      tradenumber: (json['tradenumber'] as num?)?.toInt() ?? 0,
      tradetype: json['tradetype'] as String? ?? '',
      fees: (json['fees'] as num?)?.toDouble() ?? 0.0,
      state: json['state'] as String? ?? '',
      finished: json['finished'] as String? ?? '',
      ftfupdate: json['ftfupdate'] as String? ?? '',
      ftfuptime: json['ftfuptime'] as String? ?? '',
      profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
      sellId: json['sellId'] as String? ?? '',
      sellState: json['sellState'] as String? ?? '',
      source: json['source'] as String? ?? '',
      rulename: json['rulename'] as String? ?? '',
      upprofittime: json['upprofittime'] as String? ?? '',
      upprofitdate: json['upprofitdate'] as String? ?? '',
      profitrate: (json['profitrate'] as num?)?.toDouble() ?? 0.0,
      zhiying: (json['zhiying'] as num?)?.toDouble() ?? 0.0,
      zhisun: (json['zhisun'] as num?)?.toDouble() ?? 0.0,
      mark: json['mark'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      isTruesale: (json['isTruesale'] as num?)?.toInt() ?? 0,
    );
  }

  // 将实体类转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'tradeId': tradeId,
      'useruuid': useruuid,
      'exchange': exchange,
      'tradedate': tradedate,
      'stockCode': stockCode,
      'tradeprice': tradeprice,
      'tradenumber': tradenumber,
      'tradetype': tradetype,
      'fees': fees,
      'state': state,
      'finished': finished,
      'ftfupdate': ftfupdate,
      'ftfuptime': ftfuptime,
      'profit': profit,
      'sellId': sellId,
      'sellState': sellState,
      'source': source,
      'rulename': rulename,
      'upprofittime': upprofittime,
      'upprofitdate': upprofitdate,
      'profitrate': profitrate,
      'zhiying': zhiying,
      'zhisun': zhisun,
      'mark': mark,
      'clientId': clientId,
      'isTruesale': isTruesale,
    };
  }
}
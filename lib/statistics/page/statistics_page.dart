import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_deer/order/page/order_page.dart';
import 'package:flutter_deer/res/resources.dart';
import 'package:flutter_deer/routers/fluro_navigator.dart';
import 'package:flutter_deer/statistics/statistics_router.dart';
import 'package:flutter_deer/util/image_utils.dart';
import 'package:flutter_deer/util/screen_utils.dart';
import 'package:flutter_deer/util/theme_utils.dart';
import 'package:flutter_deer/widgets/load_image.dart';
import 'package:flutter_deer/widgets/my_card.dart';
import 'package:flutter_deer/widgets/my_flexible_space_bar.dart';
import 'package:flutter_echarts/flutter_echarts.dart'; // 引入 flutter_echarts
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import 'package:intl/intl.dart';

/// design/5统计/index.html
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, dynamic>? btcInfo;
  Map<String, dynamic>? ethInfo;
  bool isLoading = true;
  String errorMessage = '';

  List<Map<String, dynamic>> priceKList = []; // K 线图数据
  String selectedSymbol = 'btc'; // 当前选中的币种

  @override
  void initState() {
    super.initState();
    fetchPriceInfo();
    fetchKPriceList(selectedSymbol); // 初始化加载 BTC 的 K 线数据
  }

  Future<void> fetchPriceInfo() async {
    try {
      await DioUtils.instance.requestNetwork<Map<String, dynamic>>(
        Method.get,
        HttpApi.getPriceInfo,
        onSuccess: (data) {
          if (data != null) {
            setState(() {
              btcInfo = data['btcinfo'] as Map<String, dynamic>;
              ethInfo = data['ethinfo'] as Map<String, dynamic>;
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = 'Failed to load data: Data is null';
              isLoading = false;
            });
          }
        },
        onError: (code, msg) {
          setState(() {
            errorMessage = 'Error: $code, $msg';
            isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Exception: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchKPriceList(String symbol) async {
    try {
      await DioUtils.instance.requestNetwork<List<Map<String, dynamic>>>(
        Method.get,
        '${HttpApi.getKinfo}?symbol=$symbol',
        onSuccess: (data) {
          if (data != null) {
            // Toast.show('获取数量222:::${data.length}');
            // debugPrint('构建k原始数据2： ${data}');
            debugPrint('获取的 K 线前3条数据： ${data.take(3)}'); // 打印前 3 条数据
            setState(() {
              priceKList = data;
              // debugPrint('构建k线图数据： ${priceKList}');
              // Toast.show('获取数量:${priceKList.length}');
            });
          } else {
            setState(() {
              errorMessage = 'Failed to load price list: Data is null';
            });
          }
        },
        onError: (code, msg) {
          setState(() {
            errorMessage = 'Error: $code, $msg';
          });
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Exception: $e';
      });
    }
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      timestamp > 9999999999 ? timestamp : timestamp * 1000,isUtc: true,
    ).add(Duration(hours: 8));
    final format = DateFormat('MM/dd HH:mm');
    return format.format(date);
  }
  // 只保留日期
  String _formatTimestamp2(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      timestamp > 9999999999 ? timestamp : timestamp * 1000,isUtc: true,
    ).add(Duration(hours: 8));
    final format = DateFormat('yyyy/MM/dd');
    debugPrint('格式化日期： ${format.format(date)}');
    return format.format(date);
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        key: const Key('statistic_list'),
        physics: const ClampingScrollPhysics(),
        slivers: _sliverBuilder(),
      ),
    );
  }

  List<Widget> _sliverBuilder() {
    isDark = context.isDark;
    return <Widget>[
      SliverAppBar(
        systemOverlayStyle: isDark ? ThemeUtils.light : ThemeUtils.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        expandedHeight: 100.0,
        pinned: true,
        flexibleSpace: MyFlexibleSpaceBar(
          background: isDark
              ? Container(height: 115.0, color: Colours.dark_bg_color)
              : LoadAssetImage('statistic/statistic_bg',
            width: context.width,
            height: 115.0,
            fit: BoxFit.fill,
          ),
          centerTitle: true,
          titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
          collapseMode: CollapseMode.pin,
          title: Text('统计', style: TextStyle(color: ThemeUtils.getIconColor(context))),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? Colours.dark_bg_color : null,
              image: isDark
                  ? null
                  : DecorationImage(
                image: ImageUtils.getAssetImage('statistic/statistic_bg1'),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              height: 120.0,
              child: const MyCard(
                child: Row(
                  children: <Widget>[
                    _StatisticsTab('新订单(单)', 'xdd', '80'),
                    _StatisticsTab('待配送(单)', 'dps', '80'),
                    _StatisticsTab('今日交易额(元)', 'jrjye', '8000.00'),
                  ],
                ),
              ),
            ),
          ),
          120.0,
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (btcInfo != null && ethInfo != null) _buildCryptoInfoSection(),
              Gaps.vGap16,
              Text('K 线图', style: TextStyles.textBold18),
              Gaps.vGap16,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedSymbol = 'btc';
                      });
                      fetchKPriceList(selectedSymbol);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSymbol == 'btc' ? Colors.blue : Colors.grey,
                    ),
                    child: Text('BTC'),
                  ),
                  Gaps.hGap16,
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedSymbol = 'eth';
                      });
                      fetchKPriceList(selectedSymbol);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSymbol == 'eth' ? Colors.blue : Colors.grey,
                    ),
                    child: Text('ETH'),
                  ),
                ],
              ),
              Gaps.vGap16,
              _buildCandlestickChart(),
              Gaps.vGap16,
              Text('数据走势', style: TextStyles.textBold18),
              Gaps.vGap16,
              _StatisticsItem('订单统计', 'sjzs', 1),
              Gaps.vGap8,
              _StatisticsItem('交易额统计', 'jyetj', 2),
              Gaps.vGap8,
              _StatisticsItem('商品统计', 'sptj', 3),

              if (isLoading) Center(child: CircularProgressIndicator()),
              if (errorMessage.isNotEmpty) Center(child: Text(errorMessage)),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildCryptoInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.vGap32,
        Text('加密货币价格信息', style: TextStyles.textBold18),
        Gaps.vGap16,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCryptoInfoCard('BTC', btcInfo!),
            ),
            Gaps.hGap16,
            Expanded(
              child: _buildCryptoInfoCard('ETH', ethInfo!),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCryptoInfoCard(String title, Map<String, dynamic> info) {
    return MyCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title 价格信息',
              style: TextStyles.textBold16,
            ),
            Gaps.vGap8,
            _buildInfoRow('Open', info['open'].toString()),
            _buildInfoRow('Close', info['close'].toString()),
            _buildInfoRow('Day High', info['dayhigh'].toString()),
            _buildInfoRow('Day Low', info['daylow'].toString()),
            _buildInfoRow('4 Hour High', info['hour4high'].toString()),
            _buildInfoRow('4 Hour Low', info['hour4low'].toString()),
            _buildInfoRow('bofu15', (info['bofu15'].toInt()).toString()),
            _buildInfoRow('bofu4h', (info['bofu4h'].toInt()).toString()),
            _buildInfoRow('Insert Time', _formatTimestamp(int.parse(info['insertTime'].toString()))),
          ],
        ),
      ),
    );
  }

  Widget _buildCandlestickChart() {
    debugPrint('构建k线图数据是否为空： ${priceKList.isEmpty}');
    // 检查数据有效性：确保每个数据项都包含必要的字段且类型正确
    final validData = priceKList.where((item) {
      return item['Timestamp'] != null &&
          item['Open'] != null &&
          item['Close'] != null &&
          item['Low'] != null &&
          item['High'] != null &&
          item['Open'] is num &&
          item['Close'] is num &&
          item['Low'] is num &&
          item['High'] is num;
    }).toList();
    if (validData.isEmpty) {
      return Center(child: Text('暂无数据'));
    }
    // 对数据集合从小到大排序
    validData.sort((a, b) => (a['Timestamp'] as int).compareTo(b['Timestamp'] as int));
    List<String> tm = validData.map((item) => _formatTimestamp2(item['Timestamp'] as int)).toList();
    debugPrint('日期字符串$tm');
    return SizedBox(
      height: 300,
      child: Echarts(
        option: '''
        {
          xAxis: {
            type: 'category',
            data: $tm,
            axisLabel: {
              rotate: -45,
              interval: 1,
            }
          },
          yAxis: {
            scale: true,
          },
          series: [{
            type: 'candlestick',
            data: ${validData.map((item) => [
          item['Open']?.toDouble() ?? 0.0,
          item['Close']?.toDouble() ?? 0.0,
          item['Low']?.toDouble() ?? 0.0,
          item['High']?.toDouble() ?? 0.0,
        ]).toList()},
            itemStyle: {
              color: '#ec0000', 
              color0: '#00da3c', 
              borderColor: '#8A0000',
              borderColor0: '#008F28'
            },
            label: {
              show: true, 
              position: 'top', 
            }
          }],
          tooltip: {
            trigger: 'axis',
            axisPointer: {
              type: 'cross'
            }
          },
          grid: {
            left: '10%',
            right: '10%',
            bottom: '20%'
          }
        }
      ''',
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsItem extends StatelessWidget {
  const _StatisticsItem(this.title, this.img, this.index);

  final String title;
  final String img;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.14,
      child: GestureDetector(
        onTap: () {
          if (index == 1 || index == 2) {
            NavigatorUtils.push(context, '${StatisticsRouter.orderStatisticsPage}?index=$index');
          } else {
            NavigatorUtils.push(context, StatisticsRouter.goodsStatisticsPage);
          }
        },
        child: MyCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(title, style: TextStyles.textBold14),
                      const LoadAssetImage('statistic/icon_selected', height: 16.0, width: 16.0)
                    ],
                  ),
                ),
                Expanded(child: LoadAssetImage('statistic/$img', fit: BoxFit.fill))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatisticsTab extends StatelessWidget {
  const _StatisticsTab(this.title, this.img, this.content);

  final String title;
  final String img;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MergeSemantics(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoadAssetImage('statistic/$img', width: 40.0, height: 40.0),
            Gaps.vGap4,
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            Gaps.vGap8,
            Text(content, style: const TextStyle(fontSize: Dimens.font_sp18)),
          ],
        ),
      ),
    );
  }
}
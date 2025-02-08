import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deer/net/dio_utils.dart';
import 'package:flutter_deer/net/http_api.dart';
import 'package:flutter_deer/order/models/trade_entity.dart';
import 'package:flutter_deer/order/provider/order_page_provider.dart';
import 'package:flutter_deer/order/widgets/order_item.dart';
import 'package:flutter_deer/order/widgets/order_tag_item.dart';
import 'package:flutter_deer/util/change_notifier_manage.dart';
import 'package:flutter_deer/widgets/my_refresh_list.dart';
import 'package:flutter_deer/widgets/state_layout.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with
        AutomaticKeepAliveClientMixin<OrderListPage>,
        ChangeNotifierMixin<OrderListPage> {
  final ScrollController _controller = ScrollController();
  final StateType _stateType = StateType.loading;

  /// 是否正在加载数据
  bool _isLoading = false;
  final int _maxPage = 3;
  int _page = 1;
  int _index = 0;
  List<Trade> _list = <Trade>[];

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    _onRefresh();
  }

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    return {_controller: null};
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener(
      onNotification: (ScrollNotification note) {
        if (note.metrics.pixels == note.metrics.maxScrollExtent) {
          _loadMore();
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        displacement: 120.0,

        /// 默认40， 多添加的80为Header高度
        child: Consumer<OrderPageProvider>(
          builder: (_, provider, child) {
            return CustomScrollView(
              /// 这里指定controller可以与外层NestedScrollView的滚动分离，避免一处滑动，5个Tab中的列表同步滑动。
              /// 这种方法的缺点是会重新layout列表
              controller: _index != provider.index ? _controller : null,
              key: PageStorageKey<String>('$_index'),
              slivers: <Widget>[
                SliverOverlapInjector(
                  ///SliverAppBar的expandedHeight高度,避免重叠
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                child!,
              ],
            );
          },
          child: SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: _list.isEmpty
                ? SliverFillRemaining(child: StateLayout(type: _stateType))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return index < _list.length
                          ? (index % 5 == 0
                              ? const OrderTagItem(
                                  date: '2025年2月5日', orderTotal: 4)
                              : OrderItem(
                                  key: Key('order_item_$index'),
                                  index: index,
                                  tabIndex: _index,
                                  order: _list[index]))
                          : MoreWidget(_list.length, _hasMore(), 10);
                    }, childCount: _list.length + 1),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // await Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {
    //     _page = 1;
    //     _list = List.generate(10, (i) => 'newItem：$i');
    //   });
    // });
    final queryParameters = {
      'page': _page,
      'pageSize': 10,
    };
    // 调用_getOrderList函数
    List<Trade> tradeOrders =await _getOrderList(queryParameters);
    setState(() {
      _page = 1;
      _list = tradeOrders;
    });
  }

  // 将加载数据提取出来
  Future<List<Trade>> _getOrderList(
    Map<String, dynamic> queryParameters) async {
    try {
      final response =
          await DioUtils.instance.requestNetwork<Map<String, dynamic>>(
        Method.get,
        HttpApi.orders,
        queryParameters: queryParameters,
      );
      if (response != null && response['list'] is List) {
        debugPrint("获取订单数量: ${response['total']}");
        // 将获取的列表转换为List<Trade>
        List listRes = response['list'] as List;
        List<Trade> tradeOrders = listRes
            .map((item) => Trade.fromJson(item as Map<String, dynamic>))
            .toList();
        return tradeOrders;
      } else {
        return <Trade>[];
      }
    } catch (e) {
      debugPrint('获取订单列表失败: $e');
      return <Trade>[];
    }
  }

  bool _hasMore() {
    return _page < _maxPage;
  }

  Future<void> _loadMore() async {
    if (_isLoading) {
      return;
    }
    if (!_hasMore()) {
      return;
    }
    _isLoading = true;
    try {
      final queryParameters = {
        'page': _page==1?_page+1:_page,
        'pageSize': 10,
      };
      // 调用_getOrderList函数
      List<Trade> tradeOrders =await _getOrderList(queryParameters);
      setState(() {
        _list.addAll(tradeOrders);
        _page++;
        _isLoading= false;
      });
    }catch (e) {
      debugPrint('加载更多失败: $e');
      _isLoading = false;
    }
    // await Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {
    //     _list.addAll(List.generate(10, (i) => 'newItem：$i'));
    //     _page++;
    //     _isLoading = false;
    //   });
    // });
  }

  @override
  bool get wantKeepAlive => true;
}

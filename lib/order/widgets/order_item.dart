// 订单列表页面
// 订单列表页面使用工具类DioUtils.instance.requestNetwork进行网络请求
// 请求地址:http://192.168.11.131:8866/tradeOrders/getTradeOrdersList?page=1&pageSize=10 请求方法:POST，请求字段{"pageNum":1,"pageSize":10,"orderStatus":0,"orderType":0,"orderId":0,"orderNo":""}
// 请求成功后，将数据绑定到ListView中

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deer/order/models/trade_entity.dart';
import 'package:flutter_deer/order/widgets/pay_type_dialog.dart';
import 'package:flutter_deer/res/resources.dart';
import 'package:flutter_deer/routers/fluro_navigator.dart';
import 'package:flutter_deer/util/other_utils.dart';
import 'package:flutter_deer/util/theme_utils.dart';
import 'package:flutter_deer/util/toast_utils.dart';
import 'package:flutter_deer/widgets/my_card.dart';

import '../order_router.dart';

const List<String> orderLeftButtonText = ['拒单', '拒单', '订单跟踪', '订单跟踪', '订单跟踪'];
const List<String> orderRightButtonText = ['接单', '开始配送', '完成', '', ''];

class OrderItem extends StatelessWidget {

  const OrderItem({
    super.key,
    required this.tabIndex,
    required this.index,
    required this.order,
  });

  final int tabIndex;
  final int index;
  final Trade order;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: MyCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () => NavigatorUtils.push(context, OrderRouter.orderInfoPage),
            child: _buildContent(context),
          ),
        ),
      )
    );
  }
  // 列表页面
  Widget _buildContent(BuildContext context) {
    final TextStyle? textTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: Dimens.font_sp12);
    final bool isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text('${order.stockCode}  ${order.tradeprice}'),
            ),
            Text(
              '交易时间:${order.tradedate.length>0?DateUtil.formatDateMs(int.parse(order.tradedate),format:DateFormats.y_mo_d_h_m):0}',
              style: TextStyle(
                fontSize: Dimens.font_sp12,
                // color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text('交易总额：${(order.tradeprice*order.tradenumber).toStringAsFixed(1)}'),
            ),
            Text(
              '利润更新:${order.upprofittime.length>0?DateUtil.formatDateMs(int.parse(order.upprofittime),format:DateFormats.y_mo_d_h_m):0}',
              style: TextStyle(
                fontSize: Dimens.font_sp12,
                // color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        Gaps.vGap8,
        Text(
          '交易状态：${order.state} 交易类型：${order.tradetype}  卖单状态：${order.sellState}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Gaps.vGap8,
        Gaps.line,
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: <TextSpan>[
              TextSpan(text: '利润值：${order.profit.toStringAsFixed(2)}  利润率: ${(order.profitrate*100).toStringAsFixed(2)}%',style: TextStyle(color: Theme.of(context).colorScheme.error,)),
              // TextSpan(text: '  x1', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
        Gaps.vGap12,
        Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: textTextStyle,
                  children: <TextSpan>[
                    TextSpan(text: '止盈率： ${order.zhiying>0?order.zhiying:'默认'       }'),
                    // TextSpan(text: '止损率： ${order.zhisun>0?order.zhisun:'默认'}'),
                    // TextSpan(text: '  共3件商品', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: Dimens.font_sp10)),
                  ],
                ),
              ),
            ),
            Text(
              '止损率： ${order.zhisun>0?order.zhisun:'默认'}',
              style: TextStyles.textSize12,
            ),
          ],
        ),
        Gaps.vGap8,
        Gaps.line,
        Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: textTextStyle,
                  children: <TextSpan>[
                    TextSpan(text: '订单号： ${order.tradeId}'),
                    // TextSpan(text: '止损率： ${order.zhisun>0?order.zhisun:'默认'}'),
                    // TextSpan(text: '  共3件商品', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: Dimens.font_sp10)),
                  ],
                ),
              ),
            ),
            Text(
              '对单号： ${order.sellId}',
              style: TextStyles.textSize12,
            ),
          ],
        ),
        Gaps.vGap8,
        Row(
          children: <Widget>[
            OrderItemButton(
              key: Key('order_button_1_$index'),
              text: '修改止盈',
              textColor: isDark ? Colours.dark_text : Colours.text,
              bgColor: isDark ? Colours.dark_material_bg : Colours.bg_gray,
              onTap: () {
                _showZhiyingDialog(context,order.tradeId);
              },
            ),
            const Expanded(
              child: Gaps.empty,
            ),
            if (orderRightButtonText[tabIndex].isEmpty) Gaps.empty else Gaps.hGap10,
            if (order.tradetype=='SELL' || (order.sellState!='no' && order.tradetype=='BUY')) Gaps.empty else OrderItemButton(
              key: Key('order_button_3_$index'),
              text: '卖出',
              textColor: isDark ? Colours.dark_button_text : Colors.white,
              bgColor: isDark ? Colours.dark_app_main : Colours.app_main,
              onTap: () {
                if (tabIndex == 2) {
                  _showPayTypeDialog(context);
                }
              },
            ),
          ],
        )
      ],
    );
  }

  void _showCallPhoneDialog(BuildContext context, String phone) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text('是否拨打：$phone ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => NavigatorUtils.goBack(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Utils.launchTelURL(phone);
                NavigatorUtils.goBack(context);
              },
              style: ButtonStyle(
                // 按下高亮颜色
                overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.error.withOpacity(0.2)),
              ),
              child: Text('拨打', style: TextStyle(color: Theme.of(context).colorScheme.error),),
            ),
          ],
        );
      },
    );
  }


  void _showPayTypeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PayTypeDialog(
          onPressed: (index, type) {
            Toast.show('收款类型：$type');
          },
        );
      },
    );
  }
//   新建修改止盈弹窗
  void _showZhiyingDialog(BuildContext context,String orderId) {
    String _name = ''; // 定义一个变量来存储输入的值
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('设置止盈止损'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '止盈',
                  hintText: '请输入止盈',
                ),
                onChanged: (value) {
                  _name = value; // 更新_name变量的值
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '止损',
                  hintText: '请输入止损',
                ),
                onChanged: (value) {
                  _name = value; // 更新_name变量的值
                },
              ),
            ],
          ),
          actions: [
            Text('订单号：$orderId'),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),// 关闭对话框,
              child: Text('提交'),
            ),
          ],
        );
      },
    );
  }

}


class OrderItemButton extends StatelessWidget {
  
  const OrderItemButton({
    super.key,
    this.bgColor,
    this.textColor,
    required this.text,
    this.onTap
  });
  
  final Color? bgColor;
  final Color? textColor;
  final GestureTapCallback? onTap;
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        constraints: const BoxConstraints(
          minWidth: 64.0,
          maxHeight: 30.0,
          minHeight: 30.0,
        ),
        child: Text(text, style: TextStyle(fontSize: Dimens.font_sp14, color: textColor),),
      ),
    );
  }
}

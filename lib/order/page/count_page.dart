import 'package:flutter/material.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';

class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  _CountPageState createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  String selectedCurrency = "ETH_USDT"; // 默认选中的币种
  List<dynamic> dataList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData(selectedCurrency); // 页面初始化时加载默认币种的数据
  }

  Future<void> fetchData(String currency) async {
    setState(() {
      isLoading = true;
    });

    final queryParameters = <String, dynamic>{
      'page': 1,
      'pageSize': 100,
      'symbol': currency,
    };

    try {
      await DioUtils.instance.requestNetwork<Map<String, dynamic>>(
        Method.get,
        HttpApi.countInfo,
        queryParameters: queryParameters,
        onSuccess: (data) {
          if(data!=null){
            List listRes = data!['list'] as List;
            setState(() {
              dataList = listRes;
              isLoading = false;
            });
          }else{
            debugPrint('报错信息：data为空');
            setState(() {
              isLoading = false;
            });
          };
        },
        onError: (code, msg) {
          setState(() {
            isLoading = false;
          });
          debugPrint('报错信息：$code, $msg');
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('获取订单列表失败: $e');
    }
  }

  void onCurrencySelected(String currency) {
    setState(() {
      selectedCurrency = currency;
    });
    fetchData(currency);
  }

  Future<void> refreshData() async {
    return await fetchData(selectedCurrency);
  }

  Future<void> showAddDialog(BuildContext context) async {
    final TextEditingController buycountController = TextEditingController();
    final TextEditingController highController = TextEditingController();
    final TextEditingController lowController = TextEditingController();
    final TextEditingController stepController = TextEditingController();

    String selectedCurrency = "ETH_USDT"; // 默认选中的币种
    String selectedDotype = "spot"; // 默认选中的交易类型

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('新增数量'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedCurrency,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCurrency = newValue!;
                        });
                      },
                      items: <String>['BTC_USDT', 'ETH_USDT', 'XRP_USDT']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "spot",
                          groupValue: selectedDotype,
                          onChanged: (String? value) {
                            setState(() {
                              selectedDotype = value!;
                            });
                          },
                        ),
                        Text('现货'),
                        Radio<String>(
                          value: "margin",
                          groupValue: selectedDotype,
                          onChanged: (String? value) {
                            setState(() {
                              selectedDotype = value!;
                            });
                          },
                        ),
                        Text('杠杆'),
                      ],
                    ),
                    TextField(
                      controller: buycountController,
                      decoration: InputDecoration(labelText: '购买单量'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: highController,
                      decoration: InputDecoration(labelText: '高价'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: lowController,
                      decoration: InputDecoration(labelText: '低价'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: stepController,
                      decoration: InputDecoration(labelText: '步长'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 关闭对话框
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    final buycount = buycountController.text;
                    final high = highController.text;
                    final low = lowController.text;
                    final step = stepController.text;

                    if (buycount.isNotEmpty && high.isNotEmpty && low.isNotEmpty && step.isNotEmpty) {
                      await submitData(selectedCurrency, selectedDotype, int.parse(buycount), double.parse(high), double.parse(low), step);
                      Navigator.of(context).pop(); // 关闭对话框
                      await refreshData(); // 刷新数据
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('请填写所有必填项')));
                    }
                  },
                  child: Text('确定'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> submitData(String symbol, String dotype, int buycount, double high, double low, String step) async {
    final postData = {
      'symbol': symbol,
      'dotype': dotype,
      'buycount': buycount,
      'high': high,
      'low': low,
      'updatetime': step,
    };

    try {
      await DioUtils.instance.requestNetwork<Map<String, dynamic>>(
        Method.post,
        HttpApi.addTradeBuycount,
        params: postData,
        onSuccess: (data) {
          debugPrint("新增数量记录成功: ${data!}");
        },
        onError: (code, msg) {
          debugPrint('新增数量记录失败：$code, $msg');
        },
      );
    } catch (e) {
      debugPrint('新增数量记录异常: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('交易记录'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCurrencyButton('BTC_USDT', 'BTC'),
                _buildCurrencyButton('ETH_USDT', 'ETH'),
                _buildCurrencyButton('XRP_USDT', 'XRP'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showAddDialog(context); // 显示新增对话框
                  },
                ),
              ],
            ),
          ),
          Divider(), // 添加分隔线
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshData,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final item = dataList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '币种: ${item['symbol']}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('交易类型: ${item['dotype']}'),
                                    Text('购买单量: ${item['buycount']}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('高价: ${item['high']}'),
                                    Text('低价: ${item['low']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyButton(String currency, String label) {
    return ElevatedButton(
      onPressed: () => onCurrencySelected(currency),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(selectedCurrency == currency ? Colors.blue : Colors.grey),
      ),
      child: Text(label),
    );
  }
}
class Order {
  final int orderId;
  final String orderNo;
  final String customerName;
  final String address;
  final double totalPrice;
  final List<OrderItemDetail> items;
  final String createTime;

  Order({
    required this.orderId,
    required this.orderNo,
    required this.customerName,
    required this.address,
    required this.totalPrice,
    required this.items,
    required this.createTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsJson = json['items'] as List<dynamic>;
    List<OrderItemDetail> items = itemsJson
        .map((item) => OrderItemDetail.fromJson(item as Map<String, dynamic>)) // 使用类型断言
        .toList();

    return Order(
      orderId: json['orderId'] as int,
      orderNo: json['orderNo'] as String,
      customerName: json['customerName'] as String,
      address: json['address'] as String,
      totalPrice: json['totalPrice'].toDouble() as double,
      items: items,
      createTime: json['createTime'] as String,
    );
  }
}

class OrderItemDetail {
  final String name;
  final int quantity;

  OrderItemDetail({required this.name, required this.quantity});

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) {
    return OrderItemDetail(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
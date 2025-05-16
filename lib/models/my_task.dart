class MyTask {
  final int id;
  final String vin;
  final String carrierName;
  final String dealerName;
  final String orderStatus;
  final String orderDate;
  final bool confirmedDealer;

  MyTask({
    required this.id,
    required this.vin,
    required this.carrierName,
    required this.dealerName,
    required this.orderStatus,
    required this.orderDate,
    required this.confirmedDealer,
  });

  factory MyTask.fromJson(Map<String, dynamic> json) {
    return MyTask(
      id: json['id'] ?? 0,
      vin: json['vin'] ?? '',
      carrierName: json['carrierName'] ?? '',
      dealerName: json['dealerName'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      orderDate: json['orderDate'] ?? '',
      confirmedDealer: json['confirmedDealer'] ?? false,
    );
  }

  @override
  String toString() {
    return 'MyTask(id: $id, vin: $vin, carrier: $carrierName, status: $orderStatus)';
  }
}

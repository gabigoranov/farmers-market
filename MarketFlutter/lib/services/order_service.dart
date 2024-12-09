import 'package:dio/dio.dart';
import 'package:market/services/user_service.dart';
import '../models/order.dart';
import 'dio_service.dart';

final dio = DioClient().dio;


final class OrderService {
  factory OrderService() {
    return instance;
  }
  OrderService._internal();
  static final OrderService instance = OrderService._internal();


  Future<String> order(Order model) async{
    const url = 'https://farmers-api.runasp.net/api/orders';
    Response<dynamic> response = await dio.post(url, data: model.toJson());
    UserService.instance.reload();
    return response.data;
  }
}

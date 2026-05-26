import 'package:dio/dio.dart';
import '../../model/supplier_model.dart';

class ApiService {
  final Dio dio = Dio();

  Future<List<SupplierModel>> fetchSuppliers() async {
    final response = await dio.get(
      'https://jsonplaceholder.typicode.com/users',
    );

    final data = response.data as List;

    return data.map((e) => SupplierModel.fromJson(e)).toList();
  }
}

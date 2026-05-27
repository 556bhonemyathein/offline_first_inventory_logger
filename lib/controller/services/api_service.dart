// import 'package:dio/dio.dart';
// import 'package:logger/logger.dart';
// import '../../model/supplier_model.dart';

// class ApiService {
//   final logger = Logger();

//   final Dio dio = Dio(
//     BaseOptions(
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//     ),
//   );

//   Future<List<SupplierModel>> fetchSuppliers() async {
//     try {
//       logger.i("START API");

//       final response = await dio.get(
//         'https://jsonplaceholder.typicode.com/users',
//       );

//       logger.i("STATUS CODE: ${response.statusCode}");

//       logger.d(response.data);

//       final data = response.data as List;

//       final suppliers = data.map((e) => SupplierModel.fromJson(e)).toList();

//       logger.i("SUPPLIERS COUNT: ${suppliers.length}");

//       return suppliers;
//     } catch (e) {
//       logger.e("API ERROR: $e");

//       rethrow;
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../model/supplier_model.dart';

class ApiService {
  final logger = Logger();

  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  Future<List<SupplierModel>> fetchSuppliers() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      SupplierModel(id: 1, name: "Leanne Graham"),
      SupplierModel(id: 2, name: "Ervin Howell"),
      SupplierModel(id: 3, name: "Clementine Bauch"),
      SupplierModel(id: 4, name: "Patricia Lebsack"),
      SupplierModel(id: 5, name: "Chelsey Dietrich"),
    ];
  }
}

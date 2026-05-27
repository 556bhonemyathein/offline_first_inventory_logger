import '../../model/supplier_model.dart';
import '../services/api_service.dart';

class SupplierRepository {
  final ApiService apiService;

  SupplierRepository(this.apiService);

  Future<List<SupplierModel>> fetchSuppliers() async {
    return await apiService.fetchSuppliers();
  }
}

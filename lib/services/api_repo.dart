
import '../models/product.dart';
import 'api_provider.dart';
import '../utils/api_constants.dart' as _apiconstants;


ApiProvider _provider = ApiProvider();


Future<ProductList> getDatumList() async {
  final response = await _provider.get(_apiconstants.getProducts);
  return ProductList.fromJson(response);
}










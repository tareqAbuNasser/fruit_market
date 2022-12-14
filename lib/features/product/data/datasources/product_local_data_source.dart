import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/entities/exceptions.dart';
import '../models/product_dtos.dart';
import 'product_hive_manager.dart';

abstract class ProductLocalDataSource {
  List<ProductDTO> getProducts({String? parentId, int? limit});

  void cacheProducts(List<ProductDTO> products);

  void clear();

  void updateFavoriteProduct(ProductDTO product);
}

@LazySingleton(as: ProductLocalDataSource)
class ProductLocalDataSourceImpl extends ProductLocalDataSource {
  final ProductHiveManager _hiveManager;

  ProductLocalDataSourceImpl(this._hiveManager);

  @override
  void cacheProducts(List<ProductDTO> products) {
    printInfo(info: 'function : cacheProducts');
    Map<dynamic, ProductDTO> productsAsMap = {};
    for (var p in products) {
      productsAsMap[p.id] = p;
    }
    _hiveManager.productBox!.putAll(productsAsMap);
  }

  @override
  List<ProductDTO> getProducts({String? parentId, int? limit}) {
    printInfo(info: 'function : getProducts');
    try {
      return _hiveManager.productBox!.values
          .where((element) => element.parentId == parentId)
          .toList();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  void clear() {
    printInfo(info: 'function : clear');
    try {
      _hiveManager.productBox!.clear();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  void updateFavoriteProduct(ProductDTO product) {
    printInfo(info: 'function : updateFavoriteProduct');
    _hiveManager.productBox!.put(product.id, product);
  }
}

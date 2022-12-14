import 'package:dartz/dartz.dart';
import 'package:fruit_market/core/entities/value_objects.dart';
import 'package:fruit_market/features/favourite/domain/entities/favourite_item.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/entities/failures.dart';
import '../../../../injection.dart';
import '../../../auth/domain/usecases/get_signed_in_user.dart';
import '../../../favourite/domain/usecases/add_favourite_item.dart';
import '../../../favourite/domain/usecases/delete_favourite_item.dart';
import '../entities/product.dart';
import '../repositories/i_product_repository.dart';

@LazySingleton()
class UpdateFavouriteProduct {
  final AddFavouriteItem _addFavouriteItem;
  final DeleteFavouriteItem _deleteFavouriteItem;
  final IProductRepository _productRepository;
  final GetSignedInUser _signedInUser;

  UpdateFavouriteProduct(this._addFavouriteItem, this._deleteFavouriteItem,
      this._productRepository, this._signedInUser);

  Future<Either<Failure, Unit>> call(Product product) async {
    if (product.isLike) {
      product = product.copyWith(
          likes: product.likes
            ..removeWhere((element) =>
                element ==
                _signedInUser()
                    .fold((l) => "", (user) => user.uniqueId.getOrCrash())));
    } else {
      product = product.copyWith(
          likes: product.likes
            ..add(_signedInUser()
                .fold((l) => "", (user) => user.uniqueId.getOrCrash())));
    }

    FavouriteItem _favouriteItem = FavouriteItem.fromProduct(product);
    Either<Failure, Unit> failureOrUnit =
        await _productRepository.updateFavoriteProduct(product);
    if (failureOrUnit.isRight()) {
      if (product.isLike) {
        failureOrUnit = await _addFavouriteItem(_favouriteItem);
      } else {
        failureOrUnit = await _deleteFavouriteItem(_favouriteItem);
      }
    }
    return failureOrUnit;
  }
}

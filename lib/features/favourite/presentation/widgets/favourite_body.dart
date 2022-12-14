import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/critical_failure_display_widget.dart';
import '../cubit/favourite_watcher/favourite_watcher_cubit.dart';
import '../widgets/error_favourite_product.dart';
import '../widgets/favourite_product_card.dart';
import '../widgets/favourite_product_empty.dart';

class FavouriteBody extends StatelessWidget {
  const FavouriteBody ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouriteWatcherCubit, FavouriteWatcherState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => Container(),
          actionInProgress: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          watchSuccess: (state) {
            return state.favouriteItems.isEmpty
                ? const FavouriteProductEmpty()
                : ListView.separated(
              itemBuilder: (context, index) {
                final product = state.favouriteItems[index];
                if (product.failureOption.isSome()) {
                  return ErrorFavouriteProductCard(product);
                } else {
                  return FavouriteProductCard(product, index);
                }
              },
              separatorBuilder:
                  (BuildContext context, int index) {
                return const Divider(
                  color: Color(0xFFD1D1D1),
                  thickness: 1,
                );
              },
              itemCount: state.favouriteItems.length,
            );
          },
          watchFailure: (state) {
            return CriticalFailureDisplay(
              state.failure,
            );
          },
        );
      },
    );
  }
}

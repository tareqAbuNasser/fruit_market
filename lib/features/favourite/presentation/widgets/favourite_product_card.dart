import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fruit_market/core/widgets/custom_text_field.dart';

import '../../../../core/services/size_config.dart';
import '../../../../core/widgets/custom_images.dart';
import '../../../../core/widgets/custom_rating_bar.dart';
import '../../../cart/presentation/widgets/add_cart_item_button.dart';
import '../../domain/entities/favourite_item.dart';
import '../cubit/favourite_actor/favourite_actor_cubit.dart';

class FavouriteProductCard extends StatefulWidget {
  final FavouriteItem _item;
  final int index;

  const FavouriteProductCard(
    this._item,
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  State<FavouriteProductCard> createState() => _FavouriteProductCardState();
}

class _FavouriteProductCardState extends State<FavouriteProductCard> {
  int _productNo = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: CustomNetworkImage(
              imageUrl: widget._item.imageURL.getOrCrash(),
              width: SizeConfig.defaultSize! * 12,
              height: SizeConfig.defaultSize! * 12,
              imageKey: widget._item.id.getOrCrash(),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: widget._item.name.getOrCrash(),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    // const Spacer(),
                    CustomText(
                      text: "${widget._item.price.getOrCrash()} Per/kg",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ],
                ),
                const CustomText(
                  text: "Pick up from organic farms",
                  color: Color(0xffb2b2b2),
                  fontSize: 14,
                ),
                CustomRatingBarWithoutEditing(
                  rating: widget._item.rate.getOrCrash(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FloatingActionButton(
                        onPressed: () {
                          if (_productNo > 1) {
                            setState(() {
                              _productNo--;
                            });
                          }
                        },
                        heroTag: 'weight-',
                        mini: true,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.remove,
                          color: Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomText(
                        text: "$_productNo",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _productNo++;
                          });
                        },
                        heroTag: 'weight+',
                        mini: true,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12))),
                    const Spacer(),
                    AddCartItemButton(
                      onPressed: () {
                        context
                            .read<FavouriteActorCubit>()
                            .deleteFavoriteItem(widget._item, widget.index);
                      },
                      cartItem: widget._item.toCartItem(_productNo),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

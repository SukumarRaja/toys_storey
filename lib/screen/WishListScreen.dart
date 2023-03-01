import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toystorey/component/WishListComponent.dart';
import 'package:toystorey/component/WishListEmptyComponent.dart';
import 'package:toystorey/component/NotSignInComponent.dart';
import 'package:toystorey/main.dart';
import 'package:toystorey/models/WishListResponse.dart';
import 'package:toystorey/screen/ProductDetail/ProductDetailScreen3.dart';
import 'package:toystorey/utils/app_Widget.dart';
import 'package:toystorey/utils/constants.dart';
import 'package:toystorey/utils/shared_pref.dart';
import 'package:nb_utils/nb_utils.dart';
import '../app_localizations.dart';
import '../utils/AppBarWidget.dart';
import 'ProductDetail/ProductDetailScreen1.dart';
import 'ProductDetail/ProductDetailScreen2.dart';
import 'SearchScreen.dart';

class WishListScreen extends StatefulWidget {
  static String tag = '/WishListScreen';

  @override
  WishListScreenState createState() => WishListScreenState();
}

class WishListScreenState extends State<WishListScreen> {
  List<WishListResponse> mWishListModel = [];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    if (!await isGuestUser() && await isLoggedIn()) {
      wishListStore.getWishlistItem();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    Widget mWishList = Observer(builder: (_) {
      return AlignedGridView.count(
        scrollDirection: Axis.vertical,
        itemCount: wishListStore.wishList.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 16, right: 10, top: 16),
        crossAxisCount: 2,

        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                bool val;
                if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 1) {
                  val = await ProductDetailScreen1(mProId: wishListStore.wishList[index].proId).launch(context);
                } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 2) {
                  val = await ProductDetailScreen2(mProId: wishListStore.wishList[index].proId).launch(context);
                } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 3) {
                  val = await ProductDetailScreen3(mProId: wishListStore.wishList[index].proId).launch(context);
                } else {
                  val = await ProductDetailScreen1(mProId: wishListStore.wishList[index].proId).launch(context);
                }
                if (val) wishListStore.getWishlistItem();
              },
              child: WishListComponent(
                mWishListModel: wishListStore.wishList[index],
                onClick: () {
                  wishListStore.getWishlistItem();
                },
              ));
        },
      );
    });

    return Scaffold(
      appBar: mTop(
        context,
        appLocalization.translate('lbl_wish_list'),
        actions: [
          IconButton(
              icon: Icon(Icons.search_sharp, color: white),
              onPressed: () {
                SearchScreen().launch(context);
              })
        ],
      ) as PreferredSizeWidget?,
      body: Observer(builder: (context) {
        return BodyCornerWidget(
          child: Stack(
            children: [
              !getBoolAsync(IS_LOGGED_IN)
                  ? WishListNotSignInComponent(isWishlist: true).visible(!appStore.isLoading)
                  : wishListStore.wishList.isNotEmpty
                      ? Stack(
                          children: <Widget>[
                            mWishList.visible(wishListStore.wishList.isNotEmpty),
                            mProgress().center().visible(appStore.isLoading && wishListStore.wishList.isEmpty),
                          ],
                        )
                      : WishListEmptyComponent().visible(!appStore.isLoading),
              mProgress().center().visible(appStore.isLoading && wishListStore.wishList.isEmpty)
            ],
          ),
        );
      }),
    );
  }
}

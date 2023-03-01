import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:toystorey/component/OrderListComponent.dart';
import 'package:toystorey/main.dart';
import 'package:toystorey/models/OrderModel.dart';
import 'package:toystorey/network/rest_apis.dart';
import 'package:toystorey/utils/AppBarWidget.dart';
import 'package:toystorey/screen/OrderDetailScreen.dart';
import 'package:toystorey/utils/app_Widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../component/OrderListEmptyComponent.dart';
import '../app_localizations.dart';

class OrderList extends StatefulWidget {
  static String tag = '/OrderList';

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<OrderResponse> mOrderModel = [];
  String mErrorMsg = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future fetchOrderData() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });

    await getOrders().then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      Iterable mOrderDetails = res;
      mOrderModel = mOrderDetails.map((model) => OrderResponse.fromJson(model)).toList();
      if (mOrderModel.isEmpty) {
        mErrorMsg = '';
      }
      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      mOrderModel.clear();
      mErrorMsg = error.toString();
    });
  }

  init() async {
    fetchOrderData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    Widget mBody = orderListWidget(context, mOrderModel, (i) async {
      bool? isChanged = await OrderDetailScreen(mOrderModel: mOrderModel[i]).launch(context);
      if (isChanged != null) {
        appStore.setLoading(true);
        init();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mTop(context, appLocalization.translate('lbl_orders'), showBack: true) as PreferredSizeWidget?,
      body: Observer(
        builder: (context) => BodyCornerWidget(
          child: Stack(
            children: [
              mOrderModel.isNotEmpty ? mBody : OrderListEmptyComponent().visible(!appStore.isLoading && mErrorMsg.isEmpty),
              mProgress().center().visible(appStore.isLoading),
              Text(mErrorMsg, style: primaryTextStyle(), textAlign: TextAlign.center).center().visible(!appStore.isLoading && mErrorMsg.isNotEmpty),
            ],
          ),
        ),
      ),
    );
  }
}

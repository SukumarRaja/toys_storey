import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../app_localizations.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/constants.dart';
import '../../utils/images.dart';
import '../DashBoardScreen.dart';
import '../ProductDetail/ProductDetailScreen1.dart';
import 'HalloweenWalkThroughScreen.dart';

class HalloweenSplashScreen extends StatefulWidget {
  static String tag = '/HalloweenSplashScreen';

  @override
  HalloweenSplashScreenState createState() => HalloweenSplashScreenState();
}

class HalloweenSplashScreenState extends State<HalloweenSplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(primaryColor!, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.dark);
    await Future.delayed(Duration(seconds: 2));

    String productId = await getProductIdFromNative();
    print(productId);

    if (productId.isNotEmpty) {
      ProductDetailScreen1(mProId: productId.toInt()).launch(context);
    } else {
      checkFirstSeen();
    }
  }

  Future checkFirstSeen() async {
    bool _seen = (getBoolAsync('seen'));
    if (_seen) {
      DashBoardScreen().launch(context, isNewTask: true);
    } else {
      await setValue('seen', true);
      HalloweenWalkThroughScreen().launch(context, isNewTask: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = context.width();
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(ic_halloween_splash, width: width, height: context.height(), fit: BoxFit.fill),
            Column(
              children: [
                Text(
                  appLocalization.translate('lbl_halloween')!,
                  style: primaryTextStyle(
                    color: white,
                    size: 44,
                    letterSpacing: 2,
                    fontFamily: GoogleFonts.bangers().fontFamily,
                  ),
                ),
                Text(
                  AppName,
                  style: primaryTextStyle(
                    color: mHalloweenYellow,
                    size: 44,
                    letterSpacing: 2,
                    fontFamily: GoogleFonts.bangers().fontFamily,
                  ),
                ),
              ],
            ).paddingTop(50),
          ],
        ).center(),
      ),
    );
  }
}

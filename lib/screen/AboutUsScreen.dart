import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toystorey/main.dart';
import 'package:toystorey/utils/admob_utils.dart';
import 'package:toystorey/utils/app_Widget.dart';
import 'package:toystorey/utils/common.dart';
import 'package:toystorey/utils/constants.dart';
import 'package:toystorey/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app_localizations.dart';
import '../utils/AppBarWidget.dart';

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  PackageInfo? package;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    package = await PackageInfo.fromPlatform();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          mTop(context, appLocalization.translate('lbl_about'), showBack: true)
              as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Container(
                    width: 120,
                    height: 120,
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationRoundedWithShadow(10),
                    child: Image.asset(app_logo)),
                16.height,
                FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        return Column(
                          children: [
                            Text('${snap.data!.appName.validate()}',
                                style: boldTextStyle(
                                    color: primaryColor, size: 20)),
                            8.height,
                            // Text('V ${snap.data!.version.validate()}',
                            //     style: boldTextStyle(
                            //         color: primaryColor, size: 20)),
                          ],
                        );
                      }
                      return SizedBox();
                    }),
                8.height
              ],
            ).center(),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: enableAds == true ? 220 : 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: context.width(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(appLocalization.translate('llb_follow_us')!,
                      style: boldTextStyle()),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          redirectUrl(
                              'https://wa.me/918072085685');
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 16),
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_WhatsUp, height: 35, width: 35),
                        ),
                      ),
                      InkWell(
                        onTap: () => redirectUrl("https://www.instagram.com/toy_storeis/"),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_Inst, height: 35, width: 35),
                        ),
                      ),
                      // InkWell(
                      //   // onTap: () => redirectUrl(getStringAsync(TWITTER)),
                      //   child: Container(
                      //     padding: EdgeInsets.all(10),
                      //     child: Image.asset(ic_Twitter, height: 35, width: 35),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () => redirectUrl("https://www.facebook.com/Toy-Storey-107475691167727/"),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_Fb, height: 35, width: 35),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            redirectUrl('tel:8072085685'),
                        child: Container(
                          margin: EdgeInsets.only(right: 16),
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_CallRing,
                              height: 35, width: 35, color: primaryColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // FutureBuilder<PackageInfo>(
            //     future: PackageInfo.fromPlatform(),
            //     builder: (_, snap) {
            //       if (snap.hasData) {
            //         return Text('V ${snap.data!.version.validate()}',
            //             style: secondaryTextStyle());
            //       }
            //       return SizedBox();
            //     }),
            25.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Copyrights@ 2023",
                  style: boldTextStyle(
                      color: Theme.of(context).textTheme.displaySmall!.color,
                      size: 14),
                ),
                SizedBox(width: 15),
                Image.asset(
                  "images/toystorey/logo.webp",
                  width: MediaQuery.of(context).size.width * 0.3,
                )
              ],
            ),

            2.height,
            Container(
              height: 60,
              child: AdWidget(
                ad: BannerAd(
                  adUnitId: getBannerAdUnitId()!,
                  size: AdSize.banner,
                  request: AdRequest(),
                  listener: BannerAdListener(),
                )..load(),
              ),
            ).visible(enableAds == true)
          ],
        ),
      ),
    );
  }
}

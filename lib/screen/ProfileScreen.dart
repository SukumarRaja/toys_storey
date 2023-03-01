import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:toystorey/app_localizations.dart';
import 'package:toystorey/component/ThemeSelectionDialog.dart';
import 'package:toystorey/main.dart';
import 'package:toystorey/models/LanguageModel.dart';
import 'package:toystorey/screen/AboutUsScreen.dart';
import 'package:toystorey/screen/TeraWalletScreen.dart';
import 'package:toystorey/utils/AppBarWidget.dart';
import 'package:toystorey/screen/BlogListScreen.dart';
import 'package:toystorey/screen/ChangePasswordScreen.dart';
import 'package:toystorey/screen/ChooseDashboardPageVariant.dart';
import 'package:toystorey/screen/ChooseDemo.dart';
import 'package:toystorey/screen/DashBoardScreen.dart';
import 'package:toystorey/screen/EditProfileScreen.dart';
import 'package:toystorey/screen/OrderListScreen.dart';
import 'package:toystorey/screen/SignInScreen.dart';
import 'package:toystorey/utils/app_Widget.dart';
import 'package:toystorey/utils/common.dart';
import 'package:toystorey/utils/constants.dart';
import 'package:toystorey/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ChooseProductDetailVariant.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String mProfileImage = '';
  String userName = '';
  String userEmail = '';

  bool isChange = false;
  bool mIsLoggedIn = false;
  bool mIsGuest = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    mIsLoggedIn = getBoolAsync(IS_LOGGED_IN);
    mIsGuest = getBoolAsync(IS_GUEST_USER);
    userName = mIsLoggedIn ? '${getStringAsync(FIRST_NAME) + ' ' + getStringAsync(LAST_NAME)}' : '';
    userEmail = mIsLoggedIn ? getStringAsync(USER_EMAIL) : '';
    mProfileImage = getStringAsync(PROFILE_IMAGE);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    Widget mSideMenu(var text, var icon, Function onTap) {
      return SettingItemWidget(
        title: text,
        leading: Icon(icon, color: Theme.of(context).textTheme.subtitle2!.color),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          onTap.call();
        },
        titleTextStyle: secondaryTextStyle(size: 16),
      );
    }

    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: mTop(context, appLocalization!.translate('title_account')) as PreferredSizeWidget?,
        body: BodyCornerWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mProfileImage.isNotEmpty
                        ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(mProfileImage.validate()), radius: 35)
                        : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: Image.asset(User_Profile).image, radius: 35),
                    8.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          10.height,
                          Text(userName, style: boldTextStyle()).paddingOnly(top: 2).visible(mIsLoggedIn),
                          Text(userEmail, style: boldTextStyle(color: Theme.of(context).textTheme.subtitle1!.color)).paddingOnly(top: 2).visible(mIsLoggedIn),
                        ],
                      ).paddingOnly(left: 4, right: 4, bottom: 8),
                    )
                  ],
                ).paddingOnly(left: 4).paddingOnly(left: 8, right: 8).visible(mIsLoggedIn).onTap(() async {
                  bool? isLoad = await EditProfileScreen().launch(context);
                  if (isLoad != null) {
                    setState(() {
                      mProfileImage = getStringAsync(PROFILE_IMAGE);
                      userName = mIsLoggedIn ? '${getStringAsync(FIRST_NAME) + ' ' + getStringAsync(LAST_NAME)}' : '';
                      userEmail = mIsLoggedIn ? getStringAsync(USER_EMAIL) : '';
                    });
                  } else {
                    setState(() {
                      mProfileImage = getStringAsync(PROFILE_IMAGE);
                    });
                  }
                }),
                Divider(height: 4, thickness: 2, color: context.dividerColor).paddingOnly(top: 16, bottom: 8).visible(mIsLoggedIn),
                mSideMenu(appLocalization.translate('lbl_guest_user'), Feather.user, () async {
                  await setValue(FIRST_NAME, "Guest");
                  await setValue(LAST_NAME, "");
                  await setValue(USER_EMAIL, "Guest@gmail.com");
                  await setValue(USERNAME, "Guest");
                  await setValue(USER_DISPLAY_NAME, "Guest");
                  await setValue(IS_LOGGED_IN, true);
                  await setValue(IS_GUEST_USER, true);
                  await setValue(BILLING, "");
                  await setValue(SHIPPING, "");
                  DashBoardScreen().launch(context, isNewTask: true);
                }).visible(!mIsLoggedIn),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(!mIsLoggedIn),
                mSideMenu(appLocalization.translate('lbl_orders'), SimpleLineIcons.social_dropbox, () {
                  OrderList().launch(context);
                }).visible(mIsLoggedIn && !getBoolAsync(IS_GUEST_USER)),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(mIsLoggedIn && !getBoolAsync(IS_SOCIAL_LOGIN) && !getBoolAsync(IS_GUEST_USER)),
                mSideMenu(appLocalization.translate('lbl_change_pwd'), MaterialCommunityIcons.lock_outline, () {
                  ChangePasswordScreen().launch(context);
                }).visible(mIsLoggedIn && !getBoolAsync(IS_SOCIAL_LOGIN) && !getBoolAsync(IS_GUEST_USER)),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(mIsLoggedIn && !getBoolAsync(IS_GUEST_USER)),
                mSideMenu(appLocalization.translate('lbl_blog'), FontAwesome.list_alt, () {
                  BlogListScreen().launch(context);
                }).visible(enableBlog == true && mIsLoggedIn),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(enableTeraWallet == true),
                mSideMenu(appLocalization.translate('lbl_wallet')!, MaterialCommunityIcons.wallet_outline, () {
                  TeraWalletScreen().launch(context);
                }).visible(enableTeraWallet == true && mIsLoggedIn && mIsGuest == false),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(enableBlog == true),
                mSideMenu(appLocalization.translate('lbl_about'), MaterialCommunityIcons.information_outline, () {
                  AboutUsScreen().launch(context);
                }),
                // Divider(height: 0).paddingOnly(left: 16, right: 16),
                // mSideMenu(appLocalization.translate('choose_dashboard_page_variant'), MaterialCommunityIcons.view_dashboard_outline, () {
                //   ChooseDashboardPageVariant().launch(context);
                // }).visible(enableDashboardVariant == true),
                // Divider(height: 0).paddingOnly(left: 16, right: 16).visible(enableDashboardVariant == true),
                // mSideMenu(appLocalization.translate('choose_product_detail_page_variant'), Icons.mobile_friendly, () {
                //   ChooseProductDetailVariant().launch(context);
                // }).visible(enableDashboardVariant == true),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(enableDashboardVariant == true),
                mSideMenu(appLocalization.translate('lbl_terms_conditions'), Icons.assignment_outlined, () {
                  redirectUrl(getStringAsync(TERMS_AND_CONDITIONS).isEmptyOrNull ? TERMS_CONDITION_URL : getStringAsync(TERMS_AND_CONDITIONS));
                }),
                Divider(height: 0).paddingOnly(left: 16, right: 16),
                mSideMenu(appLocalization.translate('llb_privacy_policy'), Icons.privacy_tip_outlined, () {
                  redirectUrl(getStringAsync(PRIVACY_POLICY).isEmptyOrNull ? PRIVACY_POLICY_URL : getStringAsync(PRIVACY_POLICY));
                }),
                Divider(height: 0).paddingOnly(left: 16, right: 16),
                SettingItemWidget(
                  titleTextStyle: secondaryTextStyle(size: 16),
                  title: appLocalization.translate('lbl_select_theme')!,
                  leading: Icon(MaterialCommunityIcons.theme_light_dark, color: Theme.of(context).textTheme.subtitle2!.color),
                  onTap: () {
                    setState(() {
                      showInDialog(
                        context,
                        builder: (_) => ThemeSelectionDialog(),
                        contentPadding: EdgeInsets.zero,
                        shape: dialogShape(),
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        title: Text(appLocalization.translate('lbl_select_theme')!, style: boldTextStyle(size: 20)),
                      );
                    });
                  },
                ),
                Divider(height: 0).paddingOnly(left: 16, right: 16),
                SettingItemWidget(
                  titleTextStyle: secondaryTextStyle(size: 16),
                  title: appLocalization.translate('lbl_select_language')!,
                  leading: Icon(Ionicons.language_sharp, color: Theme.of(context).textTheme.subtitle2!.color),
                  trailing: DropdownButton(
                    isDense: true,
                    items: languages.map((e) => DropdownMenuItem<Language>(child: Text(e.name, style: primaryTextStyle(size: 14)), value: e)).toList(),
                    dropdownColor: appStore.isDarkModeOn ? white : Theme.of(context).scaffoldBackgroundColor,
                    value: language,
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (Language? v) async {
                      hideKeyboard(context);
                      appStore.setLanguage(v!.languageCode);
                    },
                  ).expand(),
                ),
                Divider(height: 0).paddingOnly(left: 16, right: 16),
                SettingItemWidget(
                  titleTextStyle: secondaryTextStyle(size: 16),
                  title: '${appStore.isNotificationOn ? appLocalization.translate('disable') : appLocalization.translate('enable')} ${appLocalization.translate('push_notification')}',
                  leading: Icon(appStore.isNotificationOn ? Feather.bell : Feather.bell_off, color: Theme.of(context).textTheme.subtitle2!.color),
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeColor: primaryColor,
                      value: appStore.isNotificationOn,
                      onChanged: (v) {
                        appStore.setNotification(v);
                      },
                    ).withHeight(10),
                  ),
                  onTap: () {
                    appStore.setNotification(!getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));
                  },
                ),
                Divider(height: 0).paddingOnly(left: 16, right: 16),
                mSideMenu(appLocalization.translate('btn_sign_out'), Feather.log_out, () async {
                  await logout(context);
                }).visible(mIsLoggedIn),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(mIsLoggedIn),
                mSideMenu(appLocalization.translate('delete_account'), Icons.delete_outline, () async {
                  await deleteAccount(context);
                }).visible(mIsLoggedIn && !getBoolAsync(IS_GUEST_USER)),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(mIsLoggedIn),
                mSideMenu(appLocalization.translate('lbl_sign_in'), MaterialCommunityIcons.login, () {
                  SignInScreen().launch(context);
                }).visible(!mIsLoggedIn),
                Divider(height: 0).paddingOnly(left: 16, right: 16).visible(!mIsLoggedIn && enableMultiDemo == true),
                mSideMenu(appLocalization.translate('lbl_multiple_demo'), Icons.check_circle_outline_outlined, () {
                  ChooseDemo().launch(context);
                }).visible(enableMultiDemo == true),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

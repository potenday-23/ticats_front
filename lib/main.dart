import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:ticats/app/config/app_binding.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/config/routes/routes.dart';

void main() async {
  // Ensure that the WidgetsBinding has been initialized
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize Locale
  await initializeDateFormatting();
  Intl.defaultLocale = 'ko_KR';

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize Kakao SDK
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!);

  // Initialize Flutter Native Splash and freeze the splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return GetMaterialApp(
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'),
          ],
          locale: const Locale('ko', 'KR'),
          theme: ThemeData(
            fontFamily: 'SUIT',
            useMaterial3: true,
            colorSchemeSeed: AppColor.primaryNormal,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              toolbarHeight: 56.w,
            ),
            scaffoldBackgroundColor: AppColor.grayF9,
          ),
          builder: (context, child) {
            child = Toast(navigatorKey: navigatorKey, child: child!);

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child,
            );
          },
          initialBinding: AppBinding(),
          initialRoute: RoutePath.login,
          navigatorKey: navigatorKey,
          getPages: Routes.routes,
        );
      },
    );
  }
}

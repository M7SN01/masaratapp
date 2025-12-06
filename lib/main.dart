import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masaratapp/App/Bindings/visit_map_binding.dart';
// import '../Views/Login/Login_view2.dart';

// import 'App/Controllers/user_privileges_controller.dart';
import 'App/Bindings/act_kshf_binding.dart';
import 'App/Bindings/cus_kshf_binding.dart';
import 'App/Bindings/invoice_binding.dart';
import 'App/Bindings/login_binding.dart';
import 'App/Bindings/sanadat_binding.dart';
import 'App/Locale/locale.dart';
import 'App/Locale/locale_controller.dart';

import 'App/Views/Act_Kshf/act_kshf.dart';
import 'App/Views/CustomerKshf/cus_kshf.dart';
import 'App/Views/Home/home.dart';
import 'App/Views/Invoice/invoice.dart';
import 'App/Views/Login/Login_view.dart';
import 'App/Views/Maps/map_view.dart';
import 'App/Views/Sanadat/sanadat.dart';
import 'App/Views/Splash_Screen/splash_view.dart';

/*
error 
ctrl+shift+p  => type =>  Flutter: Select Device


*/
void main() async {
  // await Future.delayed(const Duration(milliseconds: 10));
  FlutterNativeSplash.remove();

  WidgetsFlutterBinding.ensureInitialized();

  //screen orientations => restricts the app to only work in portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const PosApp());
}

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  //green     #58be45
  @override
  Widget build(BuildContext context) {
    Get.put(LocaleController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      locale: Locale('ar'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      translations: AppLocale(),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.cairo().fontFamily,
        // scaffoldBackgroundColor: const Color(0xFFf5f7f9),
        // textTheme: GoogleFonts.cairoTextTheme(), // ✅ correct way to effect any RichText style
        /*
        textTheme: GoogleFonts.cairoTextTheme().copyWith(
          bodyLarge: GoogleFonts.cairoTextTheme().bodyLarge?.copyWith(
                fontFamily: GoogleFonts.cairo().fontFamily,
              ),
          // repeat for other text styles as needed
        ),
        */
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreen(),
        ),
        GetPage(
          name: '/Login',
          page: () => const Login(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/Home',
          page: () => const Home(),
          // binding: LoginBinding(),  // binding with Login binding
        ),
        GetPage(
          name: '/Sanadat',
          page: () => Sanadat(),
          binding: SanadatBinding(),
        ),
        GetPage(
          name: '/Invoice',
          page: () => Invoice(),
          binding: InvoiceBinding(),
        ),
        GetPage(
          name: '/CustomerKshf',
          page: () => const CustomerKshf(),
          binding: CustomerKshfBinding(),
        ),
        GetPage(
          name: '/ActKshf',
          page: () => const ActKshf(),
          binding: ActKshfBinding(),
        ),
        GetPage(
          name: '/VisitMap',
          page: () => const VisitMap(),
          binding: VisitMapBinding(),
        ),
      ],

      /*
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (context, animation, animationtwo) {
            switch (settings.name) {
              default:
                return const Login();
            }
          },
          transitionsBuilder: (context, animation, anmitiontwo, child) {
            // var begin = 0.0;
            // var end = 1.0;
            // var tween = Tween(begin: begin, end: end);
            // var curvesanmition = CurvedAnimation(parent: animation, curve: Curves.linear);

            return child;
            // Align(
            //     alignment: Alignment.center,
            //     child:
            //         //   SizeTransition(
            //         //     sizeFactor: animation,
            //         //     child: child,
            //         //   ),
            //         // );
            //         RotationTransition(
            //       turns: tween.animate(curvesanmition),
            //       child: child,
            //     ));
          },
        );
      },

      */
    );
  }
}

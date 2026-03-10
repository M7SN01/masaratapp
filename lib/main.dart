import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/views/manager/Binding/cus_aging_binding.dart';
import 'app/views/manager/binding/sls_cntr_binding.dart';
import 'app/views/manager/views/customers_aging/cus_aging.dart';
import 'app/views/manager/views/sls_by_sls_cntr/sls_by_sls_cntr.dart';
import 'app/views/home/cus_Bal/customers_balance.dart';
import 'app/bindings/visit_map_binding.dart';
import 'app/bindings/act_kshf_binding.dart';
import 'app/bindings/cus_balance_binding.dart';
import 'app/bindings/cus_kshf_binding.dart';
import 'app/bindings/invoice_binding.dart';
import 'app/bindings/login_binding.dart';
import 'app/bindings/sanadat_binding.dart';
import 'app/views/manager/Binding/sls_by_sls_man_binding.dart';
import 'app/views/manager/views/sls_by_sls_man/sls_by_sls_man.dart';
import 'app/views/manager/views/mngr_home.dart';
import 'locale/locale.dart';
import 'locale/locale_controller.dart';
import 'app/views/home/act_kshf/act_kshf.dart';
import 'app/views/home/customer_kshf/cus_kshf.dart';
import 'app/views/home/home.dart';
import 'app/views/home/invoice/invoice.dart';
import 'app/views/home/login/login_view.dart';
import 'app/views/home/maps/map_view.dart';
import 'app/views/home/maps/visit_plan_view.dart';
import 'app/views/home/sanadat/sanadat.dart';
import 'app/views/home/splash_screen/splash_view.dart';

/*
error 
ctrl+shift+p  => type =>  Flutter: Select Device


*/
void main() async {
  await Future.delayed(const Duration(milliseconds: 10));
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
      // home: const SplashScreen(),
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
          name: '/CustomerBalance',
          page: () => const CustomerBalance(),
          binding: CustomerBalanceBinding(),
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
        GetPage(
          name: '/VisitPlan',
          page: () => const VisitPlan(),
          binding: VisitPlanBinding(),
        ),
        GetPage(
          name: '/ManagerHome',
          page: () => const ManagerHome(),
          // binding: VisitPlanBinding(),
        ),
        GetPage(
          name: '/ManagerHome/SlsByslsCntr',
          page: () => const SlsByslsCntr(),
          binding: SlsBySlsCntrBinding(),
        ),
        GetPage(
          name: '/ManagerHome/SlsByslsMan',
          page: () => const SlsByslsMan(),
          binding: SlsBySlsManBinding(),
        ),
        GetPage(
          name: '/ManagerHome/CustomersAging',
          page: () => const CustomersAging(),
          binding: CusAgingBinding(),
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

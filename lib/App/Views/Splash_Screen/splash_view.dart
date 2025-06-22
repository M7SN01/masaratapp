import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LogoWidget extends StatelessWidget {
  final bool withShimmer;
  const LogoWidget({this.withShimmer = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 100,
          width: 100,
          child: Image.asset('assets/images/logo.ico'),
        ),
        if (withShimmer)
          Shimmer.fromColors(
            period: const Duration(milliseconds: 1000), //was 2 sceondes
            baseColor: const Color(0xffe9a43a),
            highlightColor: Colors.grey[300]!,
            child: RichText(
              text: const TextSpan(
                text: 'Golden ',
                style: TextStyle(
                  color: Color(0xffe9a43a),
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Soft',
                    style: TextStyle(
                      color: Color(0xff261499),
                      fontSize: 20,
                      //   fontWeight: FontWeight.bold,
                    ),
                  ),
                  //  TextSpan(text: ' world!'),
                ],
              ),
            ),
          )
        else
          RichText(
            text: const TextSpan(
              text: 'Golden ',
              style: TextStyle(color: Color(0xffe9a43a), fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: 'Soft',
                  style: TextStyle(color: Color(0xff261499), fontSize: 20),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenRouteFunction(
      splash: const Hero(
        tag: "Logo",
        child: LogoWidget(), // Use the shared widget
      ),

      splashIconSize: 140,
      animationDuration: const Duration(seconds: 1),

      duration: 3000, //until open next page
      // backgroundColor: PrimaryColor,
      screenRouteFunction: () async {
        return "Login";
      },

      splashTransition: SplashTransition.fadeTransition,
      //decoratedBoxTransition => blinking bakground
      // pageTransitionType: PageTransitionType.fade,
    );
  }
}

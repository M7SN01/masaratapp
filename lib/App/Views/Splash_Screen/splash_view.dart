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
          // margin: const EdgeInsets.only(bottom: 5),
          height: withShimmer ? 200 : 140,
          width: withShimmer ? 200 : 140,
          child: Image.asset('assets/images/mrway.png'), //was mrway.png
        ),
        if (withShimmer)
          Shimmer.fromColors(
            period: const Duration(milliseconds: 1000), //was 2 sceondes
            baseColor: Colors.redAccent,
            highlightColor: Colors.grey[300]!,
            child: RichText(
              text: TextSpan(
                text: 'Mr',
                style: TextStyle(
                  // color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'W',
                    style: TextStyle(
                      // color: Colors.redAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'ay',
                    style: TextStyle(
                      // color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //  TextSpan(text: ' world!'),
                ],
              ),
            ),
          )
        // else
        //   RichText(
        //     text: TextSpan(
        //       text: 'Mr',
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: 30,
        //         fontWeight: FontWeight.bold,
        //       ),
        //       children: <TextSpan>[
        //         TextSpan(
        //           text: 'W',
        //           style: TextStyle(
        //             color: Colors.redAccent,
        //             fontSize: 30,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         TextSpan(
        //           text: 'ay',
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 30,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         //  TextSpan(text: ' world!'),
        //       ],
        //     ),
        //   ),
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

      splashIconSize: 240,
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

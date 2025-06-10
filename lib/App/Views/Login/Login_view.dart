//import 'package:http/http.dart' as http;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/login_controller.dart';
import '../Splash_Screen/splash_view.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

@override
class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          //Background
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFfc4ba4),
                Color(0xFF3dd9fe),
              ],
              // tileMode: TileMode.mirror,
            ),
          ),
          //Card glass
          child: Stack(
            children: [
              //Cards in back{================================}
              //top center
              Positioned(
                top: (controller.screenHeight / 2) - controller.loginCardHight / 2,
                left: (controller.screenWidth / 2) - 50,
                child: const AnimatedCard(
                  x: 0,
                  beginTop: -90,
                  endTop: -20,
                  scond: 5,
                  cHight: 60,
                  cWidth: 60,
                ),
              ),
              //top right
              Positioned(
                top: controller.screenHeight / 2 - controller.loginCardHight / 2 + 10,
                left: (controller.screenWidth / 2) + (controller.loginCardWidth / 2) - 35,
                child: const AnimatedCard(
                  x: 0,
                  beginTop: -80,
                  endTop: 0,
                  scond: 6,
                  cHight: 80,
                  cWidth: 80,
                ),
              ),
              //bottom center
              Positioned(
                bottom: controller.screenHeight / 2 - controller.loginCardHight / 2 - 30,
                left: controller.screenWidth / 2 - 70,
                child: const AnimatedCard(
                  x: 0,
                  beginTop: 0,
                  endTop: 120,
                  scond: 4,
                  cHight: 60,
                  cWidth: 60,
                ),
              ),

              //Body Card{================================}
              Center(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 50,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 8.0,
                            sigmaY: 8.0,
                          ),
                          child: Container(
                            width: controller.loginCardWidth,
                            height: controller.loginCardHight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(
                                    0.2,
                                  ),
                                  Colors.white.withOpacity(
                                    0.2,
                                  ),
                                  Colors.white.withOpacity(
                                    0.2,
                                  ),
                                  Colors.white.withOpacity(
                                    0.2,
                                  ),
                                ],
                                stops: const [
                                  0.1,
                                  0.3,
                                  0.8,
                                  1,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(
                                  0.3,
                                ),
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                //User Name
                                Container(
                                  margin: const EdgeInsets.all(
                                    20,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    15,
                                    0,
                                    0,
                                  ),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(
                                          0.2,
                                        ),
                                        Colors.white.withOpacity(
                                          0.1,
                                        ),
                                        Colors.white.withOpacity(
                                          0.05,
                                        ),
                                        Colors.transparent,
                                      ],
                                      stops: const [
                                        0.1,
                                        0.3,
                                        0.8,
                                        1,
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(
                                        0.5,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: TextFormField(
                                    enabled: !controller.isLogining, // controller.isEnableField,
                                    controller: controller.userID,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(
                                        0xFF59709b,
                                      ),
                                    ),
                                    cursorColor: Colors.black,
                                    cursorWidth: 2,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "User Id",
                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                //Password
                                Container(
                                  margin: const EdgeInsets.all(
                                    20,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    0,
                                    0,
                                  ),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(
                                          0.2,
                                        ),
                                        Colors.white.withOpacity(
                                          0.1,
                                        ),
                                        Colors.white.withOpacity(
                                          0.05,
                                        ),
                                        Colors.transparent,
                                      ],
                                      stops: const [
                                        0.1,
                                        0.3,
                                        0.8,
                                        1,
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(
                                        0.5,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: TextFormField(
                                    enabled: !controller.isLogining, //  controller.isEnableField,
                                    controller: controller.password,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(
                                        0xFF59709b,
                                      ),
                                    ),
                                    cursorColor: Colors.black,
                                    cursorWidth: 2,
                                    keyboardType: TextInputType.number,
                                    obscureText: controller.obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      border: const OutlineInputBorder(
                                        //to remove under line *****
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.changePasswordVisibility();
                                        },
                                        icon: Icon(
                                          controller.obscurePassword ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.grey[150],
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // rememberme
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        value: controller.keepmelogin,
                                        onChanged: (value) {
                                          if (!controller.isLogining /*controller.isEnableField*/) {
                                            controller.keepmelogin = !controller.keepmelogin;
                                            controller.update();
                                          }
                                        },
                                      ),
                                      const Text(
                                        "Remember Me",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(
                                            0xFF59709b,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                controller.isLogining
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    :
                                    //Login Button
                                    ElevatedButton(
                                        onPressed: () async {
                                          //  FocusManager.instance.primaryFocus?.unfocus();
                                          await controller.login();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(
                                            100,
                                            40,
                                          ),
                                          backgroundColor: const Color(
                                            0xFFffffff,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ), // Set the rounded corner radius
                                          ),
                                        ),
                                        child: const Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Color(
                                              0xFF59709b,
                                            ),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                const SizedBox(
                                  height: 20,
                                ),

                                //Forget && Dont have account
                                const Row(
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      " ? Forget password ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(
                                          188,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      " Click Here",
                                      style: TextStyle(
                                        color: Color(
                                          0xFF59709b,
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const Row(
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      " ? Don't have an account",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(
                                          188,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      " Sign up",
                                      style: TextStyle(
                                        color: Color(
                                          0xFF59709b,
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Avatar
                    Positioned(
                      width: 140,
                      height: 140,
                      //parent continer size is 350 so 350/2 give center -half avatar size  (350/2)-70  will make it center
                      left: controller.loginCardWidth / 2 - 70,
                      child: Container(
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(),
                          color: Color.fromARGB(
                            0,
                            231,
                            10,
                            10,
                          ),
                        ),
                        child: const Hero(
                          tag: "Logo",
                          child: LogoWidget(
                            withShimmer: false,
                          ), // Use the shared widget
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Cards in front{================================}
              //Center lift
              Positioned(
                top: controller.screenHeight / 2 - controller.loginCardHight / 3,
                left: controller.screenWidth / 2 - controller.loginCardWidth / 2 - 85,
                child: const AnimatedCard(
                  x: 0,
                  beginTop: 0,
                  endTop: 150,
                  scond: 6,
                  cHight: 100,
                  cWidth: 100,
                ),
              ),
              //bottom right
              Positioned(
                bottom: controller.screenHeight / 2 - controller.loginCardHight / 3,
                right: controller.screenWidth / 2 - controller.loginCardWidth / 2 - 40,
                child: const AnimatedCard(
                  x: 0,
                  beginTop: 0,
                  endTop: 40,
                  scond: 3,
                  cHight: 70,
                  cWidth: 70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final double x;
  final double beginTop;
  final int scond;
  final double endTop;
  final double cWidth;
  final double cHight;
  const AnimatedCard({
    super.key,
    required this.x,
    required this.beginTop,
    required this.endTop,
    required this.scond,
    required this.cWidth,
    required this.cHight,
  });

  @override
  State<AnimatedCard> createState() => AnimatedCardState();
}

class AnimatedCardState extends State<AnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<EdgeInsets> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.scond),
      vsync: this,
    )..repeat(reverse: true);
    _animation = EdgeInsetsTween(
      begin: EdgeInsets.only(
        top: widget.beginTop,
      ),
      end: EdgeInsets.only(top: widget.endTop),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            widget.x,
            _animation.value.vertical,
          ),
          child: ClipRRect(
            // borderRadius:BorderRadius.all(Radius.circular(widget.cHight)),

            borderRadius: BorderRadius.circular(
              12,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8.0,
                sigmaY: 8.0,
              ),
              child: Container(
                height: widget.cHight,
                width: widget.cWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(
                        0.2,
                      ),
                      Colors.white.withOpacity(
                        0.2,
                      ),
                      Colors.white.withOpacity(
                        0.2,
                      ),
                      Colors.white.withOpacity(
                        0.2,
                      ),
                    ],
                    // stops: [0.1, 0.3, 0.8, 1],
                    //  begin: Alignment.bottomLeft,
                    // end: Alignment.topRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

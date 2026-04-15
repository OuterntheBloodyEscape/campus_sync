
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:package:campus_sync/LibraryManagement.dart';
import 'package:campus_sync/Welcome.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    Size ScreenSize = MediaQuery.of(context).size;
    double h = ScreenSize.height;
    double w = ScreenSize.width;
    bool time = false;
    return Scaffold(
      backgroundColor: CupertinoColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
                alignment: Alignment(0, 0),
                child:
                    SvgPicture.asset(
                          'assets/Images/graduation-cap.svg',
                          colorFilter: ColorFilter.mode(
                            Color.fromRGBO(63, 194, 212, 1.0),

                            BlendMode.srcIn,
                          ),
                          width: w / 3,
                          fit: BoxFit.contain,
                        )
                        .animate()
                        .scale(
                          duration: 1000.ms,
                          curve: Curves.elasticOut,
                          begin: Offset(0, 0),
                          end: Offset(2, 2),
                          //end: Offset(1.4, 1.4),
                        )
                        .boxShadow(
                          begin: BoxShadow(
                            color: Colors.blue.withOpacity(0),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                          end: BoxShadow(
                            color: Colors.blue.withOpacity(0),
                            blurRadius: 50,
                            spreadRadius: 100,
                          ),
                        ),
              )
              .animate()
              .shimmer(duration: 1000.ms)
              .then()
              .tint(color: CupertinoColors.black, duration: 500.ms),

          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                      'assets/Images/CampusSync.png',
                      fit: BoxFit.contain,
                      width: w / 2,
                    )
                    .animate(delay: 2000.ms)
                    .scale(
                      duration: 2000.ms,
                      curve: Curves.elasticOut,
                      begin: Offset(0, 0),
                      end: Offset(1, 1),
                    )
                    .boxShadow(
                      begin: BoxShadow(
                        color: Colors.blue.withOpacity(0),
                        blurRadius: 0,
                        spreadRadius: 0,
                      ),
                      end: BoxShadow(
                        color: Colors.blue.withOpacity(.8),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                      duration: 1500.ms,
                    ),

                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                        SvgPicture.asset(
                              'assets/Images/calendar-lines-pen.svg',
                              colorFilter: ColorFilter.mode(
                                Color.fromRGBO(63, 194, 212, 1.0),
                                BlendMode.srcIn,
                              ),
                            )
                            .animate(delay: 2500.ms)
                            .scale(
                              duration: 2000.ms,
                              curve: Curves.elasticOut,
                              begin: Offset(0, 0),
                              end: Offset(1.2, 1.2),
                            )
                            .boxShadow(
                              begin: BoxShadow(
                                color: Colors.blue.withOpacity(0),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                              end: BoxShadow(
                                color: Colors.blue.withOpacity(0),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              duration: 1500.ms,
                            )
                            .fadeIn(duration: 1000.ms),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                        SvgPicture.asset(
                              'assets/Images/document.svg',
                              colorFilter: ColorFilter.mode(
                                Color.fromRGBO(63, 194, 212, 1.0),
                                BlendMode.srcIn,
                              ),
                            )
                            .animate(delay: 2500.ms)
                            .scale(
                              duration: 2000.ms,
                              curve: Curves.elasticOut,
                              begin: Offset(0, 0),
                              end: Offset(1.2, 1.2),
                            )
                            .boxShadow(
                              begin: BoxShadow(
                                color: Colors.blue.withOpacity(0),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                              end: BoxShadow(
                                color: Colors.blue.withOpacity(0),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              duration: 1500.ms,
                            )
                            .fadeIn(duration: 2000.ms),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                        SvgPicture.asset(
                              'assets/Images/restaurant.svg',
                              colorFilter: ColorFilter.mode(
                                Color.fromRGBO(63, 194, 212, 1.0),
                                BlendMode.srcIn,
                              ),
                            )
                            .animate(delay: 2500.ms)
                            .scale(
                              duration: 4000.ms,
                              curve: Curves.elasticOut,
                              begin: Offset(0, 0),
                              end: Offset(1.2, 1.2),
                            )
                            .boxShadow(
                              begin: BoxShadow(
                                color: Colors.blue.withOpacity(0),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                              end: BoxShadow(
                                color: Colors.blue.withOpacity(0),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              duration: 1500.ms,
                            )
                            .fadeIn(duration: 2000.ms),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),

                    child:
                        SvgPicture.asset(
                              'assets/Images/users-class.svg',
                              colorFilter: ColorFilter.mode(
                                Color.fromRGBO(63, 194, 212, 1.0),
                                BlendMode.srcIn,
                              ),
                            )
                            .animate(delay: 2500.ms)
                            .scale(
                              duration: 2000.ms,
                              curve: Curves.elasticOut,
                              begin: Offset(0, 0),
                              end: Offset(1.2, 1.2),
                            )
                            .boxShadow(
                              begin: BoxShadow(
                                color: Colors.blue.withOpacity(0),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                              end: BoxShadow(
                                color: Colors.blue.withOpacity(0.0),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              duration: 1500.ms,
                            )
                            .fadeIn(duration: 2000.ms)
                            .callback(
                              callback: (_) {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => WelcomeScreen(),
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                    transitionDuration: 800.ms,
                                  ),
                                );
                              },
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

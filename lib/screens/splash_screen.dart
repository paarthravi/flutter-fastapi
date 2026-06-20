import 'dart:async';
import 'package:flutter/material.dart';
import 'chat_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLogo = false;
  bool showText = false;
  bool showTitle = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 900),
          () {
        setState(() {
          showTitle = true;
        });
      },
    );

    Future.delayed(
      const Duration(milliseconds: 400),
          () {
        setState(() {
          showLogo = true;
        });
      },
    );

    Future.delayed(
      const Duration(milliseconds: 1200),
          () {
        setState(() {
          showText = true;
        });
      },
    );

    Timer(
      const Duration(seconds: 4),
          () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                const ChatListScreen(),
                transitionsBuilder:
                    (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration:
                const Duration(milliseconds: 600),
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xfff8fbff),
              Color(0xffd6ebff),
              Color(0xffc2e2ff),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff1496d4).withOpacity(0.25),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),

                    AnimatedScale(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutBack,
                      scale: showLogo ? 1 : 0.6,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 900),
                        opacity: showLogo ? 1 : 0,
                        child: Image.asset(
                          'assets/images/gogenericlogo.png',
                          width: 195,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: showText ? 1 : 0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 900),
                    offset: showTitle ? Offset.zero : const Offset(0, 0.4),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Digital Solutions for All Your\nHealthcare Needs",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              height: 1.6,
                              color: Color(0xff4b5f7f),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xff1496d4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
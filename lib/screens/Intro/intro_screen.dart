import 'package:flutter/material.dart';
import 'package:law_help/screens/login/login_method.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                onLastPage = value == 2;
              });
            },
            controller: _controller,
            children: [
              buildIntroductionPage(),
              buildFeaturePage(
                  "For hostelers",
                  [
                    "Mark your attendance",
                    "Get your daily mess menu",
                    "Ease of complaint registration",
                  ],
                  'assets/images/target.png'),
              buildFeaturePage(
                  "For Hostel Admins",
                  [
                    "The Ultimate Admin Toolkit",
                    "Effortless Complaint Management",
                    "Ease of Mess and Attendace Records"
                  ],
                  'assets/images/admin.png'),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                  ),
                  GestureDetector(
                    child: Text(
                      onLastPage ? "Done" : "Next",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 165, 165)),
                    ),
                    onTap: () {
                      if (onLastPage) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIntroductionPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 200),
        Card(
          color: const Color(0xFFFFFFFF),
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent),
                ),
                const Text(
                  "to",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 70, 127)),
                ),
                const Text(
                  "hostelHub",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/students0.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Empowering hostelers",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 62, 113)),
                ),
                const SizedBox(height: 16),
                const Text(
                  "The one stop for all hosteler needs",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 0, 62, 113)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFeaturePage(
      String title, List<String> features, String imageAsset) {
    return Container(
      color: Colors.grey[600],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: const Color(0xFFFFFFFF),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    imageAsset,
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 63, 66, 98)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

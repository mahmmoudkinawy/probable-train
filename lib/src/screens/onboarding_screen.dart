import 'package:flutter/cupertino.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      PageViewModel(
        title: "Welcome to Pets Care",
        body: "We provide top-quality care for your furry friends.",
        decoration: const PageDecoration(
          titleTextStyle:
              TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 20.0),
        ),
        image: Column(
          children: [
            Expanded(
              child: Image.asset(
                'assets/dd.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      PageViewModel(
        title: "Expert Care",
        body: "Our veterinarians are experienced and caring.",
        image: Image.asset(
          'assets/doggy6.webp',
          fit: BoxFit.cover,
        ),
        decoration: const PageDecoration(
          titleTextStyle:
              TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 20.0),
        ),
      ),
      PageViewModel(
        title: "Convenient Appointments",
        body: "Schedule appointments easily with our app.",
        image: Image.asset(
          'assets/00.png',
          fit: BoxFit.cover,
        ),
        decoration: const PageDecoration(
          titleTextStyle:
              TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 20.0),
        ),
      ),
    ];

    return IntroductionScreen(
      bodyPadding: const EdgeInsets.only(top: 70),
      pages: pages,
      onDone: () {
        Navigator.pushNamed(context, '/login');
      },
      showNextButton: true,
      next: const Text("Next",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          )),
      showBackButton: false,
      done: const Text("Done",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          )),
    );
  }
}

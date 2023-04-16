import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey.shade200,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(5),
            ),
            ListTile(
              leading: Icon(
                Icons.star_border_rounded,
                color: Colors.blue.shade900,
              ),
              title: Text(
                "Generate Privacy Policy for Pets Care",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "Creating a Privacy Policy for your app or website can be time-consuming and expensive. Our service can provide you with a fully customized Privacy Policy that is compliant with relevant laws and regulations, specifically tailored to the needs of Pets Care. Protect your users' privacy and ensure compliance today."),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(5),
            ),
            ListTile(
              leading: Icon(
                Icons.star_border_rounded,
                color: Colors.blue.shade900,
              ),
              title: Text(
                "Generate Privacy Policy for Pets Care Clinic",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "Our Pets Care Clinic is committed to protecting the privacy and security of our users. This Privacy Policy explains how we collect, use, and share information about you when you use our app. By using our app, you consent to our collection and use of your information as described in this policy. We reserve the right to modify this policy at any time, so please review it frequently."),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(5),
            ),
            ListTile(
              leading: Icon(
                Icons.star_border_rounded,
                color: Colors.blue.shade900,
              ),
              title: Text(
                "Generate Privacy Policy for mobile & desktop apps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "For any app you are developing you will need a Privacy Policy to launch it. Termify can help you generate the best for the case and get your app ready for review."),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
            ),
            ListTile(
              leading: Icon(
                Icons.star_border_rounded,
                color: Colors.blue.shade900,
              ),
              title: Text(
                "Generate Privacy Policy for Pets Care",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "Many platforms like pets care apps are requiring users that are submitting their official apps to submit a Privacy Policy even if you are not collecting any data from your users. Generate your Privacy Policy and get your unique link to submit to those platforms."),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
            ),
            ListTile(
              leading: Icon(
                Icons.star_border_rounded,
                color: Colors.blue.shade900,
              ),
              title: Text(
                "Generate Privacy Policy for third party services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "Some third party services require you to have a Privacy Policy. The use of ads, analytics or third party payments usually ask you for a Privacy Policy. Google Ads might be the one asking for your Privacy Policy, or Amazon, and many more."),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
            ),
            ListTile(
              leading: Icon(
                Icons.star_border_rounded,
                color: Colors.blue.shade900,
              ),
              title: Text(
                "Download Your Privacy Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "If you want to host your customized Privacy Policy on your site, you can just download the Privacy Policy and give them the use you want."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

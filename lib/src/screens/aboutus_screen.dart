import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
          'About Us',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(5),
            ),
            ListTile(
              leading: Icon(
                Icons.star_border_rounded,
                color: Colors.blue.shade900,
              ),
              title: Text(
                "Decisions you need to make",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "Creating an online presence for your veterinary clinic is crucial in today's digital age. By developing a website, you can provide valuable information to pet owners and streamline appointment scheduling. Here are some key steps to get started with building a website for your pets care clinic."),
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
                "Pets Care Website Design And UI",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "The appearance of your website is crucial to keeping your customers engaged. This is especially true for a clinic like Pets Care, where customers want to feel confident that they are dealing with a professional and trustworthy establishment. Make sure your website is easy to navigate and visually appealing, with a clean and simple layout that makes it easy for customers to find the information they need. Keep in mind that customers have a short attention span, so it's important to ensure that your website loads quickly and is optimized for mobile devices. By providing a positive user experience, you can increase the likelihood of customer engagement and loyalty."),
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
                "Payment Gateways",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "The more payment gateways available on your store, the bigger your sales will be. Convenience translates to sales. If you have dozens of supported payment modes, your customers will think of it as a big plus. Don’t get this wrong, not all stores need tons of payment gateways. Just get the basics covered: PayPal, Stripe, Authorize.net, Venmo, WorldPay, and credit card processors."),
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
                "Level of customization",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "Most newbies will resort to choosing a sleek template and settle with that. There’s nothing wrong about this as long as it serves its purpose on your store. Still, it won’t hurt to look on ecommerce website examples for added inspiration."),
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
                "Building from scratch vs. using open-source solutions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "One thing that sparked the rise of online stores is the emergence of many open-source ecommerce solutions. With this, you can access a website builder, integrations, payment gateways, and more in just one platform. However, a store owner would have to pay for monthly costs, not to mention the cost of necessary add-ons."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

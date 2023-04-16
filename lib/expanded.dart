import 'package:flutter/material.dart';

class Expandedd extends StatelessWidget {
  const Expandedd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset('assets/download.jpg'),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.asset('assets/download.jpg'),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset('assets/download.jpg'),
              ),
            ],
          ),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: YourWidget1(),
            //     ),
            //     Expanded(
            //       flex: 2,
            //       child: YourWidget2(),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: YourWidget3(),
            //     ),
            //   ],
            // )
        ),


    );
  }
}

YourWidget1() {
}

YourWidget2() {
}

YourWidget3() {
}



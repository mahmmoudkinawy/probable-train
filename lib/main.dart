import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});

  runApp(const App());
}

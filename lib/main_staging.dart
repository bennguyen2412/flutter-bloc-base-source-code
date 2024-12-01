import 'package:flutter/material.dart';

import 'app_flavor.dart';
import 'bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfigurations.current = FlavorConfigurations.production;
  initializeFlutterApp();
}

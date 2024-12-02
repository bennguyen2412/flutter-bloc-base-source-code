import 'package:flutter/material.dart';

import 'flavor_configurations.dart';
import 'app/application_initializer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfigurations.current = FlavorConfigurations.development;
  initializeFlutterApp();
}

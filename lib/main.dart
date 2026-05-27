import 'package:flutter/material.dart';

import 'ui/ui.dart';

void main() {
  runApp(const PitStopApp());
}

class PitStopApp extends StatelessWidget {
  const PitStopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'pit-stop',
      theme: PitStopTheme.light(),
      home: const WorkshopOverviewScreen(),
    );
  }
}

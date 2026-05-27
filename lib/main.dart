import 'package:flutter/material.dart';

void main() {
  runApp(const PitStopApp());
}

class PitStopApp extends StatelessWidget {
  const PitStopApp({super.key});

  @override
  Widget build(BuildContext context) {
    const warmOil = Color(0xffc78a2c);
    const diagnosticTeal = Color(0xff009688);
    const shopInk = Color(0xff202124);
    const shopFloor = Color(0xfff4f0e8);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'pit-stop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: diagnosticTeal,
          primary: diagnosticTeal,
          secondary: warmOil,
          surface: shopFloor,
        ),
        scaffoldBackgroundColor: shopFloor,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: shopInk,
            fontWeight: FontWeight.w800,
          ),
          titleMedium: TextStyle(color: shopInk, fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(color: shopInk),
        ),
        useMaterial3: true,
      ),
      home: const WorkshopStatusScreen(),
    );
  }
}

class WorkshopStatusScreen extends StatelessWidget {
  const WorkshopStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pit-stop'), centerTitle: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '부산 사상구 정비소',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '첫 손님을 받을 준비 중입니다.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              const _StatusTile(
                icon: Icons.directions_car,
                label: '입고 대기',
                value: '1대',
              ),
              const SizedBox(height: 12),
              const _StatusTile(
                icon: Icons.build,
                label: '정비 절차',
                value: '코어 연결 준비',
              ),
              const SizedBox(height: 12),
              const _StatusTile(
                icon: Icons.receipt_long,
                label: '5분 사이클',
                value: '다음 PR',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('start-intake-button'),
                  onPressed: null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('접수 시작 준비 중'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffded8cc)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(value),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'workshop_tokens.dart';

class WorkshopOverviewScreen extends StatelessWidget {
  const WorkshopOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('pit-stop'),
        centerTitle: false,
        backgroundColor: PitStopColors.shopWarm50,
        foregroundColor: PitStopColors.diagCool900,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PitStopSpacing.lg),
          children: const [
            _WorkshopHeader(),
            SizedBox(height: PitStopSpacing.lg),
            _WorkshopWorldPanel(),
            SizedBox(height: PitStopSpacing.lg),
            _DailySummaryPanel(),
            SizedBox(height: PitStopSpacing.lg),
            _CustomerQueuePanel(),
            SizedBox(height: PitStopSpacing.lg),
            _WorkBaysPanel(),
            SizedBox(height: PitStopSpacing.xl),
            _StartIntakeButton(),
          ],
        ),
      ),
    );
  }
}

class _WorkshopHeader extends StatelessWidget {
  const _WorkshopHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('부산 사상구 정비소', style: PitStopText.header),
        SizedBox(height: PitStopSpacing.sm),
        Text('손님 큐와 작업대 상태를 먼저 훑습니다.', style: PitStopText.body),
      ],
    );
  }
}

class _WorkshopWorldPanel extends StatefulWidget {
  const _WorkshopWorldPanel();

  @override
  State<_WorkshopWorldPanel> createState() => _WorkshopWorldPanelState();
}

class _WorkshopWorldPanelState extends State<_WorkshopWorldPanel> {
  _WorldSpot _selected = _WorldSpot.customer;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: '블록 정비소 월드',
      shopShare: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.35,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: PitStopColors.diagCool50,
                border: Border.all(color: PitStopColors.shopWarm700, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LayoutBuilder(
                  builder: (context, _) {
                    return Stack(
                      key: const Key('workshop-world-panel'),
                      children: [
                        const Positioned.fill(
                          child: CustomPaint(painter: _WorkshopFloorPainter()),
                        ),
                        _PositionedWorldHotspot(
                          left: 0.10,
                          top: 0.16,
                          child: _WorldHotspot(
                            key: const Key('world-hotspot-desk'),
                            label: '접수대',
                            selected: _selected == _WorldSpot.desk,
                            onTap: () => _select(_WorldSpot.desk),
                            child: const _BlockReceptionDesk(),
                          ),
                        ),
                        _PositionedWorldHotspot(
                          left: 0.56,
                          top: 0.16,
                          child: _WorldHotspot(
                            key: const Key('world-hotspot-lift'),
                            label: '1번 리프트',
                            selected: _selected == _WorldSpot.lift,
                            onTap: () => _select(_WorldSpot.lift),
                            child: const _BlockLift(),
                          ),
                        ),
                        _PositionedWorldHotspot(
                          left: 0.46,
                          top: 0.48,
                          child: _WorldHotspot(
                            key: const Key('world-hotspot-car'),
                            label: '대기 차량',
                            selected: _selected == _WorldSpot.car,
                            onTap: () => _select(_WorldSpot.car),
                            child: const _BlockCar(),
                          ),
                        ),
                        _PositionedWorldHotspot(
                          left: 0.18,
                          top: 0.50,
                          child: _WorldHotspot(
                            key: const Key('world-hotspot-customer'),
                            label: '첫 손님',
                            selected: _selected == _WorldSpot.customer,
                            onTap: () => _select(_WorldSpot.customer),
                            child: const _BlockCustomerAvatar(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: PitStopSpacing.md),
          _WorldStatusStrip(spot: _selected),
        ],
      ),
    );
  }

  void _select(_WorldSpot spot) {
    setState(() {
      _selected = spot;
    });
  }
}

enum _WorldSpot { desk, lift, car, customer }

extension _WorldSpotCopy on _WorldSpot {
  String get title {
    return switch (this) {
      _WorldSpot.desk => '접수대 선택됨',
      _WorldSpot.lift => '1번 리프트 선택됨',
      _WorldSpot.car => '대기 차량 선택됨',
      _WorldSpot.customer => '첫 손님 선택됨',
    };
  }

  String get detail {
    return switch (this) {
      _WorldSpot.desk => '상담 기록과 결제는 아직 잠겨 있음',
      _WorldSpot.lift => '비어 있음, 진단 차량을 올릴 준비 완료',
      _WorldSpot.car => '차량 콘텐츠 연결 전, 기본 점검 대기',
      _WorldSpot.customer => '예산을 신경 쓰며 접수 순서를 기다림',
    };
  }
}

class _PositionedWorldHotspot extends StatelessWidget {
  const _PositionedWorldHotspot({
    required this.left,
    required this.top,
    required this.child,
  });

  final double left;
  final double top;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                left: constraints.maxWidth * left,
                top: constraints.maxHeight * top,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WorkshopFloorPainter extends CustomPainter {
  const _WorkshopFloorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final tileWidth = size.width / 4.5;
    final tileHeight = size.height / 5.2;
    final origin = Offset(size.width * 0.50, size.height * 0.04);
    final paint = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = PitStopColors.shopWarm700.withValues(alpha: 0.55);

    for (var row = 0; row < 5; row += 1) {
      for (var col = 0; col < 5; col += 1) {
        final center = Offset(
          origin.dx + (col - row) * tileWidth * 0.45,
          origin.dy + (col + row) * tileHeight * 0.45,
        );
        final path = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx + tileWidth * 0.45, center.dy + tileHeight * 0.22)
          ..lineTo(center.dx, center.dy + tileHeight * 0.44)
          ..lineTo(center.dx - tileWidth * 0.45, center.dy + tileHeight * 0.22)
          ..close();
        paint.color = (row + col).isEven
            ? PitStopColors.shopWarm50
            : PitStopColors.shopWarm300;
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
      }
    }

    final roadPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = PitStopColors.diagCool500.withValues(alpha: 0.18);
    final road = Path()
      ..moveTo(size.width * 0.12, size.height * 0.82)
      ..lineTo(size.width * 0.88, size.height * 0.82)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(road, roadPaint);
  }

  @override
  bool shouldRepaint(covariant _WorkshopFloorPainter oldDelegate) => false;
}

class _WorldHotspot extends StatelessWidget {
  const _WorldHotspot({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              padding: const EdgeInsets.all(PitStopSpacing.xs),
              decoration: BoxDecoration(
                color: selected
                    ? PitStopColors.warningAmber
                    : PitStopColors.paper.withValues(alpha: 0.92),
                border: Border.all(
                  color: selected
                      ? PitStopColors.diagCool900
                      : PitStopColors.shopWarm700,
                  width: selected ? 3 : 2,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: PitStopColors.diagCool900.withValues(alpha: 0.20),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: child,
            ),
            const SizedBox(height: PitStopSpacing.xs),
            DecoratedBox(
              decoration: BoxDecoration(
                color: PitStopColors.diagCool900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PitStopSpacing.sm,
                  vertical: PitStopSpacing.xs,
                ),
                child: Text(
                  label,
                  style: PitStopText.caption.copyWith(
                    color: PitStopColors.paper,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorldStatusStrip extends StatelessWidget {
  const _WorldStatusStrip({required this.spot});

  final _WorldSpot spot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PitStopColors.paper,
        border: Border.all(color: PitStopColors.shopWarm700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PitStopSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spot.title, style: PitStopText.sectionTitle),
            const SizedBox(height: PitStopSpacing.xs),
            Text(spot.detail, style: PitStopText.body),
          ],
        ),
      ),
    );
  }
}

class _BlockReceptionDesk extends StatelessWidget {
  const _BlockReceptionDesk();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 78,
      height: 58,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: _PixelBox(
              width: 72,
              height: 30,
              color: PitStopColors.shopWarm700,
            ),
          ),
          Positioned(
            top: 0,
            left: 12,
            child: _PixelBox(
              width: 42,
              height: 28,
              color: PitStopColors.diagCool500,
            ),
          ),
          Positioned(top: 8, right: 8, child: _PixelBox(width: 18, height: 18)),
        ],
      ),
    );
  }
}

class _BlockLift extends StatelessWidget {
  const _BlockLift();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 84,
      height: 64,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: _PixelBox(
              width: 80,
              height: 14,
              color: PitStopColors.diagCool500,
            ),
          ),
          Positioned(
            left: 8,
            bottom: 12,
            child: _PixelBox(
              width: 12,
              height: 46,
              color: PitStopColors.shopWarm700,
            ),
          ),
          Positioned(
            right: 8,
            bottom: 12,
            child: _PixelBox(
              width: 12,
              height: 46,
              color: PitStopColors.shopWarm700,
            ),
          ),
          Positioned(top: 12, child: _PixelBox(width: 62, height: 12)),
        ],
      ),
    );
  }
}

class _BlockCar extends StatelessWidget {
  const _BlockCar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 88,
      height: 52,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 8,
            child: _PixelBox(
              width: 80,
              height: 24,
              color: PitStopColors.successGreen,
            ),
          ),
          Positioned(
            top: 2,
            child: _PixelBox(
              width: 42,
              height: 22,
              color: PitStopColors.diagCool50,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 12,
            child: _PixelBox(
              width: 14,
              height: 14,
              color: PitStopColors.diagCool900,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 12,
            child: _PixelBox(
              width: 14,
              height: 14,
              color: PitStopColors.diagCool900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailySummaryPanel extends StatelessWidget {
  const _DailySummaryPanel();

  @override
  Widget build(BuildContext context) {
    return const _Panel(
      title: '일일 요약',
      shopShare: true,
      child: Row(
        children: [
          Expanded(
            child: _Metric(label: '대기', value: '1'),
          ),
          SizedBox(width: PitStopSpacing.sm),
          Expanded(
            child: _Metric(label: '작업대', value: '0/2'),
          ),
          SizedBox(width: PitStopSpacing.sm),
          Expanded(
            child: _Metric(label: '평판', value: '보통'),
          ),
        ],
      ),
    );
  }
}

class _CustomerQueuePanel extends StatelessWidget {
  const _CustomerQueuePanel();

  @override
  Widget build(BuildContext context) {
    return const _Panel(
      title: '손님 큐',
      child: Column(
        children: [
          _QueueRow(
            name: '첫 손님',
            vehicle: '차량 콘텐츠 대기',
            issue: '상담 화면 연결 전',
            mood: '기다림 03분',
            tag: '예산 민감',
          ),
          SizedBox(height: PitStopSpacing.md),
          _EmptyQueueRow(),
        ],
      ),
    );
  }
}

class _WorkBaysPanel extends StatelessWidget {
  const _WorkBaysPanel();

  @override
  Widget build(BuildContext context) {
    return const _Panel(
      title: '작업대 상태',
      child: Column(
        children: [
          _BayRow(name: '1번 리프트', state: '비어 있음', progress: 0),
          SizedBox(height: PitStopSpacing.md),
          _BayRow(name: '2번 리프트', state: '비어 있음', progress: 0),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.child,
    this.shopShare = false,
  });

  final String title;
  final Widget child;
  final bool shopShare;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: shopShare ? PitStopColors.shopWarm300 : PitStopColors.diagCool50,
        border: Border.all(color: PitStopColors.shopWarm700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PitStopSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: PitStopText.sectionTitle),
            const SizedBox(height: PitStopSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PitStopColors.paper,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PitStopSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: PitStopText.caption),
            const SizedBox(height: PitStopSpacing.xs),
            Text(value, style: PitStopText.mono),
          ],
        ),
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  const _QueueRow({
    required this.name,
    required this.vehicle,
    required this.issue,
    required this.mood,
    required this.tag,
  });

  final String name;
  final String vehicle;
  final String issue;
  final String mood;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PitStopColors.paper,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PitStopSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BlockCustomerAvatar(),
            const SizedBox(width: PitStopSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: PitStopText.sectionTitle),
                  const SizedBox(height: PitStopSpacing.xs),
                  Text(vehicle, style: PitStopText.caption),
                  const SizedBox(height: PitStopSpacing.xs),
                  Text(issue, style: PitStopText.body),
                  const SizedBox(height: PitStopSpacing.sm),
                  Wrap(
                    spacing: PitStopSpacing.sm,
                    runSpacing: PitStopSpacing.xs,
                    children: [
                      _StatusChip(label: mood),
                      _StatusChip(label: tag),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockCustomerAvatar extends StatelessWidget {
  const _BlockCustomerAvatar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      key: Key('customer-avatar-placeholder'),
      width: 64,
      height: 72,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(top: 0, child: _PixelBox(width: 36, height: 28)),
          Positioned(
            top: 8,
            left: 18,
            child: _PixelDot(color: PitStopColors.diagCool900),
          ),
          Positioned(
            top: 8,
            right: 18,
            child: _PixelDot(color: PitStopColors.diagCool900),
          ),
          Positioned(
            top: 28,
            child: _PixelBox(
              width: 48,
              height: 34,
              color: PitStopColors.diagCool500,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 12,
            child: _PixelBox(
              width: 16,
              height: 14,
              color: PitStopColors.shopWarm700,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 12,
            child: _PixelBox(
              width: 16,
              height: 14,
              color: PitStopColors.shopWarm700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PixelBox extends StatelessWidget {
  const _PixelBox({
    required this.width,
    required this.height,
    this.color = PitStopColors.shopWarm300,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: PitStopColors.shopWarm700, width: 2),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}

class _PixelDot extends StatelessWidget {
  const _PixelDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: const SizedBox(width: 6, height: 6),
    );
  }
}

class _EmptyQueueRow extends StatelessWidget {
  const _EmptyQueueRow();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: PitStopColors.paper,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: EdgeInsets.all(PitStopSpacing.md),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('다음 손님 슬롯 비어 있음', style: PitStopText.caption),
        ),
      ),
    );
  }
}

class _BayRow extends StatelessWidget {
  const _BayRow({
    required this.name,
    required this.state,
    required this.progress,
  });

  final String name;
  final String state;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(name, style: PitStopText.body)),
            Text(state, style: PitStopText.caption),
          ],
        ),
        const SizedBox(height: PitStopSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: PitStopColors.paper,
            color: PitStopColors.diagCool500,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PitStopColors.warningAmber,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PitStopSpacing.md,
          vertical: PitStopSpacing.sm,
        ),
        child: Text(label, style: PitStopText.mono),
      ),
    );
  }
}

class _StartIntakeButton extends StatelessWidget {
  const _StartIntakeButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        key: const Key('start-intake-button'),
        onPressed: null,
        child: const Text('상담 화면 준비 중'),
      ),
    );
  }
}

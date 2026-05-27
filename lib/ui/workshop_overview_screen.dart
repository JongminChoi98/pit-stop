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

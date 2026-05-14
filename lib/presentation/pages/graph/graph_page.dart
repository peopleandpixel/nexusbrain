import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/presentation/theme.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;

class GraphPage extends ConsumerStatefulWidget {
  const GraphPage({super.key});

  @override
  ConsumerState<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends ConsumerState<GraphPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TransformationController _transformController = TransformationController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagesAsync = ref.watch(pagesProvider);

    return Scaffold(
      body: SafeArea(
        child: pagesAsync.when(
          data: (pages) => _buildGraph(context, pages),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(child: Text('common.error'.tr())),
        ),
      ),
    );
  }

  Widget _buildGraph(BuildContext context, List<domain.MdBombPage> pages) {
    if (pages.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'graph.knowledgeGraph'.tr(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..shader = NexusBrainTheme.primaryGradient.createShader(const Rect.fromLTWH(0, 0, 200, 40)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'graph.pagesCount'.tr(namedArgs: {'count': pages.length.toString()})} · ${'graph.tagsCount'.tr(namedArgs: {'count': _countUniqueTags(pages).toString()})}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 18),
                      onPressed: () => _zoom(0.8),
                    ),
                    Container(width: 1, height: 20, color: const Color(0xFF2D2D44)),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      onPressed: () => _zoom(1.25),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: InteractiveViewer(
            transformationController: _transformController,
            minScale: 0.3,
            maxScale: 3.0,
            boundaryMargin: const EdgeInsets.all(200),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(2000, 2000),
                  painter: _GraphPainter(
                    pages: pages,
                    animationValue: _controller.value,
                  ),
                  child: child,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(gradient: NexusBrainTheme.glowGradient, borderRadius: BorderRadius.circular(30)),
            child: const Icon(Icons.account_tree_rounded, size: 50, color: Color(0xFF8B5CF6)),
          ),
          const SizedBox(height: 24),
          Text('graph.emptyTitle'.tr(), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('graph.emptySubtitle'.tr(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B))),
        ],
      ),
    );
  }

  void _zoom(double factor) {
    final matrix = _transformController.value.clone();
    matrix.scaleByDouble(factor, factor, factor, 1.0);
    _transformController.value = matrix;
  }

  int _countUniqueTags(List<domain.MdBombPage> pages) {
    return pages.expand((p) => p.tags).toSet().length;
  }
}

class _GraphPainter extends CustomPainter {
  final List<domain.MdBombPage> pages;
  final double animationValue;

  _GraphPainter({required this.pages, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final random = Random(42);
    final nodePositions = <String, Offset>{};
    final radius = min(size.width, size.height) * 0.35;

    for (int i = 0; i < pages.length; i++) {
      final angle = (2 * pi * i / pages.length) + (animationValue * 0.1);
      final r = radius * (0.6 + random.nextDouble() * 0.4);
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      nodePositions[pages[i].id] = Offset(x, y);
    }

    for (int i = 0; i < pages.length; i++) {
      for (int j = i + 1; j < pages.length; j++) {
        final sharedTags = pages[i].tags.toSet().intersection(pages[j].tags.toSet());
        if (sharedTags.isNotEmpty) {
          final p1 = nodePositions[pages[i].id]!;
          final p2 = nodePositions[pages[j].id]!;
          final strength = sharedTags.length / max(pages[i].tags.length, pages[j].tags.length);

          final linePaint = Paint()
            ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.1 + strength * 0.3)
            ..strokeWidth = 1 + strength * 2
            ..style = PaintingStyle.stroke;

          canvas.drawLine(p1, p2, linePaint);
        }
      }
    }

    for (final page in pages) {
      final pos = nodePositions[page.id]!;
      final double nodeRadius = 8 + min(page.tags.length * 2.0, 20.0);

      final glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(pos, nodeRadius + 8, glowPaint);

      final bgPaint = Paint()
        ..shader = NexusBrainTheme.primaryGradient.createShader(Rect.fromCircle(center: pos, radius: nodeRadius));
      canvas.drawCircle(pos, nodeRadius, bgPaint);

      final borderPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(pos, nodeRadius, borderPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: page.title.length > 20 ? '${page.title.substring(0, 20)}...' : page.title,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(pos.dx - textPainter.width / 2, pos.dy + nodeRadius + 6));
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
}

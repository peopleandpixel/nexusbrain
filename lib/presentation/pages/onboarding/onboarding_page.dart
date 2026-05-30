import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/presentation/state/onboarding_state.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      titleKey: 'onboarding.welcome',
      subtitleKey: 'onboarding.welcomeSubtitle',
      icon: Icons.psychology_rounded,
      color: Colors.blue,
    ),
    _OnboardingSlide(
      titleKey: 'onboarding.blocksTitle',
      subtitleKey: 'onboarding.blocksSubtitle',
      icon: Icons.view_headline_rounded,
      color: Colors.purple,
    ),
    _OnboardingSlide(
      titleKey: 'onboarding.linksTitle',
      subtitleKey: 'onboarding.linksSubtitle',
      icon: Icons.link_rounded,
      color: Colors.orange,
    ),
    _OnboardingSlide(
      titleKey: 'onboarding.graphTitle',
      subtitleKey: 'onboarding.graphSubtitle',
      icon: Icons.account_tree_rounded,
      color: Colors.green,
    ),
  ];

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  void _complete() {
    ref.read(onboardingStateProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _complete,
                child: Text('onboarding.skip'.tr()),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: slide.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slide.icon,
                            size: 100,
                            color: slide.color,
                          ),
                        ).animate(key: ValueKey('icon_$index'))
                            .scale(duration: 600.ms, curve: Curves.elasticOut)
                            .fadeIn(),
                        const SizedBox(height: 48),
                        Text(
                          slide.titleKey.tr(),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ).animate(key: ValueKey('title_$index'))
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.2),
                        const SizedBox(height: 16),
                        Text(
                          slide.subtitleKey.tr(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          textAlign: TextAlign.center,
                        ).animate(key: ValueKey('subtitle_$index'))
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.2),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? theme.primaryColor
                              : theme.primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        (_currentPage == _slides.length - 1
                                ? 'onboarding.getStarted'
                                : 'onboarding.next')
                            .tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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

class _OnboardingSlide {
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final Color color;

  _OnboardingSlide({
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.color,
  });
}

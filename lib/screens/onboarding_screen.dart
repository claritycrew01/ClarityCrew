import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final _pages = [
    _OnboardingPage(
      icon: Icons.auto_stories,
      title: 'Welcome to ClarityCrew',
      subtitle:
          'A calm, friendly place to learn\nat your own pace.',
      color: ClarityColors.primary,
    ),
    _OnboardingPage(
      icon: Icons.tune_outlined,
      title: 'Learn Your Way',
      subtitle:
          'Adjust text size, contrast, and focus mode\nto create your ideal learning space.',
      color: ClarityColors.secondary,
    ),
    _OnboardingPage(
      icon: Icons.auto_awesome_outlined,
      title: 'AI-Powered Help',
      subtitle:
          'ClarityBuddy is your personal AI tutor.\nAsk questions, get explanations, and more.',
      color: ClarityColors.accent,
    ),
    _OnboardingPage(
      icon: Icons.rocket_launch_outlined,
      title: 'Ready to Begin?',
      subtitle:
          'Pick a course, start a lesson, and\ndiscover how enjoyable learning can be.',
      color: ClarityColors.primary,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(page.icon,
                              size: 48, color: page.color),
                        ),
                        const SizedBox(height: 32),
                        Text(page.title,
                            style: ClarityTypography.displaySmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        Text(page.subtitle,
                            style: ClarityTypography.bodyLarge.copyWith(
                                color: ClarityColors.textSecondary),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? ClarityColors.primary
                              : ClarityColors.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: () => _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: const Text('Back'),
                        )
                      else
                        const SizedBox(width: 80),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            context.go('/auth');
                          }
                        },
                        child: Text(_currentPage < _pages.length - 1
                            ? 'Next'
                            : 'Get Started'),
                      ),
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

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

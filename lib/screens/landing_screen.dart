import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';
import '../utils/responsive.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _HeaderSection(),
              _HeroSection(),
              _FeaturesSection(),
              _CTASection(),
              _FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: ClarityColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_stories, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Text('ClarityCrew',
              style: ClarityTypography.titleLarge.copyWith(
                  color: ClarityColors.textPrimary)),
          const Spacer(),
          TextButton(
            onPressed: () => context.go('/auth'),
            child: const Text('Sign In'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.go('/auth'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 60 : 40,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: ClarityColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('For neurodivergent learners',
                style: TextStyle(
                    color: ClarityColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 24),
          Text(
            'Learning that adapts\nto you',
            textAlign: TextAlign.center,
            style: ClarityTypography.displayLarge.copyWith(
              fontSize: isDesktop ? 52 : 36,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'A calm, accessible platform built for ADHD, autism, dyslexia,\nand every beautiful mind that learns differently.',
            textAlign: TextAlign.center,
            style: ClarityTypography.bodyLarge.copyWith(
              color: ClarityColors.textSecondary,
              fontSize: isDesktop ? 18 : 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/auth'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            child: const Text('Start Learning Today'),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => context.go('/courses'),
            icon: const Icon(Icons.explore_outlined, size: 18),
            label: const Text('Browse Courses'),
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.psychology_outlined,
        'title': 'AI Learning Companion',
        'desc':
            'ClarityBuddy helps explain concepts, generates summaries, and adapts to your learning style.',
      },
      {
        'icon': Icons.accessibility_new_outlined,
        'title': 'Built for Accessibility',
        'desc':
            'Text size, contrast, focus mode, and reduced motion — all customizable for your comfort.',
      },
      {
        'icon': Icons.route_outlined,
        'title': 'Personalized Paths',
        'desc':
            'Track progress, get recommendations, and learn at your own pace with adaptive difficulty.',
      },
      {
        'icon': Icons.auto_stories_outlined,
        'title': 'Rich Content',
        'desc':
            'Interactive notes, videos, quizzes, and exercises from CBSE, ICSE, and more.',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      color: ClarityColors.surfaceAlt,
      child: Column(
        children: [
          Text('Everything you need to learn better',
              style: ClarityTypography.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: features.map((f) {
              return SizedBox(
                width: 260,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ClarityColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ClarityColors.cardShadow,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(f['icon'] as IconData,
                          size: 28, color: ClarityColors.primary),
                      const SizedBox(height: 12),
                      Text(f['title'] as String,
                          style: ClarityTypography.titleMedium),
                      const SizedBox(height: 6),
                      Text(f['desc'] as String,
                          style: ClarityTypography.bodySmall.copyWith(
                              color: ClarityColors.textSecondary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          Text('Ready to learn your way?',
              style: ClarityTypography.displayMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Join ClarityCrew and discover a calmer way to learn.',
              style: ClarityTypography.bodyLarge.copyWith(
                  color: ClarityColors.textSecondary),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/auth'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Create Free Account'),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: ClarityColors.surfaceAlt,
      child: Column(
        children: [
          const Icon(Icons.auto_stories, color: ClarityColors.primary, size: 24),
          const SizedBox(height: 8),
          Text('ClarityCrew',
              style: ClarityTypography.titleMedium.copyWith(
                  color: ClarityColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Learn at your pace',
              style: ClarityTypography.bodySmall.copyWith(
                  color: ClarityColors.textTertiary)),
          const SizedBox(height: 16),
          Text('© 2026 ClarityCrew. Built with care for every learner.',
              style: ClarityTypography.labelSmall.copyWith(
                  color: ClarityColors.textTertiary)),
        ],
      ),
    );
  }
}

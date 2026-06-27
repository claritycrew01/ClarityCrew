import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    context.read<AppState>().focusSupportService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusService = context.watch<AppState>().focusSupportService;
    final state = focusService.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Session')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: state.isFocused ? _pulseAnimation.value : 1.0,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.isFocused
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceVariant,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            state.isFocused ? Icons.center_focus_strong : Icons.timer,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.isFocused ? 'Focused' : 'Ready',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Streak: ${focusService.currentStreak} sessions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${focusService.totalMinutes} minutes',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  if (state.isFocused) {
                    focusService.endFocusSession();
                  } else {
                    focusService.startFocusSession();
                  }
                },
                icon: Icon(state.isFocused ? Icons.stop : Icons.play_arrow),
                label: Text(state.isFocused ? 'End Session' : 'Start Focus'),
              ),
              if (state.isFocused) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => focusService.breakFocus(),
                  child: const Text('Take a Break'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

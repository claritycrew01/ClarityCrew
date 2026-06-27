import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/content_item.dart';

class FlashcardsScreen extends StatefulWidget {
  final ContentItem lesson;

  const FlashcardsScreen({super.key, required this.lesson});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  bool _isFlipped = false;

  List<ContentItem> get _cards {
    if (widget.lesson.flashcards.isNotEmpty) return widget.lesson.flashcards;
    return [widget.lesson];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  void _next() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
      _animationController.reset();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Card ${_currentIndex + 1}/${_cards.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _cards.length,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GestureDetector(
                onTap: _flip,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final isFront = _animation.value < 0.5;
                    return Card(
                      elevation: 4,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_animation.value * 3.14159),
                        child: isFront
                            ? _buildCardFace(
                                card.title,
                                Icons.lightbulb,
                                isFront: true,
                              )
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..rotateY(3.14159),
                                child: _buildCardFace(
                                  card.description.isEmpty
                                      ? card.body
                                      : card.description,
                                  Icons.lightbulb,
                                  isFront: false,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tap the card to flip it',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _next,
              child: Text(
                _currentIndex < _cards.length - 1 ? 'Next' : 'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFace(String text, IconData icon, {required bool isFront}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

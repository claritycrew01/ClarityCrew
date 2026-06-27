import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class ClarityLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const ClarityLoadingIndicator({
    super.key,
    this.message,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor:
                  AlwaysStoppedAnimation<Color>(ClarityColors.primary),
            ),
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                message!,
                style: const TextStyle(
                  color: ClarityColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ClarityShimmerLoading extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;

  const ClarityShimmerLoading({
    super.key,
    this.itemCount = 3,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (i) => itemBuilder(i)),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ClarityColors.divider.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

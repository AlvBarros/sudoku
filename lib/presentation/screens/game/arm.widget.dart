import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catArmProvider = NotifierProvider<CatArmNotifier, Offset>(
  () => CatArmNotifier(),
);

class CatArmNotifier extends Notifier<Offset> {
  @override
  Offset build() {
    return Offset(0, 0);
  }

  void tap(Offset position) {
    state = position;
  }
}

class CatArmOverlay extends ConsumerStatefulWidget {
  final Widget child;
  const CatArmOverlay({super.key, required this.child});

  @override
  ConsumerState<CatArmOverlay> createState() => _CatArmOverlayState();
}

class _CatArmOverlayState extends ConsumerState<CatArmOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset? _lastOffset; // Store the last offset

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse(); // Reverse the animation
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final armPosition = ref.watch(catArmProvider);

    // Only run the animation if the new position is different from the last
    if (_lastOffset != armPosition) {
      _lastOffset = armPosition; // Update the last offset

      final isLightMode = Theme.of(context).brightness == Brightness.light;
      final screenWidth = MediaQuery.of(context).size.width;
      final comeFromTheRight = armPosition.dx > screenWidth / 2;

      final startingPoint = Offset(
        comeFromTheRight ? screenWidth + 300 : -300,
        armPosition.dy - 125,
      );
      final endingPoint = Offset(
        comeFromTheRight ? armPosition.dx : armPosition.dx - 150,
        armPosition.dy - 125,
      );
      final animationTween = Tween<Offset>(
        begin: startingPoint,
        end: endingPoint,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0.0);

      return Stack(
        children: [
          widget.child,
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            child: AnimatedBuilder(
              animation: animationTween,
              builder: (context, child) {
                return Transform.translate(
                  offset: animationTween.value, // Use the animated offset
                  child: Transform.rotate(
                    angle: !comeFromTheRight
                        ? 90 * 3.1416 / 180
                        : 270 * 3.1416 / 180,
                    child: Image.asset(
                      isLightMode
                          ? 'assets/images/arm-black.png'
                          : 'assets/images/arm-white.png',
                      width: 150,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return widget.child; // Return the child if no animation is needed
  }
}

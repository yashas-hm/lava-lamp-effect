import 'package:flutter/material.dart';
import 'package:lava_lamp_effect/src/lava.dart';
import 'package:lava_lamp_effect/src/lava_painter.dart';

/// [LavaLampEffect] is a widget that displays a customizable lava lamp effect 
/// animation.
///
/// This widget creates a fluid animation that resembles a lava lamp, with
/// blob-like shapes that move and merge in a visually appealing way.
///
/// The animation can be customized with different colors, sizes, number of
/// lava blobs, and animation speeds.
class LavaLampEffect extends StatefulWidget {
  /// Creates a lava lamp effect widget.
  ///
  /// The [size] parameter is required and determines the dimensions of the
  /// lava lamp effect.
  ///
  /// The [color] parameter is optional and defaults to the primary color of
  /// the current theme.
  ///
  /// The [lavaCount] parameter determines the number of lava blobs in the
  /// animation and defaults to 4.
  ///
  /// The [speed] parameter controls the speed of the animation and defaults to 1.
  /// Higher values result in faster movement.
  ///
  /// The [repeatDuration] parameter sets the duration of one complete animation
  /// cycle and defaults to 10 seconds.
  const LavaLampEffect({
    super.key,
    required this.size,
    this.color,
    this.lavaCount = 4,
    this.speed = 1,
    this.repeatDuration = const Duration(seconds: 10),
  });

  /// The size of the lava lamp effect.
  final Size size;

  /// The number of lava blobs in the animation.
  final int lavaCount;

  /// The speed of the animation. Higher values result in faster movement.
  final int speed;

  /// The duration of one complete animation cycle.
  final Duration repeatDuration;

  /// The color of the lava blobs. Defaults to the primary color of the current theme.
  final Color? color;

  @override
  State<LavaLampEffect> createState() => _LavaLampEffectState();
}

/// The state for the [LavaLampEffect] widget.
///
/// This state manages the animation controller and the lava model
/// that powers the lava lamp effect.
class _LavaLampEffectState extends State<LavaLampEffect>
    with SingleTickerProviderStateMixin {
  /// The animation controller that drives the lava lamp animation.
  late final AnimationController animCtr;

  /// The lava model that contains the logic for the lava lamp effect.
  late final Lava lava;

  @override
  void initState() {
    super.initState();
    // Initialize the lava model with the specified count and speed
    lava = Lava(widget.lavaCount, widget.speed);
    // Create and start the animation controller
    animCtr = AnimationController(vsync: this, duration: widget.repeatDuration)
      ..repeat();
  }

  @override
  void dispose() {
    // Dispose the animation controller to prevent memory leaks
    animCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use AnimatedBuilder to rebuild the widget on each animation frame
    return AnimatedBuilder(
      animation: animCtr,
      builder: (_, __) {
        // Use CustomPaint with LavaPainter to draw the lava lamp effect
        return CustomPaint(
          size: widget.size,
          painter: LavaPainter(
            lava: lava,
            color: widget.color ?? Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }
}

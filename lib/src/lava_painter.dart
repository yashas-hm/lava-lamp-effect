import 'package:flutter/material.dart';
import 'package:lava_lamp_effect/src/lava.dart';

/// [LavaPainter] is a custom painter that renders the lava lamp effect.
///
/// This painter uses the [Lava] model to draw the fluid animation
/// on a canvas with the specified color.
class LavaPainter extends CustomPainter {
  /// The lava model that contains the logic for the lava lamp effect.
  final Lava lava;

  /// The color to use when drawing the lava lamp effect.
  final Color color;

  /// Creates a new lava painter with the specified lava model and color.
  ///
  /// The [lava] parameter provides the model that defines the lava behavior.
  /// The [color] parameter specifies the color to use when drawing the lava.
  LavaPainter({required this.lava, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Update the lava size if it has changed
    if (lava.size != size) lava.updateSize(size);
    // Draw the lava effect on the canvas
    lava.draw(canvas, size, color);
  }

  @override
  bool shouldRepaint(LavaPainter oldDelegate) => true;
}

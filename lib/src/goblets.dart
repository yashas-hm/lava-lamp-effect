import 'dart:math';
import 'dart:ui';

import 'package:lava_lamp_effect/src/force_point.dart';

/// [Goblets] ia a class representing a blob in the lava lamp effect.
///
/// Each goblet is a moving element in the lava lamp that contributes to the
/// overall fluid effect. Goblets have position, velocity, and size properties
/// and move within a defined boundary.
class Goblets {
  /// The current position of the goblet.
  late ForcePoint<double> pos;

  /// The current velocity of the goblet.
  late ForcePoint<double> velocity;

  /// The size of the goblet.
  late double size;

  /// The speed factor affecting the goblet's movement.
  late int speed;

  /// Creates a new goblet with random position, velocity, and size.
  ///
  /// The [size] parameter defines the boundaries within which the goblet can move.
  /// The [speed] parameter affects how fast the goblet moves.
  Goblets(Size size, int speed) {
    final rand = Random();

    /// Generates a random velocity component based on the speed parameter.
    double randomVelocity() =>
        (rand.nextBool() ? 1 : -1) * (0.1 + 0.15 * rand.nextDouble() * speed);

    // Initialize with random velocity
    velocity = ForcePoint(randomVelocity(), randomVelocity());

    // Initialize with random position within the boundaries
    pos = ForcePoint(
        rand.nextDouble() * size.width, rand.nextDouble() * size.height);

    // Calculate size based on the container's dimensions
    double base = size.shortestSide / 15;
    this.size = base + (rand.nextDouble() * 1.4 + 0.1) * base;
  }

  /// Moves the goblet within the specified boundaries.
  ///
  /// This method updates the goblet's position based on its velocity and
  /// handles boundary collisions by reversing the appropriate velocity component.
  ///
  /// The [size] parameter defines the boundaries within which the goblet can move.
  void moveIn(Size size) {
    // Handle horizontal boundary collisions
    if (pos.x >= size.width - this.size) {
      velocity.x = -velocity.x;
      pos.x = size.width - this.size;
    } else if (pos.x <= this.size) {
      velocity.x = -velocity.x;
      pos.x = this.size;
    }

    // Handle vertical boundary collisions
    if (pos.y >= size.height - this.size) {
      velocity.y = -velocity.y;
      pos.y = size.height - this.size;
    } else if (pos.y <= this.size) {
      velocity.y = -velocity.y;
      pos.y = this.size;
    }

    // Update position based on velocity
    pos = pos.add(velocity);
  }
}

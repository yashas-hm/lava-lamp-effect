import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lava_lamp_effect/src/force_point.dart';
import 'package:lava_lamp_effect/src/goblets.dart';

/// [Lava] class implements the core logic of the lava lamp effect.
///
/// This class manages a collection of [Goblets] (lava blobs) and uses a force field
/// matrix to calculate the fluid-like shapes of the lava. It implements the
/// marching squares algorithm to generate smooth, organic shapes.
class Lava {
  /// The number of lava blobs to create.
  final int ballsCount;

  /// The speed factor affecting the movement of the lava blobs.
  final int speed;

  /// The step size for the force field grid.
  /// Smaller values create a more detailed but more computationally expensive effect.
  final num step = 5;

  /// The current size of the lava lamp container.
  Size size = Size.zero;

  /// The rectangle representing the boundaries of the force field grid.
  late Rect sRect;

  /// The width of the lava lamp container.
  double get width => size.width;

  /// The height of the lava lamp container.
  double get height => size.height;

  /// The number of grid cells in the x-direction.
  double get sx => (width ~/ step).toDouble();

  /// The number of grid cells in the y-direction.
  double get sy => (height ~/ step).toDouble();

  /// Flag indicating whether the lava is currently being painted.
  bool isPainting = false;

  /// Counter for tracking animation iterations.
  double iteration = 0;

  /// Sign used to alternate the direction of forces.
  int sign = 1;

  /// The collection of lava blobs.
  final List<Goblets> balls = [];

  /// The force field matrix used to calculate the lava shapes.
  /// This is a 2D grid of force points that define the force at each point in space.
  Map<int, Map<int, ForcePoint<double>>> matrix = {};

  /// Creates a new lava effect with the specified number of blobs and speed.
  ///
  /// The [ballsCount] parameter determines how many lava blobs to create.
  /// The [speed] parameter affects how fast the blobs move.
  Lava(this.ballsCount, this.speed);

  /// Updates the size of the lava lamp container and reinitializes the force field.
  ///
  /// This method is called when the size of the container changes. It:
  /// 1. Updates the size property
  /// 2. Recalculates the force field grid boundaries
  /// 3. Reinitializes the force field matrix
  /// 4. Creates new lava blobs with the new size
  ///
  /// The [newSize] parameter is the new size of the container.
  void updateSize(Size newSize) {
    size = newSize;
    // Create a rectangle centered at the origin with dimensions based on the grid size
    sRect = Rect.fromCenter(center: Offset.zero, width: sx, height: sy);

    // Clear the existing force field matrix
    matrix.clear();
    // Initialize the force field matrix with points
    for (int i = (sRect.left - step).toInt(); i < sRect.right + step; i++) {
      matrix[i] = {};
      for (int j = (sRect.top - step).toInt(); j < sRect.bottom + step; j++) {
        matrix[i]?[j] = ForcePoint(
          ((i + sx ~/ 2) * step).toDouble(),
          ((j + sy ~/ 2) * step).toDouble(),
        );
      }
    }

    // Clear existing lava blobs and create new ones
    balls.clear();
    for (int i = 0; i < ballsCount; i++) {
      balls.add(Goblets(size, speed));
    }
  }

  /// Computes the force at a specific point in the force field grid.
  ///
  /// This method calculates the combined force exerted by all lava blobs
  /// on a specific point in the force field. The force is inversely proportional
  /// to the distance between the point and each blob.
  ///
  /// The [sx] and [sy] parameters are the grid coordinates of the point.
  ///
  /// Returns the computed force value at the specified point.
  double computeForce(int sx, int sy) {
    // If the point is outside the grid boundaries, assign a default force
    if (!sRect.contains(Offset(sx.toDouble(), sy.toDouble()))) {
      return (matrix[sx]?[sy]?.force = 0.6 * sign)!;
    }

    final point = matrix[sx]![sy]!;
    double force = 0;
    // Calculate the combined force from all lava blobs
    for (final ball in balls) {
      // The force is proportional to the blob's size squared and inversely
      // proportional to a function of the distance between the point and the blob
      force +=
          ball.size *
          ball.size /
          (-2 * point.x * ball.pos.x -
              2 * point.y * ball.pos.y +
              ball.pos.magnitude +
              point.magnitude);
    }

    // Apply the current sign to alternate the force direction
    force *= sign;
    // Store the computed force in the matrix
    matrix[sx]![sy]!.force = force;
    return force;
  }

  /// Lookup table for x-coordinates used in the marching squares algorithm.
  /// These values define the relative positions for interpolation.
  final List<int> plx = [0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0];

  /// Lookup table for y-coordinates used in the marching squares algorithm.
  /// These values define the relative positions for interpolation.
  final List<int> ply = [0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1];

  /// Lookup table for marching squares cases.
  /// These values determine how to connect points based on the force field values.
  final List<int> mscases = [0, 3, 0, 3, 1, 3, 0, 3, 2, 2, 0, 2, 1, 1, 0];

  /// Lookup table for direction vectors used in the marching squares algorithm.
  /// These values define the directions to move when traversing the force field.
  final List<int> ix = [
    1,   // Right
    0,   // No horizontal movement
    -1,  // Left
    0,   // No horizontal movement
    0,   // No horizontal movement
    1,   // Right
    0,   // No horizontal movement
    -1,  // Left
    -1,  // Left
    0,   // No horizontal movement
    1,   // Right
    0,   // No horizontal movement
    0,   // No horizontal movement
    1,   // Right
    1,   // Right
    0,   // No horizontal movement
    0,   // No horizontal movement
    0,   // No horizontal movement
    1,   // Right
    1,   // Right
  ];

  /// Implements the marching squares algorithm to generate a path around a lava blob.
  ///
  /// This method is the core of the lava lamp effect's visual rendering. It uses
  /// the marching squares algorithm to trace the boundary of a lava blob based on
  /// the force field values.
  ///
  /// The [params] parameter contains:
  /// - [0]: The x-coordinate in the force field grid
  /// - [1]: The y-coordinate in the force field grid
  /// - [2]: The previous direction (used for ambiguous cases)
  ///
  /// The [path] parameter is the Flutter Path object being built to represent the blob.
  ///
  /// Returns the next set of parameters for the algorithm to continue, or null if
  /// the current point has already been processed in this iteration.
  List<int>? marchingSquares(List<int> params, Path path) {
    int sx = params[0];
    int sy = params[1];
    int? previousDir = params[2];

    // Skip if this point has already been processed in this iteration
    if (matrix[sx]?[sy]?.computed == iteration) return null;

    int dir;
    int mscase = 0;

    // Check the force values at the four corners around this point
    for (int a = 0; a < 4; a++) {
      final dx = ix[a + 12];
      final dy = ix[a + 16];
      double force = matrix[sx + dx]![sy + dy]!.force;

      // Compute the force if it hasn't been computed yet or has the wrong sign
      if (force.abs() <= 0 ||
          (force > 0 && sign < 0) ||
          (force < 0 && sign > 0)) {
        force = computeForce(sx + dx, sy + dy);
      }

      // If the force is strong enough, set the corresponding bit in the case value
      if (force.abs() > 1) {
        mscase += pow(2, a).toInt();
      }
    }

    // Special case handling
    if (mscase == 15) return [sx, sy - 1, -1];

    // Handle ambiguous cases based on the previous direction
    if (mscase == 5) {
      dir = previousDir == 2 ? 3 : 1;
    } else if (mscase == 10) {
      dir = previousDir == 3 ? 0 : 2;
    } else {
      // Use the lookup table for the standard cases
      dir = mscases[mscase];
      matrix[sx]![sy]!.computed = iteration;
    }

    // Get the interpolation points based on the direction
    final dx1 = plx[4 * dir + 2];
    final dy1 = ply[4 * dir + 2];
    final dx2 = plx[4 * dir + 3];
    final dy2 = ply[4 * dir + 3];

    // Calculate the force values at the interpolation points
    double f1 = matrix[sx + dx1]![sy + dy1]!.force.abs() - 1;
    double f2 = matrix[sx + dx2]![sy + dy2]!.force.abs() - 1;

    // Calculate the interpolation parameter
    double p = step / ((f1.abs()) / (f2.abs()) + 1);

    // Get the coordinates for the interpolated point
    final dxX = plx[4 * dir];
    final dyX = ply[4 * dir];
    final dxY = plx[4 * dir + 1];
    final dyY = ply[4 * dir + 1];

    // Calculate the final coordinates of the point on the path
    final x = matrix[sx + dxX]![sy + dyX]!.x + ix[dir] * p;
    final y = matrix[sx + dxY]![sy + dyY]!.y + ix[dir + 4] * p;

    // Add the point to the path
    if (!isPainting) {
      // Start a new sub-path if this is the first point
      path.moveTo(x, y);
    } else {
      // Add a line to this point if we're already painting
      path.lineTo(x, y);
    }

    // Set the painting flag to true
    isPainting = true;

    // Return the next point to process
    return [sx + ix[dir + 4], sy + ix[dir + 8], dir];
  }

  /// Draws the lava lamp effect on the canvas.
  ///
  /// This method is called on each animation frame to update and render the
  /// lava lamp effect. It:
  /// 1. Updates the positions of all lava blobs
  /// 2. Increments the iteration counter and flips the force sign
  /// 3. Generates and draws a path around each lava blob using the marching squares algorithm
  /// 4. Optionally draws debug visualizations if [debug] is true
  ///
  /// The [canvas] parameter is the Flutter canvas to draw on.
  /// The [size] parameter is the current size of the drawing area.
  /// The [color] parameter is the color to use for the lava blobs.
  /// The [debug] parameter controls whether to draw debug visualizations.
  void draw(Canvas canvas, Size size, Color color, {bool debug = false}) {
    // Update the positions of all lava blobs
    for (var ball in balls) {
      ball.moveIn(size);
    }

    // Increment the iteration counter and flip the force sign
    // This creates the pulsating effect of the lava
    iteration++;
    sign = -sign;
    isPainting = false;

    // Generate and draw a path around each lava blob
    for (var ball in balls) {
      final path = Path();
      // Initialize the parameters for the marching squares algorithm
      // Convert from world coordinates to grid coordinates
      List<int>? params = [
        (ball.pos.x / step - sx / 2).round(),
        (ball.pos.y / step - sy / 2).round(),
        -1, // No previous direction
      ];

      // Apply the marching squares algorithm to trace the blob boundary
      do {
        params = marchingSquares(params!, path);
      } while (params != null);

      // If we've generated a path, close it and draw it
      if (isPainting) {
        path.close();
        canvas.drawPath(path, Paint()..color = color);
        isPainting = false;
      }
    }

    // Draw debug visualizations if requested
    if (debug) {
      // Draw circles representing the lava blobs
      for (var ball in balls) {
        canvas.drawCircle(
          Offset(ball.pos.x.toDouble(), ball.pos.y.toDouble()),
          ball.size,
          Paint()..color = Colors.black.withValues(alpha: 0.5),
        );
      }

      // Draw points representing the force field
      matrix.forEach((_, row) {
        row.forEach((_, point) {
          canvas.drawCircle(
            Offset(point.x.toDouble(), point.y.toDouble()),
            max(1, min(point.force.abs(), 5)),
            Paint()..color = point.force > 0 ? Colors.blue : Colors.red,
          );
        });
      });
    }
  }
}

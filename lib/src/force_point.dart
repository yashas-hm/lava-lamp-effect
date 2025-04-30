/// [ForcePoint] is a class representing a point with force properties.
///
/// This class is used to model points in a force field for the lava lamp effect.
/// It includes properties for position, force magnitude, and computation state.
///
/// The generic type [T] must be a numeric type (int, double, etc.).
class ForcePoint<T extends num> {
  /// The x-coordinate of the point.
  T x;

  /// The y-coordinate of the point.
  T y;

  /// The force magnitude at this point.
  double force = 0;

  /// A value used during computation to track the state of this point.
  double computed = 0;

  /// Creates a new force point at the specified coordinates.
  ///
  /// The [x] and [y] parameters define the position of the point.
  ForcePoint(this.x, this.y);

  /// The squared magnitude of this point from the origin.
  ///
  /// This is calculated as x² + y² and is useful for distance calculations
  /// without the computational cost of a square root operation.
  T get magnitude => (x * x + y * y) as T;

  /// Adds another force point to this one, creating a new point.
  ///
  /// Returns a new [ForcePoint] with coordinates that are the sum of this
  /// point's coordinates and [other]'s coordinates.
  ForcePoint<T> add(ForcePoint<T> other) =>
      ForcePoint((x + other.x) as T, (y + other.y) as T);

  /// Creates a copy of this point with optionally modified coordinates.
  ///
  /// If [x] or [y] is provided, the new point will have that coordinate value.
  /// Otherwise, it will use the current point's coordinate value.
  ForcePoint<T> copyWith({T? x, T? y}) => ForcePoint(x ?? this.x, y ?? this.y);
}

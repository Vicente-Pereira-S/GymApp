import 'package:gym_app/domain/entities/exercise.dart';

class Routine {
  final String id;
  final String name;
  final int cycleOrder;
  final List<Exercise> exercises;

  const Routine({
    required this.id,
    required this.name,
    required this.cycleOrder,
    required this.exercises,
  });
}

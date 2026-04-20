import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/domain/entities/exercise.dart';
import 'package:gym_app/features/exercise_detail/presentation/widgets/exercise_header.dart';
import 'package:gym_app/features/exercise_detail/presentation/widgets/exercise_inputs_row.dart';
import 'package:gym_app/features/exercise_detail/presentation/widgets/permanent_note_field.dart';
import 'package:gym_app/features/exercise_detail/presentation/widgets/weight_history_chart.dart';
import 'package:gym_app/features/workout_state/providers/workout_state_provider.dart';

class ExerciseDetailPage extends ConsumerStatefulWidget {
  final Exercise exercise;

  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  ConsumerState<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends ConsumerState<ExerciseDetailPage> {
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _weightController;
  late final TextEditingController _noteController;
  late final FocusNode _noteFocusNode;

  @override
  void initState() {
    super.initState();

    final draft = ref
        .read(workoutStateProvider.notifier)
        .getDraftForExercise(widget.exercise);

    _setsController = TextEditingController(text: draft.sets.toString());
    _repsController = TextEditingController(text: draft.reps.toString());
    _weightController = TextEditingController(
      text: draft.weightKg?.toString() ?? '',
    );
    _noteController = TextEditingController(text: draft.permanentNote);
    _noteFocusNode = FocusNode();

    _setsController.addListener(_saveNumericDraft);
    _repsController.addListener(_saveNumericDraft);
    _weightController.addListener(_saveNumericDraft);
  }

  void _saveNumericDraft() {
    final int? parsedSets = int.tryParse(_setsController.text);
    final int? parsedReps = int.tryParse(_repsController.text);
    final double? parsedWeight = _parseWeight(_weightController.text);

    final draft = ref
        .read(workoutStateProvider.notifier)
        .getDraftForExercise(widget.exercise);

    ref
        .read(workoutStateProvider.notifier)
        .updateExerciseDraft(
          exercise: widget.exercise,
          sets: parsedSets ?? draft.sets,
          reps: parsedReps ?? draft.reps,
          weightKg: parsedWeight,
        );
  }

  double? _parseWeight(String text) {
    final String normalized = text.replaceAll(',', '.');

    if (normalized.trim().isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }

  Future<void> _saveNote() async {
    await ref
        .read(workoutStateProvider.notifier)
        .updateExerciseDraft(
          exercise: widget.exercise,
          permanentNote: _noteController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note saved.')));
  }

  @override
  void dispose() {
    _setsController.removeListener(_saveNumericDraft);
    _repsController.removeListener(_saveNumericDraft);
    _weightController.removeListener(_saveNumericDraft);

    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(widget.exercise.name)),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ExerciseHeader(exercise: widget.exercise),
              const SizedBox(height: 16),
              ExerciseInputsRow(
                setsController: _setsController,
                repsController: _repsController,
                weightController: _weightController,
              ),
              const SizedBox(height: 16),
              PermanentNoteField(
                controller: _noteController,
                onSave: _saveNote,
                focusNode: _noteFocusNode,
              ),
              const SizedBox(height: 16),
              const WeightHistoryChart(),
            ],
          ),
        ),
      ),
    );
  }
}

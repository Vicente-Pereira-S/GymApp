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
  late final TextEditingController _repsMinController;
  late final TextEditingController _repsMaxController;
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
    _repsMinController = TextEditingController(text: draft.repsMin.toString());
    _repsMaxController = TextEditingController(text: draft.repsMax.toString());
    _weightController = TextEditingController(
      text: draft.weightKg?.toString() ?? '',
    );
    _noteController = TextEditingController(text: draft.permanentNote);
    _noteFocusNode = FocusNode();

    _setsController.addListener(_saveNumericDraft);
    _repsMinController.addListener(_saveNumericDraft);
    _repsMaxController.addListener(_saveNumericDraft);
    _weightController.addListener(_saveNumericDraft);
  }

  void _saveNumericDraft() {
    final int? parsedSets = int.tryParse(_setsController.text);
    final int? parsedRepsMin = int.tryParse(_repsMinController.text);
    final int? parsedRepsMax = int.tryParse(_repsMaxController.text);
    final double? parsedWeight = _parseWeight(_weightController.text);

    final draft = ref
        .read(workoutStateProvider.notifier)
        .getDraftForExercise(widget.exercise);

    ref
        .read(workoutStateProvider.notifier)
        .updateExerciseDraft(
          exercise: widget.exercise,
          sets: parsedSets ?? draft.sets,
          repsMin: parsedRepsMin ?? draft.repsMin,
          repsMax: parsedRepsMax ?? draft.repsMax,
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
    _repsMinController.removeListener(_saveNumericDraft);
    _repsMaxController.removeListener(_saveNumericDraft);
    _weightController.removeListener(_saveNumericDraft);

    _setsController.dispose();
    _repsMinController.dispose();
    _repsMaxController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(workoutStateProvider);

    final weightHistory = ref
        .read(workoutStateProvider.notifier)
        .getWeightHistoryForExercise(widget.exercise.id);

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
                repsMinController: _repsMinController,
                repsMaxController: _repsMaxController,
                weightController: _weightController,
              ),
              const SizedBox(height: 16),
              PermanentNoteField(
                controller: _noteController,
                onSave: _saveNote,
                focusNode: _noteFocusNode,
              ),
              const SizedBox(height: 16),
              WeightHistoryChart(entries: weightHistory),
            ],
          ),
        ),
      ),
    );
  }
}

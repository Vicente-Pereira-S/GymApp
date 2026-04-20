import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';

class ExerciseInputsRow extends StatelessWidget {
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController weightController;

  const ExerciseInputsRow({
    super.key,
    required this.setsController,
    required this.repsController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Workout data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _NumberInput(controller: setsController, label: 'Sets'),
              ),
              const SizedBox(width: 8),
              const Text(
                'x',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _NumberInput(controller: repsController, label: 'Reps'),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 3,
                child: _DecimalInput(
                  controller: weightController,
                  label: 'Weight',
                  suffix: 'Kg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _NumberInput({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

class _DecimalInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;

  const _DecimalInput({
    required this.controller,
    required this.label,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        suffixStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';

class PermanentNoteField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final FocusNode focusNode;
  final int maxLength;

  const PermanentNoteField({
    super.key,
    required this.controller,
    required this.onSave,
    required this.focusNode,
    this.maxLength = 255,
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
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final int currentLength = value.text.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Permanent note',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (textFieldContext) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLength: maxLength,
                    minLines: 3,
                    maxLines: 5,
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (textFieldContext.mounted) {
                          Scrollable.ensureVisible(
                            textFieldContext,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    },
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Add a note for this exercise...',
                      hintStyle: const TextStyle(color: AppColors.textMuted),
                      counterText: '',
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
                        borderSide: const BorderSide(
                          color: AppColors.accent,
                          width: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onSave,
                  child: const Text(
                    'Save note',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$currentLength / $maxLength',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

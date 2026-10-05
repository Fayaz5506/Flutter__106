import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/priority.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';

class AddTaskSheet extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskSheet({super.key, this.taskToEdit});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late DateTime _selectedDateTime;
  late Priority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskToEdit?.title ?? '');
    _selectedDateTime = widget.taskToEdit?.dueTime ?? DateTime.now().add(const Duration(hours: 2));
    _selectedPriority = widget.taskToEdit?.priority ?? Priority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (time != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      if (widget.taskToEdit == null) {
        provider.addTask(
          title: _titleController.text.trim(),
          dueTime: _selectedDateTime,
          priority: _selectedPriority,
        );
      } else {
        provider.editTask(
          id: widget.taskToEdit!.id,
          title: _titleController.text.trim(),
          dueTime: _selectedDateTime,
          priority: _selectedPriority,
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.taskToEdit != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: AppSpacings.md,
        left: AppSpacings.lg,
        right: AppSpacings.lg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sheet Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacings.md),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Task' : 'Add New Task',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacings.md),
            // Task Title Input
            TextFormField(
              controller: _titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g. Finish quarterly report',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.radiusSm),
                ),
                prefixIcon: const Icon(Icons.task_alt_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacings.md),
            // Due Time Selection Row
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickTime,
                    borderRadius: BorderRadius.circular(AppSpacings.radiusSm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacings.md,
                        vertical: AppSpacings.md - 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(AppSpacings.radiusSm),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, color: AppColors.primary),
                          const SizedBox(width: AppSpacings.sm),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Due Time',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              Text(
                                DateFormatter.formatTime(_selectedDateTime),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacings.md),
            // Priority Selector Label
            Text(
              'Priority Tag',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacings.xs + 2),
            // Segmented Button Priority Selector
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<Priority>(
                segments: const [
                  ButtonSegment<Priority>(
                    value: Priority.low,
                    label: Text('Low'),
                    icon: Icon(Icons.circle, color: AppColors.priorityLow, size: 12),
                  ),
                  ButtonSegment<Priority>(
                    value: Priority.medium,
                    label: Text('Medium'),
                    icon: Icon(Icons.circle, color: AppColors.priorityMedium, size: 12),
                  ),
                  ButtonSegment<Priority>(
                    value: Priority.high,
                    label: Text('High'),
                    icon: Icon(Icons.circle, color: AppColors.priorityHigh, size: 12),
                  ),
                ],
                selected: {_selectedPriority},
                onSelectionChanged: (Set<Priority> newSelection) {
                  setState(() {
                    _selectedPriority = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacings.lg),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacings.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
                  ),
                ),
                child: Text(
                  isEditing ? 'Save Changes' : 'Create Task',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: AppSpacings.lg),
          ],
        ),
      ),
    );
  }
}

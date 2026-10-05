import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';

class AddHabitSheet extends StatefulWidget {
  final Habit? habitToEdit;

  const AddHabitSheet({super.key, this.habitToEdit});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedIcon;
  late String _selectedColorHex;

  final List<Map<String, dynamic>> _iconOptions = [
    {'name': 'self_improvement', 'icon': Icons.self_improvement_rounded, 'label': 'Meditate'},
    {'name': 'menu_book', 'icon': Icons.menu_book_rounded, 'label': 'Read'},
    {'name': 'water_drop', 'icon': Icons.water_drop_rounded, 'label': 'Water'},
    {'name': 'fitness_center', 'icon': Icons.fitness_center_rounded, 'label': 'Gym'},
    {'name': 'directions_run', 'icon': Icons.directions_run_rounded, 'label': 'Run'},
    {'name': 'bedtime', 'icon': Icons.bedtime_rounded, 'label': 'Sleep'},
    {'name': 'code', 'icon': Icons.code_rounded, 'label': 'Code'},
    {'name': 'brush', 'icon': Icons.brush_rounded, 'label': 'Art'},
    {'name': 'local_cafe', 'icon': Icons.local_cafe_rounded, 'label': 'Tea/Coffee'},
    {'name': 'favorite', 'icon': Icons.favorite_rounded, 'label': 'Health'},
  ];

  final List<String> _colorOptions = [
    'FF7A00', // Energetic Orange
    '00A68C', // Fresh Teal
    '3B82F6', // Vibrant Blue
    '8B5CF6', // Purple
    'EC4899', // Pink
    'EF4444', // Red
    '10B981', // Emerald
    'F59E0B', // Amber
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habitToEdit?.name ?? '');
    _selectedIcon = widget.habitToEdit?.iconName ?? 'self_improvement';
    _selectedColorHex = widget.habitToEdit?.colorHex ?? 'FF7A00';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      if (widget.habitToEdit == null) {
        provider.addHabit(
          name: _nameController.text.trim(),
          iconName: _selectedIcon,
          colorHex: _selectedColorHex,
        );
      } else {
        provider.editHabit(
          id: widget.habitToEdit!.id,
          name: _nameController.text.trim(),
          iconName: _selectedIcon,
          colorHex: _selectedColorHex,
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.habitToEdit != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: AppSpacings.md,
        left: AppSpacings.lg,
        right: AppSpacings.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                    isEditing ? 'Edit Habit' : 'Build New Habit',
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
              // Habit Name Field
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'e.g. Read 15 mins daily',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.radiusSm),
                  ),
                  prefixIcon: const Icon(Icons.star_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacings.md),
              // Icon Selection
              Text(
                'Choose Icon',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacings.xs + 2),
              SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _iconOptions.length,
                  itemBuilder: (context, index) {
                    final item = _iconOptions[index];
                    final isSelected = _selectedIcon == item['name'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = item['name'] as String),
                      child: AnimatedContainer(
                        duration: AppDurations.quick,
                        margin: const EdgeInsets.only(right: AppSpacings.sm),
                        padding: const EdgeInsets.all(AppSpacings.sm),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppSpacings.radiusSm),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected ? AppColors.primary : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacings.md),
              // Color Selection
              Text(
                'Choose Color',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacings.xs + 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _colorOptions.map((hex) {
                  final color = Color(int.parse('ff$hex', radix: 16));
                  final isSelected = _selectedColorHex == hex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorHex = hex),
                    child: AnimatedContainer(
                      duration: AppDurations.quick,
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3.0)
                            : null,
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
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
                    isEditing ? 'Save Changes' : 'Create Habit',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacings.lg),
            ],
          ),
        ),
      ),
    );
  }
}

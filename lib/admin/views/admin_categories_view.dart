import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/admin_data_service.dart';
import '../widgets/admin_confirmation_dialog.dart';
import '../widgets/admin_empty_state.dart';

/// Admin Categories Management: Configure expense & income categories for student app.
class AdminCategoriesView extends StatefulWidget {
  const AdminCategoriesView({super.key});

  @override
  State<AdminCategoriesView> createState() => _AdminCategoriesViewState();
}

class _AdminCategoriesViewState extends State<AdminCategoriesView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AdminDataService.instance,
      builder: (context, _) {
        final categories = AdminDataService.instance.categories;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header & Add Action
              LayoutBuilder(
                builder: (context, headerConstraints) {
                  final isWide = headerConstraints.maxWidth >= 650;
                  final addButton = ElevatedButton.icon(
                    onPressed: () => _openCategoryEditor(null),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(
                      'Add Category',
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );

                  if (isWide) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transaction Categories',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage active categories available in the student expense logging forms.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        addButton,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction Categories',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage active categories available in the student expense logging forms.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        addButton,
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // 2. Categories Table
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: categories.isEmpty
                    ? const AdminEmptyState(
                        icon: Icons.category_rounded,
                        title: 'No Categories Available',
                        subtitle: 'Add standard student categories to get started.',
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                            horizontalMargin: 20,
                            columnSpacing: 32,
                            headingTextStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                            ),
                            dataTextStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF0F172A)),
                            columns: const [
                              DataColumn(label: Text('CATEGORY ICON & NAME')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('SYSTEM DEFAULT')),
                              DataColumn(label: Text('APPLICATION USAGE')),
                              DataColumn(label: Text('ACTIONS')),
                            ],
                            rows: categories.map((cat) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: cat.color.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(cat.icon, color: cat.color, size: 18),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(cat.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: cat.isActive ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        cat.isActive ? 'Active' : 'Disabled',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: cat.isActive ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      cat.isDefault ? 'Core Default' : 'Custom',
                                      style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B)),
                                    ),
                                  ),
                                  DataCell(Text('${cat.usageCount} entries')),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryBlue),
                                          tooltip: 'Edit Category',
                                          onPressed: () => _openCategoryEditor(cat),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            cat.isActive ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                                            size: 26,
                                            color: cat.isActive ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                          ),
                                          tooltip: cat.isActive ? 'Disable Category' : 'Enable Category',
                                          onPressed: () => _toggleCategory(cat),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleCategory(CategoryModel cat) async {
    final willDisable = cat.isActive;
    if (willDisable && cat.isDefault) {
      final confirmed = await AdminConfirmationDialog.show(
        context,
        title: 'Disable Core Category?',
        message: 'Disabling "${cat.name}" will hide it from future student forms, but existing student logs will be preserved safely.',
        confirmLabel: 'Disable',
        isDestructive: true,
      );
      if (confirmed != true) return;
    }

    AdminDataService.instance.toggleCategoryStatus(cat.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "${cat.name}" ${willDisable ? "disabled" : "activated"}.'),
          backgroundColor: willDisable ? AppColors.error : AppColors.accentGreen,
        ),
      );
    }
  }

  void _openCategoryEditor(CategoryModel? cat) {
    showDialog(
      context: context,
      builder: (ctx) => _CategoryEditorDialog(category: cat),
    );
  }
}

class _CategoryEditorDialog extends StatefulWidget {
  final CategoryModel? category;

  const _CategoryEditorDialog({this.category});

  @override
  State<_CategoryEditorDialog> createState() => _CategoryEditorDialogState();
}

class _CategoryEditorDialogState extends State<_CategoryEditorDialog> {
  late TextEditingController _nameController;
  late IconData _selectedIcon;
  late Color _selectedColor;

  final List<IconData> _iconList = [
    Icons.restaurant_rounded,
    Icons.directions_bus_rounded,
    Icons.menu_book_rounded,
    Icons.shopping_bag_rounded,
    Icons.movie_filter_rounded,
    Icons.bolt_rounded,
    Icons.savings_rounded,
    Icons.fitness_center_rounded,
    Icons.coffee_rounded,
    Icons.flight_rounded,
  ];

  final List<Color> _colorList = [
    const Color(0xFF10B981),
    const Color(0xFF0077F6),
    const Color(0xFF8B5CF6),
    const Color(0xFFF59E0B),
    const Color(0xFFEC4899),
    const Color(0xFF06B6D4),
    const Color(0xFF64748B),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.icon ?? Icons.category_rounded;
    _selectedColor = widget.category?.color ?? const Color(0xFF0077F6);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) return;

    final updated = CategoryModel(
      id: widget.category?.id ?? 'CAT-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: _nameController.text.trim(),
      icon: _selectedIcon,
      color: _selectedColor,
      isActive: widget.category?.isActive ?? true,
      isDefault: widget.category?.isDefault ?? false,
      createdDate: widget.category?.createdDate ?? DateTime.now(),
      usageCount: widget.category?.usageCount ?? 0,
    );

    AdminDataService.instance.saveCategory(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category == null ? 'Add Category' : 'Edit Category',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'e.g., Gym & Sports',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 14),

              Text('Select Icon', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _iconList.map((ic) {
                  final isSel = _selectedIcon == ic;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = ic),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.primaryBlue.withValues(alpha: 0.12) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSel ? AppColors.primaryBlue : Colors.transparent),
                      ),
                      child: Icon(ic, size: 20, color: isSel ? AppColors.primaryBlue : const Color(0xFF64748B)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              Text('Select Color Accent', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _colorList.map((col) {
                  final isSel = _selectedColor == col;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = col),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: col,
                        shape: BoxShape.circle,
                        border: isSel ? Border.all(color: Colors.white, width: 3) : null,
                        boxShadow: isSel ? [BoxShadow(color: col.withValues(alpha: 0.4), blurRadius: 6)] : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: GoogleFonts.poppins(color: const Color(0xFF64748B))),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save Category', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

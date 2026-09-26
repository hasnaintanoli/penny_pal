import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/admin_data_service.dart';
import '../utils/admin_date_format.dart';
import '../widgets/admin_confirmation_dialog.dart';
import '../widgets/admin_empty_state.dart';

/// Admin Learning Content Management: CRUD interface for financial literacy guides
/// featuring a live "Student View" simulated preview panel.
class AdminLearningView extends StatefulWidget {
  const AdminLearningView({super.key});

  @override
  State<AdminLearningView> createState() => _AdminLearningViewState();
}

class _AdminLearningViewState extends State<AdminLearningView> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Budgeting',
    'Saving',
    'Income',
    'Necessary Expenses',
    'Optional Expenses',
    'Smart Spending',
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AdminDataService.instance,
      builder: (context, _) {
        final topics = AdminDataService.instance.learningTopics;
        final filtered = topics.where((t) {
          final matchesCategory =
              _selectedCategory == 'All' ||
              t.category.toLowerCase() == _selectedCategory.toLowerCase();
          final matchesSearch =
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.shortDescription.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
          return matchesCategory && matchesSearch;
        }).toList();

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
                    onPressed: () => _openTopicEditor(null),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(
                      'Add Learning Topic',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                                'Financial Literacy Content',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage, curate, and publish student money guides and micro-lessons.',
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
                          'Financial Literacy Content',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage, curate, and publish student money guides and micro-lessons.',
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

              // 2. Filter & Search Controls
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search topics by title or keywords...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(
                                cat,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.primaryBlue,
                              backgroundColor: const Color(0xFFF1F5F9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (_) =>
                                  setState(() => _selectedCategory = cat),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Topics Table
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
                child: filtered.isEmpty
                    ? const AdminEmptyState(
                        icon: Icons.menu_book_rounded,
                        title: 'No Learning Topics',
                        subtitle:
                            'No financial education guides found matching the selected criteria.',
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFF8FAFC),
                            ),
                            horizontalMargin: 20,
                            columnSpacing: 28,
                            headingTextStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                            ),
                            dataTextStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF0F172A),
                            ),
                            columns: const [
                              DataColumn(label: Text('TOPIC TITLE')),
                              DataColumn(label: Text('CATEGORY')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('VIEWS')),
                              DataColumn(label: Text('LAST UPDATED')),
                              DataColumn(label: Text('ACTIONS')),
                            ],
                            rows: filtered.map((topic) {
                              final isPub =
                                  topic.status == LearningStatus.published;
                              return DataRow(
                                cells: [
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 260,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            topic.title,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            topic.shortDescription,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: const Color(0xFF64748B),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEBF3FE),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        topic.category,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isPub
                                            ? const Color(0xFFECFDF5)
                                            : const Color(0xFFFFFBEB),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isPub ? 'Published' : 'Draft',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isPub
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFD97706),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text('${topic.views}')),
                                  DataCell(
                                    Text(
                                      AdminDateFormat.formatShort(
                                        topic.updatedDate,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            size: 18,
                                            color: AppColors.primaryBlue,
                                          ),
                                          tooltip: 'Edit Topic',
                                          onPressed: () =>
                                              _openTopicEditor(topic),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isPub
                                                ? Icons.visibility_off_outlined
                                                : Icons.publish_rounded,
                                            size: 18,
                                            color: isPub
                                                ? const Color(0xFFF59E0B)
                                                : const Color(0xFF10B981),
                                          ),
                                          tooltip: isPub
                                              ? 'Unpublish'
                                              : 'Publish',
                                          onPressed: () =>
                                              _togglePublishTopic(topic),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            size: 18,
                                            color: AppColors.error,
                                          ),
                                          tooltip: 'Delete Topic',
                                          onPressed: () => _deleteTopic(topic),
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

  void _togglePublishTopic(LearningTopicModel topic) {
    setState(() {
      topic.status = topic.status == LearningStatus.published
          ? LearningStatus.draft
          : LearningStatus.published;
      topic.updatedDate = DateTime.now();
    });
    AdminDataService.instance.saveLearningTopic(topic);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Topic "${topic.title}" marked as ${topic.status.name.toUpperCase()}.',
        ),
        backgroundColor: AppColors.accentGreen,
      ),
    );
  }

  Future<void> _deleteTopic(LearningTopicModel topic) async {
    final confirmed = await AdminConfirmationDialog.show(
      context,
      title: 'Delete Learning Topic?',
      message:
          'Are you sure you want to permanently remove "${topic.title}" from the student app?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true) {
      AdminDataService.instance.deleteLearningTopic(topic.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Topic "${topic.title}" deleted.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _openTopicEditor(LearningTopicModel? existingTopic) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _TopicEditorModal(topic: existingTopic),
    );
  }
}

class _TopicEditorModal extends StatefulWidget {
  final LearningTopicModel? topic;

  const _TopicEditorModal({this.topic});

  @override
  State<_TopicEditorModal> createState() => _TopicEditorModalState();
}

class _TopicEditorModalState extends State<_TopicEditorModal> {
  late TextEditingController _titleController;
  late TextEditingController _shortDescController;
  late TextEditingController _contentController;
  late TextEditingController _exampleController;
  late String _selectedCategory;
  late bool _isPublished;

  final List<String> _categoryOptions = [
    'Budgeting',
    'Saving',
    'Income',
    'Necessary Expenses',
    'Optional Expenses',
    'Smart Spending',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.topic?.title ?? '');
    _shortDescController = TextEditingController(
      text: widget.topic?.shortDescription ?? '',
    );
    _contentController = TextEditingController(
      text: widget.topic?.content ?? '',
    );
    _exampleController = TextEditingController(
      text: widget.topic?.example ?? '',
    );
    _selectedCategory = widget.topic?.category ?? 'Budgeting';
    _isPublished = widget.topic?.status == LearningStatus.published;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescController.dispose();
    _contentController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  void _save(bool publishNow) {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a topic title.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final newTopic = LearningTopicModel(
      id:
          widget.topic?.id ??
          'LRN-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: _titleController.text.trim(),
      category: _selectedCategory,
      shortDescription: _shortDescController.text.trim(),
      content: _contentController.text.trim(),
      example: _exampleController.text.trim(),
      status: publishNow
          ? LearningStatus.published
          : (_isPublished ? LearningStatus.published : LearningStatus.draft),
      views: widget.topic?.views ?? 0,
      createdDate: widget.topic?.createdDate ?? DateTime.now(),
      updatedDate: DateTime.now(),
    );

    AdminDataService.instance.saveLearningTopic(newTopic);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Topic "${newTopic.title}" saved successfully!'),
        backgroundColor: AppColors.accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Modal Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF3FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.topic == null
                            ? 'Add Learning Topic'
                            : 'Edit Learning Topic',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF64748B),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Form & Live Student Preview
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Form Fields
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Topic Title',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _titleController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText:
                                    'e.g., The 50/30/20 Rule for Students',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            Text(
                              'Category',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedCategory,
                              items: _categoryOptions
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        c,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedCategory = val);
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            Text(
                              'Short Description',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _shortDescController,
                              onChanged: (_) => setState(() {}),
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText:
                                    'Brief summary displayed on student cards...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            Text(
                              'Full Educational Content',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _contentController,
                              onChanged: (_) => setState(() {}),
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    'Detailed explanation with actionable student guidance...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            Text(
                              'Practical Example',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _exampleController,
                              onChanged: (_) => setState(() {}),
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText:
                                    'e.g., If allowance is Rs. 20,000, save Rs. 4,000...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Right: Live "Student View" Mobile Preview Panel
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F8FE),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFD4E6FA)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_iphone_rounded,
                                  size: 16,
                                  color: AppColors.primaryBlue,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Student View Preview',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF0077F6,
                                      ).withValues(alpha: 0.08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEBF3FE),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _selectedCategory,
                                        style: GoogleFonts.poppins(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _titleController.text.isNotEmpty
                                          ? _titleController.text
                                          : 'Topic Title Goes Here',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _shortDescController.text.isNotEmpty
                                          ? _shortDescController.text
                                          : 'A concise preview of the financial literacy advice...',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.5,
                                        color: const Color(0xFF64748B),
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (_exampleController.text.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECFDF5),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '💡 Example: ${_exampleController.text}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: const Color(0xFF065F46),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),

              // Bottom Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => _save(false),
                    child: Text(
                      'Save Draft',
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _save(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Publish Now',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
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

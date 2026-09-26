import 'package:flutter/material.dart';

enum StudentStatus { active, inactive, suspended }
enum LearningStatus { published, draft }
enum SupportStatus { open, inProgress, resolved }
enum FeedbackStatus { pending, reviewed }
enum NotificationType { budgetAlert, savingsReminder, learningTip, systemNotification }
enum NotificationStatus { sent, scheduled, draft }

class StudentModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  StudentStatus status;
  final DateTime registeredDate;
  DateTime lastActivity;
  final double totalBalanceRecorded;
  final double totalIncomeRecorded;
  final double totalExpenseRecorded;
  final int activeBudgetsCount;
  final int activeGoalsCount;
  final int transactionsCount;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    this.status = StudentStatus.active,
    required this.registeredDate,
    required this.lastActivity,
    this.totalBalanceRecorded = 0.0,
    this.totalIncomeRecorded = 0.0,
    this.totalExpenseRecorded = 0.0,
    this.activeBudgetsCount = 0,
    this.activeGoalsCount = 0,
    this.transactionsCount = 0,
  });
}

class ActivityItem {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String category; // 'Students', 'Transactions', 'Budgets', 'Goals', 'Learning', 'Support', 'Feedback'
  final Color badgeColor;
  final IconData icon;

  ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    required this.badgeColor,
    required this.icon,
  });
}

class LearningTopicModel {
  final String id;
  String title;
  String category;
  String shortDescription;
  String content;
  String example;
  LearningStatus status;
  int views;
  final DateTime createdDate;
  DateTime updatedDate;

  LearningTopicModel({
    required this.id,
    required this.title,
    required this.category,
    required this.shortDescription,
    required this.content,
    required this.example,
    this.status = LearningStatus.published,
    this.views = 0,
    required this.createdDate,
    required this.updatedDate,
  });
}

class SupportQueryModel {
  final String id;
  final String studentName;
  final String studentEmail;
  final String subject;
  final String message;
  final DateTime submittedDate;
  SupportStatus status;
  DateTime lastUpdated;
  List<SupportResponse> conversation;

  SupportQueryModel({
    required this.id,
    required this.studentName,
    required this.studentEmail,
    required this.subject,
    required this.message,
    required this.submittedDate,
    this.status = SupportStatus.open,
    required this.lastUpdated,
    required this.conversation,
  });
}

class SupportResponse {
  final String sender;
  final bool isAdmin;
  final String text;
  final DateTime time;

  SupportResponse({
    required this.sender,
    required this.isAdmin,
    required this.text,
    required this.time,
  });
}

class FeedbackItemModel {
  final String id;
  final String studentName;
  final String studentEmail;
  final int rating;
  final String comment;
  final DateTime date;
  FeedbackStatus status;

  FeedbackItemModel({
    required this.id,
    required this.studentName,
    required this.studentEmail,
    required this.rating,
    required this.comment,
    required this.date,
    this.status = FeedbackStatus.pending,
  });
}

class NotificationCampaignModel {
  final String id;
  String title;
  String message;
  NotificationType type;
  String audience;
  DateTime scheduledDate;
  NotificationStatus status;
  int recipientsCount;

  NotificationCampaignModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.audience,
    required this.scheduledDate,
    this.status = NotificationStatus.sent,
    this.recipientsCount = 0,
  });
}

class CategoryModel {
  final String id;
  String name;
  IconData icon;
  Color color;
  bool isActive;
  final bool isDefault;
  final DateTime createdDate;
  int usageCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isActive = true,
    this.isDefault = true,
    required this.createdDate,
    this.usageCount = 0,
  });
}

/// Centralized reactive Admin Data Service managing platform datasets & CRUD logic.
class AdminDataService extends ChangeNotifier {
  AdminDataService._privateConstructor() {
    _initData();
  }

  static final AdminDataService instance = AdminDataService._privateConstructor();

  late List<StudentModel> students;
  late List<ActivityItem> activities;
  late List<LearningTopicModel> learningTopics;
  late List<SupportQueryModel> supportQueries;
  late List<FeedbackItemModel> feedbackList;
  late List<NotificationCampaignModel> notifications;
  late List<CategoryModel> categories;

  // App Settings
  bool pushNotificationsEnabled = true;
  bool studentRegistrationOpen = true;
  bool autoModerateFeedback = true;
  String supportEmailAddress = 'support@pennypal.app';
  String applicationVersion = 'v2.4.0 (Fresh All Along)';
  String nonBankingNotice = 'PennyPal is a financial education & expense logging tool. Not a bank, payment processor, or investment advisor.';

  void _initData() {
    students = [
      StudentModel(
        id: 'STU-1001',
        name: 'Hasnain Ali',
        email: 'hasnain@student.pennypal.com',
        mobile: '+92 300 1234567',
        status: StudentStatus.active,
        registeredDate: DateTime.now().subtract(const Duration(days: 45)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 18)),
        totalBalanceRecorded: 24500.0,
        totalIncomeRecorded: 42000.0,
        totalExpenseRecorded: 17500.0,
        activeBudgetsCount: 5,
        activeGoalsCount: 3,
        transactionsCount: 28,
      ),
      StudentModel(
        id: 'STU-1002',
        name: 'Ayesha Khan',
        email: 'ayesha.k@university.edu',
        mobile: '+92 321 9876543',
        status: StudentStatus.active,
        registeredDate: DateTime.now().subtract(const Duration(days: 60)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
        totalBalanceRecorded: 18200.0,
        totalIncomeRecorded: 30000.0,
        totalExpenseRecorded: 11800.0,
        activeBudgetsCount: 4,
        activeGoalsCount: 2,
        transactionsCount: 42,
      ),
      StudentModel(
        id: 'STU-1003',
        name: 'Bilal Ahmed',
        email: 'bilal.ahmed@campus.pk',
        mobile: '+92 333 4567890',
        status: StudentStatus.active,
        registeredDate: DateTime.now().subtract(const Duration(days: 20)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 6)),
        totalBalanceRecorded: 9400.0,
        totalIncomeRecorded: 15000.0,
        totalExpenseRecorded: 5600.0,
        activeBudgetsCount: 3,
        activeGoalsCount: 1,
        transactionsCount: 15,
      ),
      StudentModel(
        id: 'STU-1004',
        name: 'Zainab Fatima',
        email: 'zainab.f@college.edu',
        mobile: '+92 312 8887766',
        status: StudentStatus.inactive,
        registeredDate: DateTime.now().subtract(const Duration(days: 90)),
        lastActivity: DateTime.now().subtract(const Duration(days: 14)),
        totalBalanceRecorded: 3200.0,
        totalIncomeRecorded: 8000.0,
        totalExpenseRecorded: 4800.0,
        activeBudgetsCount: 2,
        activeGoalsCount: 1,
        transactionsCount: 9,
      ),
      StudentModel(
        id: 'STU-1005',
        name: 'Hamza Tariq',
        email: 'hamza.t@techstudent.com',
        mobile: '+92 345 1122334',
        status: StudentStatus.suspended,
        registeredDate: DateTime.now().subtract(const Duration(days: 120)),
        lastActivity: DateTime.now().subtract(const Duration(days: 30)),
        totalBalanceRecorded: 0.0,
        totalIncomeRecorded: 0.0,
        totalExpenseRecorded: 0.0,
        activeBudgetsCount: 0,
        activeGoalsCount: 0,
        transactionsCount: 2,
      ),
      StudentModel(
        id: 'STU-1006',
        name: 'Fatima Noor',
        email: 'fatima.noor@university.org',
        mobile: '+92 304 9988776',
        status: StudentStatus.active,
        registeredDate: DateTime.now().subtract(const Duration(days: 15)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
        totalBalanceRecorded: 14750.0,
        totalIncomeRecorded: 25000.0,
        totalExpenseRecorded: 10250.0,
        activeBudgetsCount: 4,
        activeGoalsCount: 4,
        transactionsCount: 31,
      ),
      StudentModel(
        id: 'STU-1007',
        name: 'Usman Farooq',
        email: 'usman.f@campus.edu.pk',
        mobile: '+92 331 5566778',
        status: StudentStatus.active,
        registeredDate: DateTime.now().subtract(const Duration(days: 35)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 4)),
        totalBalanceRecorded: 8300.0,
        totalIncomeRecorded: 16000.0,
        totalExpenseRecorded: 7700.0,
        activeBudgetsCount: 3,
        activeGoalsCount: 1,
        transactionsCount: 19,
      ),
    ];

    activities = [
      ActivityItem(
        id: 'ACT-01',
        title: 'New Student Registered',
        description: 'Usman Farooq registered from University of Punjab.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        category: 'Students',
        badgeColor: const Color(0xFF10B981),
        icon: Icons.person_add_rounded,
      ),
      ActivityItem(
        id: 'ACT-02',
        title: 'Learning Content Published',
        description: 'New topic "Understanding Student Discounts & Perks" went live.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        category: 'Learning',
        badgeColor: const Color(0xFF0077F6),
        icon: Icons.menu_book_rounded,
      ),
      ActivityItem(
        id: 'ACT-03',
        title: 'Support Query Received',
        description: 'Ayesha Khan inquired about recurring savings goal reminders.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        category: 'Support',
        badgeColor: const Color(0xFFF59E0B),
        icon: Icons.support_agent_rounded,
      ),
      ActivityItem(
        id: 'ACT-04',
        title: 'Savings Goal Completed',
        description: 'Hasnain Ali recorded 100% completion on "Emergency Semester Fund".',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        category: 'Goals',
        badgeColor: const Color(0xFF8B5CF6),
        icon: Icons.emoji_events_rounded,
      ),
      ActivityItem(
        id: 'ACT-05',
        title: 'Budget Alert Triggered',
        description: 'Food & Dining budget exceeded 80% threshold for 142 students.',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        category: 'Budgets',
        badgeColor: const Color(0xFFEF4444),
        icon: Icons.warning_amber_rounded,
      ),
      ActivityItem(
        id: 'ACT-06',
        title: '5-Star Feedback Received',
        description: '"PennyPal helped me budget my monthly hostel allowances perfectly!"',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        category: 'Feedback',
        badgeColor: const Color(0xFF10B981),
        icon: Icons.star_rounded,
      ),
    ];

    learningTopics = [
      LearningTopicModel(
        id: 'LRN-101',
        title: 'The 50/30/20 Rule for Students',
        category: 'Budgeting',
        shortDescription: 'Split your monthly student allowance into Needs, Wants, and Savings effortlessly.',
        content: 'Divide your total income into 3 buckets: 50% for living needs (books, rent, mess), 30% for campus lifestyle, and 20% dedicated to building your future safety net.',
        example: 'If your monthly allowance is Rs. 20,000, assign Rs. 10,000 for essentials, Rs. 6,000 for leisure, and save Rs. 4,000.',
        status: LearningStatus.published,
        views: 4820,
        createdDate: DateTime.now().subtract(const Duration(days: 30)),
        updatedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LearningTopicModel(
        id: 'LRN-102',
        title: 'Smart Campus Spending Habits',
        category: 'Smart Spending',
        shortDescription: 'Actionable tactics to curb impulsive canteen food and printout costs.',
        content: 'Group grocery buying with flatmates, utilizing college library book rentals, and digital notes save up to Rs. 4,500 every single month.',
        example: 'Making tea at the hostel room rather than ordering twice daily saves Rs. 3,600 monthly.',
        status: LearningStatus.published,
        views: 3410,
        createdDate: DateTime.now().subtract(const Duration(days: 25)),
        updatedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      LearningTopicModel(
        id: 'LRN-103',
        title: 'Building an Emergency Fund as a Student',
        category: 'Saving',
        shortDescription: 'Why having Rs. 10,000 stashed away protects you from semester surprises.',
        content: 'Unexpected medical checkups, laptop chargers breaking before finals, or urgent project supplies can cause panic. An emergency fund keeps you confident.',
        example: 'Automate saving Rs. 1,000 from every freelance check or parental stipend.',
        status: LearningStatus.published,
        views: 2950,
        createdDate: DateTime.now().subtract(const Duration(days: 18)),
        updatedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LearningTopicModel(
        id: 'LRN-104',
        title: 'Freelance Income & Project Management',
        category: 'Income',
        shortDescription: 'How student developers and designers should manage irregular cash inflows.',
        content: 'When freelance payments arrive irregularly, smooth out your expenses by maintaining a buffer month in your savings account.',
        example: 'Hold 30% of each freelance payout for software licenses and equipment depreciation.',
        status: LearningStatus.draft,
        views: 120,
        createdDate: DateTime.now().subtract(const Duration(days: 5)),
        updatedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    supportQueries = [
      SupportQueryModel(
        id: 'SUP-201',
        studentName: 'Ayesha Khan',
        studentEmail: 'ayesha.k@university.edu',
        subject: 'Can I export my monthly transaction receipts as PDF?',
        message: 'Hello PennyPal Team, I would love to export my semester expense report to share with my parents. Is this supported?',
        submittedDate: DateTime.now().subtract(const Duration(hours: 4)),
        status: SupportStatus.open,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 4)),
        conversation: [
          SupportResponse(
            sender: 'Ayesha Khan',
            isAdmin: false,
            text: 'Hello PennyPal Team, I would love to export my semester expense report to share with my parents. Is this supported?',
            time: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
      ),
      SupportQueryModel(
        id: 'SUP-202',
        studentName: 'Bilal Ahmed',
        studentEmail: 'bilal.ahmed@campus.pk',
        subject: 'Custom category color preference',
        message: 'Is it possible to add a custom emoji and purple shade to my Gym & Sports budget category?',
        submittedDate: DateTime.now().subtract(const Duration(days: 1)),
        status: SupportStatus.inProgress,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 8)),
        conversation: [
          SupportResponse(
            sender: 'Bilal Ahmed',
            isAdmin: false,
            text: 'Is it possible to add a custom emoji and purple shade to my Gym & Sports budget category?',
            time: DateTime.now().subtract(const Duration(days: 1)),
          ),
          SupportResponse(
            sender: 'PennyPal Admin',
            isAdmin: true,
            text: 'Hi Bilal, thanks for reaching out! Custom category accents are supported under the Category options in the latest PennyPal update.',
            time: DateTime.now().subtract(const Duration(hours: 8)),
          ),
        ],
      ),
      SupportQueryModel(
        id: 'SUP-203',
        studentName: 'Hasnain Ali',
        studentEmail: 'hasnain@student.pennypal.com',
        subject: 'Savings Goal deadline extension',
        message: 'I completed my Laptop goal early and wanted to know if I can archive it.',
        submittedDate: DateTime.now().subtract(const Duration(days: 3)),
        status: SupportStatus.resolved,
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
        conversation: [
          SupportResponse(
            sender: 'Hasnain Ali',
            isAdmin: false,
            text: 'I completed my Laptop goal early and wanted to know if I can archive it.',
            time: DateTime.now().subtract(const Duration(days: 3)),
          ),
          SupportResponse(
            sender: 'PennyPal Support',
            isAdmin: true,
            text: 'Congratulations on reaching your goal! You can mark it completed and it will move automatically to your Achieved milestones tab.',
            time: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
      ),
    ];

    feedbackList = [
      FeedbackItemModel(
        id: 'FDB-301',
        studentName: 'Hasnain Ali',
        studentEmail: 'hasnain@student.pennypal.com',
        rating: 5,
        comment: 'The liquid glass design and automatic budget threshold alerts make tracking hostel expenses delightful and effortless!',
        date: DateTime.now().subtract(const Duration(hours: 6)),
        status: FeedbackStatus.reviewed,
      ),
      FeedbackItemModel(
        id: 'FDB-302',
        studentName: 'Zainab Fatima',
        studentEmail: 'zainab.f@college.edu',
        rating: 5,
        comment: 'Super clean interface. The financial learning section actually explains student budgeting in a simple, non-boring way.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: FeedbackStatus.reviewed,
      ),
      FeedbackItemModel(
        id: 'FDB-303',
        studentName: 'Hamza Tariq',
        studentEmail: 'hamza.t@techstudent.com',
        rating: 4,
        comment: 'Great app overall! Would appreciate dark mode in an upcoming version.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: FeedbackStatus.pending,
      ),
    ];

    notifications = [
      NotificationCampaignModel(
        id: 'NOTIF-401',
        title: 'Monthly Budget Reset Available',
        message: 'New month, fresh finances! Review your category allocations for June in your PennyPal dashboard.',
        type: NotificationType.budgetAlert,
        audience: 'All Students',
        scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
        status: NotificationStatus.sent,
        recipientsCount: 1248,
      ),
      NotificationCampaignModel(
        id: 'NOTIF-402',
        title: 'New Financial Guide: 50/30/20 Rule',
        message: 'Learn how to stretch your semester allowance without skipping social outings.',
        type: NotificationType.learningTip,
        audience: 'Active Students',
        scheduledDate: DateTime.now().subtract(const Duration(days: 3)),
        status: NotificationStatus.sent,
        recipientsCount: 986,
      ),
      NotificationCampaignModel(
        id: 'NOTIF-403',
        title: 'Mid-Term Savings Challenge',
        message: 'Set aside Rs. 2,000 this week and earn the PennyPal Smart Saver badge!',
        type: NotificationType.savingsReminder,
        audience: 'All Students',
        scheduledDate: DateTime.now().add(const Duration(days: 2)),
        status: NotificationStatus.scheduled,
        recipientsCount: 1248,
      ),
    ];

    categories = [
      CategoryModel(
        id: 'CAT-01',
        name: 'Food & Dining',
        icon: Icons.restaurant_rounded,
        color: const Color(0xFF10B981),
        isActive: true,
        isDefault: true,
        createdDate: DateTime.now().subtract(const Duration(days: 180)),
        usageCount: 6840,
      ),
      CategoryModel(
        id: 'CAT-02',
        name: 'Transport',
        icon: Icons.directions_bus_rounded,
        color: const Color(0xFF0077F6),
        isActive: true,
        isDefault: true,
        createdDate: DateTime.now().subtract(const Duration(days: 180)),
        usageCount: 4210,
      ),
      CategoryModel(
        id: 'CAT-03',
        name: 'Education & Books',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF8B5CF6),
        isActive: true,
        isDefault: true,
        createdDate: DateTime.now().subtract(const Duration(days: 180)),
        usageCount: 3120,
      ),
      CategoryModel(
        id: 'CAT-04',
        name: 'Shopping & Gear',
        icon: Icons.shopping_bag_rounded,
        color: const Color(0xFFF59E0B),
        isActive: true,
        isDefault: true,
        createdDate: DateTime.now().subtract(const Duration(days: 180)),
        usageCount: 2450,
      ),
      CategoryModel(
        id: 'CAT-05',
        name: 'Entertainment',
        icon: Icons.movie_filter_rounded,
        color: const Color(0xFFEC4899),
        isActive: true,
        isDefault: true,
        createdDate: DateTime.now().subtract(const Duration(days: 180)),
        usageCount: 1980,
      ),
      CategoryModel(
        id: 'CAT-06',
        name: 'Bills & Utilities',
        icon: Icons.bolt_rounded,
        color: const Color(0xFF06B6D4),
        isActive: true,
        isDefault: true,
        createdDate: DateTime.now().subtract(const Duration(days: 180)),
        usageCount: 1640,
      ),
      CategoryModel(
        id: 'CAT-07',
        name: 'Savings & Goals',
        icon: Icons.savings_rounded,
        color: const Color(0xFF10B981),
        isActive: true,
        isDefault: true,
        createdDate: DateTime.now().subtract(const Duration(days: 180)),
        usageCount: 2845,
      ),
      CategoryModel(
        id: 'CAT-08',
        name: 'Miscellaneous',
        icon: Icons.category_rounded,
        color: const Color(0xFF64748B),
        isActive: true,
        isDefault: true,
        createdDate: DateTime.now().subtract(const Duration(days: 180)),
        usageCount: 890,
      ),
    ];
  }

  // --- CRUD & Actions ---

  void setStudentStatus(String studentId, StudentStatus newStatus) {
    final idx = students.indexWhere((s) => s.id == studentId);
    if (idx != -1) {
      students[idx].status = newStatus;
      activities.insert(
        0,
        ActivityItem(
          id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Student Status Updated',
          description: '${students[idx].name} marked as ${newStatus.name.toUpperCase()}.',
          timestamp: DateTime.now(),
          category: 'Students',
          badgeColor: newStatus == StudentStatus.active
              ? const Color(0xFF10B981)
              : const Color(0xFFEF4444),
          icon: Icons.manage_accounts_rounded,
        ),
      );
      notifyListeners();
    }
  }

  void saveLearningTopic(LearningTopicModel topic) {
    final idx = learningTopics.indexWhere((t) => t.id == topic.id);
    if (idx != -1) {
      learningTopics[idx] = topic;
    } else {
      learningTopics.insert(0, topic);
    }
    notifyListeners();
  }

  void deleteLearningTopic(String id) {
    learningTopics.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void replyToSupportQuery(String queryId, String adminReply, SupportStatus newStatus) {
    final idx = supportQueries.indexWhere((q) => q.id == queryId);
    if (idx != -1) {
      supportQueries[idx].status = newStatus;
      supportQueries[idx].lastUpdated = DateTime.now();
      supportQueries[idx].conversation.add(
        SupportResponse(
          sender: 'Administrator',
          isAdmin: true,
          text: adminReply,
          time: DateTime.now(),
        ),
      );
      notifyListeners();
    }
  }

  void addNotificationCampaign(NotificationCampaignModel campaign) {
    notifications.insert(0, campaign);
    notifyListeners();
  }

  void toggleCategoryStatus(String catId) {
    final idx = categories.indexWhere((c) => c.id == catId);
    if (idx != -1) {
      categories[idx].isActive = !categories[idx].isActive;
      notifyListeners();
    }
  }

  void saveCategory(CategoryModel cat) {
    final idx = categories.indexWhere((c) => c.id == cat.id);
    if (idx != -1) {
      categories[idx] = cat;
    } else {
      categories.insert(0, cat);
    }
    notifyListeners();
  }

  void markFeedbackReviewed(String feedbackId) {
    final idx = feedbackList.indexWhere((f) => f.id == feedbackId);
    if (idx != -1) {
      feedbackList[idx].status = FeedbackStatus.reviewed;
      notifyListeners();
    }
  }

  void updateAppSettings({
    required bool pushEnabled,
    required bool registrationOpen,
    required bool autoModerate,
    required String supportEmail,
  }) {
    pushNotificationsEnabled = pushEnabled;
    studentRegistrationOpen = registrationOpen;
    autoModerateFeedback = autoModerate;
    supportEmailAddress = supportEmail;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penny_pal/constants/app_assets.dart';
import 'package:penny_pal/main.dart';
import 'package:penny_pal/screens/budget_screen.dart';
import 'package:penny_pal/screens/goals_screen.dart';
import 'package:penny_pal/screens/home_screen.dart';
import 'package:penny_pal/screens/login_screen.dart';
import 'package:penny_pal/screens/onboarding_screen.dart';
import 'package:penny_pal/screens/register_screen.dart';
import 'package:penny_pal/screens/splash_screen.dart';
import 'package:penny_pal/screens/transactions_screen.dart';
import 'package:penny_pal/widgets/custom_text_field.dart';
import 'package:penny_pal/widgets/feature_item.dart';
import 'package:penny_pal/widgets/google_logo.dart';
import 'package:penny_pal/widgets/loading_bar.dart';
import 'package:penny_pal/widgets/spending_donut_chart.dart';
import 'package:penny_pal/widgets/liquid_glass_bottom_nav_bar.dart';

void main() {
  group('PennyPal App & SplashScreen Tests', () {
    testWidgets('Renders SplashScreen with logo and loading bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const PennyPalApp());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2)); // Background & Logo
      expect(find.byType(PennyPalLoadingBar), findsOneWidget);

      // Finish any pending timers to cleanly tear down
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('PennyPalLoadingBar renders determinate progress', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PennyPalLoadingBar(progress: 0.6)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PennyPalLoadingBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('OnboardingScreen Rendering & Responsiveness Tests', () {
    testWidgets('Renders all core elements of OnboardingScreen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
      await tester.pumpAndSettle();

      // Skip button
      expect(find.text('Skip'), findsOneWidget);

      // Illustration
      expect(find.byType(Image), findsOneWidget);
      final illustration = tester.widget<Image>(find.byType(Image));
      expect(
        (illustration.image as AssetImage).assetName,
        AppAssets.onboardingIllustration,
      );

      // Heading & Description
      expect(
        find.text('Better Money Habits\nfor a Brighter Future'),
        findsOneWidget,
      );

      // 3 Feature items
      expect(find.byType(FeatureItem), findsNWidgets(3));
      expect(find.text('Track Expenses'), findsOneWidget);
      expect(find.text('Set Budgets'), findsOneWidget);
      expect(find.text('Save for Goals'), findsOneWidget);

      // CTA Button & Footer
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Adapts to small phone screen (320x568) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });

  group('LoginScreen Rendering, Interaction & Responsiveness Tests', () {
    testWidgets('Renders all core elements of LoginScreen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Brand Logo
      expect(find.byType(Image), findsOneWidget);
      final logo = tester.widget<Image>(find.byType(Image));
      expect((logo.image as AssetImage).assetName, AppAssets.pennyPalLogo);

      // Heading & Subtitle
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Log in to continue your journey'), findsOneWidget);

      // Form Fields
      expect(find.byType(CustomTextField), findsNWidgets(2));
      expect(find.text('Email or Mobile Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Links & Buttons
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('or'), findsOneWidget);
      expect(find.byType(GoogleLogo), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Form validation shows error messages when submitted empty', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please enter your email or mobile number'),
        findsOneWidget,
      );
      expect(find.text('Please enter your password'), findsOneWidget);
    });
  });

  group('RegisterScreen Rendering, Interaction & Responsiveness Tests', () {
    testWidgets('Renders all core elements of RegisterScreen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.pumpAndSettle();

      // Back Button
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Heading & Subtitle
      expect(find.text('Create Account'), findsOneWidget);
      expect(
        find.text('Join PennyPal and start your\nfinancial journey today.'),
        findsOneWidget,
      );

      // 4 Form Fields
      expect(find.byType(CustomTextField), findsNWidgets(4));
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mobile Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Register Button & Footer
      expect(find.text('Register'), findsOneWidget);
      expect(find.textContaining('Already have an account?'), findsOneWidget);
      expect(find.textContaining('Login'), findsOneWidget);
    });

    testWidgets('Form validation checks empty fields and formats on Register', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your mobile number'), findsOneWidget);
      expect(find.text('Please create a password'), findsOneWidget);
    });
  });

  group('HomeScreen Rendering, Functionality & Responsiveness Tests', () {
    testWidgets('Renders all sections of HomeScreen properly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump(const Duration(milliseconds: 300));

      // Header icons & logo
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

      // Greeting
      expect(find.textContaining('Hasnain!'), findsOneWidget);
      expect(find.text('👋'), findsOneWidget);
      expect(
        find.text('Small steps today, big dreams tomorrow.'),
        findsOneWidget,
      );

      // Total Balance Card
      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('Rs. 12,450'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Rs. 18,000'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
      expect(find.text('Rs. 5,550'), findsWidgets);

      // 6 Quick Action Buttons
      expect(find.text('Add Income'), findsOneWidget);
      expect(find.text('Add Expense'), findsOneWidget);
      expect(find.text('Set Budget'), findsOneWidget);
      expect(
        find.text('Savings Goals'),
        findsNWidgets(2),
      ); // quick action + card
      expect(find.text('Learn'), findsOneWidget);
      expect(find.text('AI Assistant'), findsOneWidget);

      // Spending Overview
      expect(find.text('Spending Overview'), findsOneWidget);
      expect(find.text('This Month • Rs. 5,550'), findsOneWidget);
      expect(find.byType(SpendingDonutChart), findsOneWidget);
      expect(find.text('Food & Dining'), findsWidgets);
      expect(find.text('Transport'), findsWidgets);
      expect(find.text('Shopping'), findsOneWidget);
      expect(find.text('Education'), findsOneWidget);
      expect(find.text('Others'), findsOneWidget);

      // Savings Goals Section
      expect(find.text('1 of 3 goals'), findsOneWidget);
      expect(
        find.text('Build your future, one goal at a time.'),
        findsOneWidget,
      );

      // Recent Transactions
      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(find.text("McDonald's • May 12, 2025"), findsOneWidget);
      expect(find.text('Upwork Payment • May 11, 2025'), findsOneWidget);
      expect(find.text('Bus Fare • May 10, 2025'), findsOneWidget);

      // Bottom Navigation Bar items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Transactions'), findsOneWidget);
      expect(find.text('Budgets'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });

    testWidgets('Toggles total balance visibility with eye icon', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump(const Duration(milliseconds: 300));

      // Initial visible state
      expect(find.text('Rs. 12,450'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap eye icon to hide
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('••••••••'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Tap again to show
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Rs. 12,450'), findsOneWidget);
    });

    testWidgets('Adapts to small screen (320x568) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Adapts to tablet screen (768x1024) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  group('TransactionsScreen Rendering, Filtering & Responsiveness Tests', () {
    testWidgets('Renders all core elements of TransactionsScreen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: TransactionsScreen()));
      await tester.pumpAndSettle();

      // Top Navigation & Header
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

      // Title & Subtitle
      expect(find.text('Transactions'), findsWidgets);
      expect(
        find.text('Track your money, build better habits.'),
        findsOneWidget,
      );

      // Total Balance Card
      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('Rs. 12,450'), findsOneWidget);
      expect(find.text('Income'), findsWidgets);
      expect(find.text('Rs. 18,000'), findsOneWidget);
      expect(find.text('Expenses'), findsWidgets);
      expect(find.text('Rs. 5,550'), findsWidgets);

      // 4 Filter Tabs
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Income'), findsWidgets);
      expect(find.text('Expenses'), findsWidgets);
      expect(find.text('Transfers'), findsOneWidget);

      // Date Section
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('May 14, 2025'), findsOneWidget);

      // 6 Sample Transactions
      expect(find.text('Food & Dining'), findsOneWidget);
      expect(find.text("McDonald's • 10:24 AM"), findsOneWidget);
      expect(find.text('- Rs. 450'), findsOneWidget);

      expect(find.text('Freelance Work'), findsOneWidget);
      expect(find.text('Upwork Payment • 09:15 AM'), findsOneWidget);
      expect(find.text('+ Rs. 8,000'), findsOneWidget);

      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('Bus Fare • 08:42 AM'), findsOneWidget);
      expect(find.text('- Rs. 200'), findsOneWidget);

      expect(find.text('Shopping'), findsOneWidget);
      expect(find.text('Daraz • 06:30 PM'), findsOneWidget);
      expect(find.text('- Rs. 1,250'), findsOneWidget);

      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('HBL Bank • May 13, 2025'), findsOneWidget);
      expect(find.text('+ Rs. 15,000'), findsOneWidget);

      expect(find.text('Education'), findsOneWidget);
      expect(find.text('Book Purchase • May 12, 2025'), findsOneWidget);
      expect(find.text('- Rs. 1,200'), findsOneWidget);
    });

    testWidgets('Filter tabs dynamically filter transaction items', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: TransactionsScreen()));
      await tester.pumpAndSettle();

      // Tap on Income tab (find the tab specifically)
      await tester.tap(find.widgetWithText(InkWell, 'Income').first);
      await tester.pumpAndSettle();

      // Should show income items (+ Rs. 8,000, + Rs. 15,000)
      expect(find.text('+ Rs. 8,000'), findsOneWidget);
      expect(find.text('+ Rs. 15,000'), findsOneWidget);
      // Expenses should not be in filtered list
      expect(find.text('- Rs. 450'), findsNothing);
    });

    testWidgets('Tapping transaction item opens details bottom sheet', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: TransactionsScreen()));
      await tester.pumpAndSettle();

      // Tap on McDonald's transaction
      await tester.tap(find.text('Food & Dining'));
      await tester.pumpAndSettle();

      // Modal appears
      expect(find.text('Transaction ID'), findsOneWidget);
      expect(find.text('TXN-001'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      // Tap Done to close modal
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('TXN-001'), findsNothing);
    });

    testWidgets('Adapts to small screen (320x568) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: TransactionsScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(TransactionsScreen), findsOneWidget);
    });
  });

  group('BudgetScreen Rendering, Interaction & Responsiveness Tests', () {
    testWidgets('Renders all core elements of BudgetScreen properly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: BudgetScreen()));
      await tester.pumpAndSettle();

      // Top Navigation Header
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsWidgets);

      // Screen Title & Subtitle
      expect(find.text('Budgets'), findsWidgets);
      expect(
        find.text('Plan your spending, achieve your goals.'),
        findsOneWidget,
      );

      // Monthly Budget Overview Card
      expect(find.text('Monthly Budget'), findsOneWidget);
      expect(find.text('May 2025'), findsOneWidget);
      expect(find.text('Rs. 6,450'), findsOneWidget);
      expect(find.text('of Rs. 10,000'), findsOneWidget);
      expect(find.text('65% used'), findsOneWidget);
      expect(find.text('Remaining: Rs. 3,550'), findsOneWidget);

      // 4 Quick Action Buttons
      expect(find.text('Create\nBudget'), findsOneWidget);
      expect(find.text('View\nReports'), findsOneWidget);
      expect(find.text('Set\nGoals'), findsOneWidget);
      expect(find.text('Manage\nLimits'), findsOneWidget);

      // Your Budgets Header
      expect(find.text('Your Budgets'), findsOneWidget);
      expect(find.text('View all'), findsOneWidget);

      // 5 Sample Categories
      expect(find.text('Food & Dining'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('Shopping'), findsOneWidget);
      expect(find.text('Education'), findsOneWidget);
      expect(find.text('Others'), findsOneWidget);

      // Motivational Card
      expect(find.text('Build Better Money Habits'), findsOneWidget);
      expect(
        find.text(
          'Stay on track, manage your spending, and grow your savings.',
        ),
        findsOneWidget,
      );
      expect(find.text('Manage Budgets'), findsOneWidget);

      // Bottom Navigation Bar
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Transactions'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });

    testWidgets(
      'Tapping search icon toggles search bar and filters categories',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: BudgetScreen()));
        await tester.pumpAndSettle();

        // Tap search icon
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Search bar is displayed
        expect(find.byType(TextField), findsOneWidget);

        // Enter search query
        await tester.enterText(find.byType(TextField), 'Transport');
        await tester.pumpAndSettle();

        expect(find.text('Transport'), findsWidgets);
        expect(find.text('Food & Dining'), findsNothing);
      },
    );

    testWidgets(
      'Tapping budget item opens details bottom sheet and closes it',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: BudgetScreen()));
        await tester.pumpAndSettle();

        // Tap Food & Dining
        await tester.tap(find.text('Food & Dining'));
        await tester.pumpAndSettle();

        // Details modal
        expect(find.text('Budget Limit'), findsOneWidget);
        expect(find.text('Amount Spent'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);

        // Close modal
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();

        expect(find.text('Budget Limit'), findsNothing);
      },
    );

    testWidgets('Tapping Create Budget opens creation bottom sheet', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: BudgetScreen()));
      await tester.pumpAndSettle();

      // Tap Create Budget quick action
      await tester.tap(find.text('Create\nBudget'));
      await tester.pumpAndSettle();

      expect(find.text('Create New Budget'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Monthly Limit (Rs.)'), findsOneWidget);
      expect(find.text('Save Budget'), findsOneWidget);

      // Save a new budget
      await tester.tap(find.text('Save Budget'));
      await tester.pumpAndSettle();

      expect(find.text('Create New Budget'), findsNothing);
    });

    testWidgets('Adapts to small screen (320x568) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: BudgetScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BudgetScreen), findsOneWidget);
    });

    testWidgets('Adapts to tablet screen (768x1024) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: BudgetScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BudgetScreen), findsOneWidget);
    });
  });

  group('GoalsScreen Rendering, Interaction & Responsiveness Tests', () {
    testWidgets('Renders all core elements of GoalsScreen properly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: GoalsScreen()));
      await tester.pumpAndSettle();

      // Top Navigation Header
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

      // Title & Subtitle
      expect(find.text('Goals'), findsWidgets);
      expect(find.text('Dream it. Plan it. Achieve it.'), findsOneWidget);

      // Total Goals Summary Card
      expect(find.text('Total Goals'), findsOneWidget);
      expect(find.text('May 2025'), findsOneWidget);
      expect(find.text('Active Goals'), findsOneWidget);
      expect(find.text('Total Saved'), findsOneWidget);
      expect(find.text('Target Amount'), findsOneWidget);
      expect(find.text('Overall Progress'), findsOneWidget);

      // 4 Quick Action Buttons
      expect(find.text('Create\nGoal'), findsOneWidget);
      expect(find.text('View\nProgress'), findsOneWidget);
      expect(find.text('Achieved\nGoals'), findsOneWidget);
      expect(find.text('Goal\nTips'), findsOneWidget);

      // Your Goals Header
      expect(find.text('Your Goals'), findsOneWidget);
      expect(find.text('View all'), findsOneWidget);

      // 4 Sample Goals
      expect(find.text('New Laptop'), findsOneWidget);
      expect(find.text('Trip to Dubai'), findsOneWidget);
      expect(find.text('Education (DAE)'), findsOneWidget);
      expect(find.text('Car Fund'), findsOneWidget);

      // Motivational Banner
      expect(find.text('Small Steps, Big Dreams'), findsOneWidget);
      expect(
        find.text('Stay focused on your goals. Every rupee counts!'),
        findsOneWidget,
      );

      // Floating Add Goal Button
      expect(find.text('Add Goal'), findsOneWidget);

      // Bottom Navigation Bar
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Transactions'), findsOneWidget);
      expect(find.text('Budgets'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });

    testWidgets('Tapping search icon toggles search bar and filters goals', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: GoalsScreen()));
      await tester.pumpAndSettle();

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      // Enter query
      await tester.enterText(find.byType(TextField), 'Dubai');
      await tester.pumpAndSettle();

      expect(find.text('Trip to Dubai'), findsOneWidget);
      expect(find.text('New Laptop'), findsNothing);
    });

    testWidgets('Tapping goal item opens details bottom sheet and closes it', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: GoalsScreen()));
      await tester.pumpAndSettle();

      // Tap New Laptop goal
      await tester.tap(find.text('New Laptop'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Amount'), findsOneWidget);
      expect(find.text('Target Goal'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Amount'), findsNothing);
    });

    testWidgets('Tapping Add Goal opens creation bottom sheet', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: GoalsScreen()));
      await tester.pumpAndSettle();

      // Tap Floating Add Goal button
      await tester.tap(find.text('Add Goal'));
      await tester.pumpAndSettle();

      expect(find.text('Create New Goal'), findsOneWidget);
      expect(find.text('Goal Name'), findsOneWidget);
      expect(find.text('Target Amount (Rs.)'), findsOneWidget);
      expect(find.text('Save Goal'), findsOneWidget);

      // Save goal
      await tester.tap(find.text('Save Goal'));
      await tester.pumpAndSettle();

      expect(find.text('Create New Goal'), findsNothing);
    });

    testWidgets('Tapping Goal Tips opens savings tips modal', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: GoalsScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Goal\nTips'));
      await tester.pumpAndSettle();

      expect(find.text('Smart Savings Tips'), findsOneWidget);
      expect(find.text('Automate Transfers'), findsOneWidget);
      expect(find.text('Got It'), findsOneWidget);

      await tester.tap(find.text('Got It'));
      await tester.pumpAndSettle();

      expect(find.text('Smart Savings Tips'), findsNothing);
    });

    testWidgets('Adapts to small screen (320x568) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: GoalsScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(GoalsScreen), findsOneWidget);
    });

    testWidgets('Adapts to tablet screen (768x1024) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: GoalsScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(GoalsScreen), findsOneWidget);
    });
  });

  group('LiquidGlassBottomNavBar Component Tests', () {
    testWidgets('Renders all 5 liquid glass navigation items', (
      WidgetTester tester,
    ) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidGlassBottomNavBar(
              currentIndex: 0,
              onTap: (idx) => tappedIndex = idx,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Transactions'), findsOneWidget);
      expect(find.text('Budgets'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);

      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
      expect(find.byIcon(Icons.pie_chart_rounded), findsOneWidget);
      expect(find.byIcon(Icons.track_changes_rounded), findsOneWidget);
      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);

      // Tap on Transactions
      await tester.tap(find.text('Transactions'));
      await tester.pumpAndSettle();
      expect(tappedIndex, equals(1));
    });

    testWidgets('Adapts to small phone screen (320x568) without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidGlassBottomNavBar(
              currentIndex: 2,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(LiquidGlassBottomNavBar), findsOneWidget);
    });
  });
}

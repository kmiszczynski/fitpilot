import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import 'my_plan_screen.dart';
import 'exercise_list_screen.dart';
import 'user_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final AuthRepository _authRepository;
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    MyPlanScreen(),
    ExerciseListScreen(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(AuthRemoteDataSourceImpl());
  }

  Future<void> _logout() async {
    await _authRepository.logout();

    if (!mounted) return;

    context.go('/login');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'FitPilot';
      case 1:
        return 'Exercises';
      case 2:
        return 'Profile';
      default:
        return 'FitPilot';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'My Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted_outlined),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
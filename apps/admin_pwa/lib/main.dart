import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core/services/firebase_config.dart';
import 'package:shared_core/widgets/debug_overlay.dart';
import 'package:shared_core/services/debug_service.dart';
import 'core/theme.dart';
import 'widgets/navigation/admin_shell.dart';
import 'pages/overview/overview_page.dart';
import 'pages/registry/registry_page.dart';
import 'pages/finance/finance_page.dart';
import 'pages/comms/comms_page.dart';
import 'pages/system/system_page.dart';
import 'pages/system/sos_page.dart';
import 'services/auth_service.dart';
import 'dart:ui';
import 'package:provider/provider.dart' as legacy;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    return true;
  };

  try {
    await Firebase.initializeApp(
      options: FirebaseConfig.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e');
  }

  runApp(
    legacy.ChangeNotifierProvider(
      create: (_) => DebugService(),
      child: const ProviderScope(child: AdminApp()),
    ),
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading || authState.isRefreshing) return null;
      
      final user = authState.value;
      final bool isLoggingIn = state.uri.path == '/login';

      if (user == null) {
        return isLoggingIn ? null : '/login';
      }
      
      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const OverviewPage(),
          ),
          GoRoute(
            path: '/registry',
            builder: (context, state) => const RegistryPage(),
          ),
          GoRoute(
            path: '/finance',
            builder: (context, state) => const FinancePage(),
          ),
          GoRoute(
            path: '/comms',
            builder: (context, state) => const CommsPage(),
          ),
          GoRoute(
            path: '/system',
            builder: (context, state) => const SystemPage(),
          ),
          GoRoute(
            path: '/sos',
            builder: (context, state) => const SOSPage(),
          ),
        ],
      ),
    ],
  );
});

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'ESPY Governance Terminal',
      debugShowCheckedModeBanner: false,
      theme: EspyTheme.noirGovernanceTheme,
      routerConfig: router,
      builder: (context, child) => DebugOverlay(child: child!),
    );
  }
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: EspyTheme.noirGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_rounded, size: 80, color: EspyTheme.electricBlue),
              const SizedBox(height: 24),
              Text(
                'ESPY GOVERNANCE',
                style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'BLUE FLAME CONTROL HUB',
                style: EspyTheme.cinzelStyle.copyWith(fontSize: 12, color: EspyTheme.cyan, letterSpacing: 4),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () => auth.signInWithGoogle(),
                icon: const Icon(Icons.login),
                label: const Text('SIGN IN WITH GOOGLE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: EspyTheme.electricBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  textStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

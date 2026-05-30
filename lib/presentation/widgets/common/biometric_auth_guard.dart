import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/core/services/biometric_service.dart';
import 'package:nexusbrain/presentation/state/biometric_state.dart';

class BiometricAuthGuard extends ConsumerStatefulWidget {
  final Widget child;

  const BiometricAuthGuard({super.key, required this.child});

  @override
  ConsumerState<BiometricAuthGuard> createState() => _BiometricAuthGuardState();
}

class _BiometricAuthGuardState extends ConsumerState<BiometricAuthGuard> {
  bool _isAuthenticated = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isEnabled = ref.read(biometricStateProvider);
    if (!isEnabled) {
      if (mounted) {
        setState(() {
          _isAuthenticated = true;
          _isChecking = false;
        });
      }
      return;
    }

    final biometricService = ref.read(biometricServiceProvider);
    final isAvailable = await biometricService.isBiometricAvailable();

    if (!isAvailable) {
      if (mounted) {
        setState(() {
          _isAuthenticated = true;
          _isChecking = false;
        });
      }
      return;
    }

    _authenticate();
  }

  Future<void> _authenticate() async {
    final biometricService = ref.read(biometricServiceProvider);
    final success = await biometricService.authenticate();

    if (mounted) {
      setState(() {
        _isAuthenticated = success;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'App is locked',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint_rounded),
                label: const Text('Unlock with Biometrics'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}

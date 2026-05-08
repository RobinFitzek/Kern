import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_notifier.dart';
import '../theme/app_theme.dart';
import 'onboarding_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              // Icon/Illustration placeholder
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 60,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 48),
              
              const Text(
                'Welcome to Kern',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              const Text(
                'To give you personalized AI insights and a complete overview of your health, Kern needs access to your Health Connect data.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              if (syncState.status == SyncStatus.permissionDenied)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Permission was denied. Please open Android Settings -> Health Connect to grant access manually, then tap Continue.',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),

              ElevatedButton(
                onPressed: syncState.status == SyncStatus.checkingPermissions || syncState.status == SyncStatus.syncing
                  ? null
                  : () async {
                      HapticFeedback.lightImpact();
                      if (syncState.status == SyncStatus.idle) {
                        // First attempt - trigger initialize to ask for permissions
                        await ref.read(syncNotifierProvider.notifier).initialize();
                        
                        // Check state after initialize
                        final newState = ref.read(syncNotifierProvider);
                        if (newState.status == SyncStatus.done || newState.status == SyncStatus.error) {
                          ref.read(onboardingCompletedProvider.notifier).complete();
                        }
                      } else {
                        // User is forcing a continue (perhaps after manually fixing permissions)
                        await ref.read(syncNotifierProvider.notifier).resync();
                        final newState = ref.read(syncNotifierProvider);
                        if (newState.status == SyncStatus.done || newState.status == SyncStatus.error) {
                          ref.read(onboardingCompletedProvider.notifier).complete();
                        } else if (newState.status == SyncStatus.permissionDenied) {
                          // Allow them to skip if they really want to, or wait
                          // Let's just let them complete onboarding and go to dashboard
                          // The dashboard will show them as disconnected anyway
                          ref.read(onboardingCompletedProvider.notifier).complete();
                        }
                      }
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: syncState.status == SyncStatus.checkingPermissions || syncState.status == SyncStatus.syncing
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Connect Health Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(onboardingCompletedProvider.notifier).complete();
                },
                child: const Text(
                  'Skip for now',
                  style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

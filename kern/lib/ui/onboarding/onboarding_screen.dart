import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_notifier.dart';
import '../theme/app_theme.dart';
import 'onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _connecting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _connectHealth(WidgetRef ref) async {
    if (_connecting) return;
    setState(() => _connecting = true);
    HapticFeedback.lightImpact();

    final syncNotifier = ref.read(syncNotifierProvider.notifier);
    final syncState = ref.read(syncNotifierProvider);

    if (syncState.status == SyncStatus.idle) {
      await syncNotifier.initialize();
      final newState = ref.read(syncNotifierProvider);
      if (newState.status == SyncStatus.done || newState.status == SyncStatus.error) {
        if (mounted) ref.read(onboardingCompletedProvider.notifier).complete();
        return;
      }
    } else {
      await syncNotifier.resync();
      final newState = ref.read(syncNotifierProvider);
      if (newState.status == SyncStatus.done || newState.status == SyncStatus.error) {
        if (mounted) ref.read(onboardingCompletedProvider.notifier).complete();
        return;
      }
      if (newState.status == SyncStatus.permissionDenied) {
        if (mounted) ref.read(onboardingCompletedProvider.notifier).complete();
        return;
      }
    }

    if (mounted) setState(() => _connecting = false);
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: () => ref.read(onboardingCompletedProvider.notifier).complete(),
                  child: Text(
                    'Überspringen',
                    style: TextStyle(color: isDark ? Colors.white54 : Colors.black38),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildWelcomePage(isDark),
                  _buildReadinessPage(isDark),
                  _buildAiPage(isDark),
                  _buildConnectPage(isDark),
                ],
              ),
            ),

            // Bottom: dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  // Page dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) => _buildDot(i, isDark)),
                  ),
                  const SizedBox(height: 24),

                  // Action button
                  if (_currentPage < 3)
                    _buildButton(
                      label: 'Weiter',
                      icon: Icons.arrow_forward_rounded,
                      onTap: _nextPage,
                      isDark: isDark,
                    )
                  else
                    Consumer(builder: (context, ref, _) {
                      final syncState = ref.watch(syncNotifierProvider);
                      final isSyncing = syncState.status == SyncStatus.syncing ||
                          syncState.status == SyncStatus.checkingPermissions;
                      final isDenied = syncState.status == SyncStatus.permissionDenied;

                      return Column(
                        children: [
                          _buildButton(
                            label: isSyncing ? 'Verbinde...' : 'Health Connect verbinden',
                            icon: isSyncing ? Icons.sync_rounded : Icons.favorite_rounded,
                            onTap: isSyncing ? null : () => _connectHealth(ref),
                            isDark: isDark,
                            isLoading: isSyncing,
                          ),
                          if (isDenied) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Berechtigung fehlt. Bitte in den Android-Einstellungen\nHealth Connect Zugriff erlauben.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.red.shade300 : Colors.red),
                            ),
                          ],
                        ],
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A237E) : AppTheme.primaryBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Center(
              child: Text('K', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Willkommen bei Kern',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Dein persönlicher Gesundheitscoach.\nWeniger Daten, mehr Intelligenz.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReadinessPage(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.bolt_rounded, size: 56, color: AppTheme.textMint),
          ),
          const SizedBox(height: 40),
          Text(
            'Eine Zahl sagt alles',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Kern analysiert deine HRV, Ruhepuls, Schlafqualität und Belastung — '
            'und gibt dir jeden Morgen einen Readiness Score von 0–100.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D2215) : AppTheme.accentMint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, color: AppTheme.textMint, size: 16),
                SizedBox(width: 8),
                Text(
                  'Alles passiert lokal auf deinem Gerät',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMint, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiPage(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome_rounded, size: 56, color: Color(0xFF673AB7)),
          ),
          const SizedBox(height: 40),
          Text(
            'KI-Coach an deiner Seite',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Jeden Morgen erhältst du eine personalisierte Empfehlung — '
            'basierend auf deinen Daten. Kein Chatbot, sondern eine klare, '
            'umsetzbare Einsicht.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2744) : AppTheme.accentBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.key_rounded, color: AppTheme.textBlue, size: 16),
                SizedBox(width: 8),
                Text(
                  'Gemini API-Key in den Einstellungen erforderlich',
                  style: TextStyle(fontSize: 13, color: AppTheme.textBlue, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectPage(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.favorite_rounded, size: 56, color: AppTheme.primaryBlue),
          ),
          const SizedBox(height: 40),
          Text(
            'Daten verbinden',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Kern liest deine Gesundheitsdaten über Health Connect.\n'
            'HRV, Schlaf, Ruhepuls und Schritte — alles andere bleibt privat.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2200) : AppTheme.accentOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_top_rounded, color: AppTheme.textOrange, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Deine ersten Scores erscheinen nach 7–14 Tagen',
                    style: TextStyle(fontSize: 13, color: AppTheme.textOrange, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, bool isDark) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryBlue
            : (isDark ? Colors.white24 : Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDark,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white70,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}

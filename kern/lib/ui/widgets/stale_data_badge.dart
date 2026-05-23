import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_notifier.dart';
import '../theme/app_theme.dart';

class StaleDataBadge extends ConsumerWidget {
  const StaleDataBadge({
    super.key,
    required this.child,
    this.staleThreshold = const Duration(hours: 4),
    this.showDetail = true,
  });

  final Widget child;
  final Duration staleThreshold;
  final bool showDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);
    final lastSync = syncState.lastSyncTime;
    final now = DateTime.now();

    if (lastSync == null) return child;

    final age = now.difference(lastSync);
    final isStale = age > staleThreshold;
    final isVeryStale = age > const Duration(hours: 12);

    if (!isStale) return child;

    final Color badgeColor;
    final String label;
    final IconData badgeIcon;

    if (isVeryStale) {
      badgeColor = AppTheme.textPink;
      label = showDetail ? _formatAge(age) : 'Veraltet';
      badgeIcon = Icons.warning_amber_rounded;
    } else {
      badgeColor = AppTheme.textOrange;
      label = showDetail ? _formatAge(age) : 'Veraltet';
      badgeIcon = Icons.access_time_rounded;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => ref.read(syncNotifierProvider.notifier).resync(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: badgeColor.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(badgeIcon, size: 10, color: badgeColor),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatAge(Duration age) {
    if (age.inHours < 1) return '${age.inMinutes}m';
    if (age.inHours < 24) return '${age.inHours}h';
    return '${age.inDays}d';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

enum ErrorDisplayType {
  noData,
  error,
  permissionDenied,
  calibrating,
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.type,
    this.message,
    this.icon,
    this.onRetry,
    this.onOpenSettings,
  });

  final ErrorDisplayType type;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;

  Color _accentColor(bool isDark) {
    switch (type) {
      case ErrorDisplayType.noData:
      case ErrorDisplayType.calibrating:
        return AppTheme.textTertiary;
      case ErrorDisplayType.error:
        return AppTheme.textPink;
      case ErrorDisplayType.permissionDenied:
        return AppTheme.textOrange;
    }
  }

  Color _bgColor(bool isDark) {
    switch (type) {
      case ErrorDisplayType.noData:
        return isDark ? const Color(0xFF1E1E1E) : Colors.white;
      case ErrorDisplayType.error:
        return isDark ? const Color(0xFF3C0D0D) : AppTheme.accentPink;
      case ErrorDisplayType.permissionDenied:
        return isDark ? const Color(0xFF3A2C00) : AppTheme.accentOrange;
      case ErrorDisplayType.calibrating:
        return isDark ? const Color(0xFF1E1E1E) : AppTheme.accentMint;
    }
  }

  IconData _defaultIcon() {
    switch (type) {
      case ErrorDisplayType.noData:
        return Icons.inbox_rounded;
      case ErrorDisplayType.error:
        return Icons.error_outline_rounded;
      case ErrorDisplayType.permissionDenied:
        return Icons.lock_rounded;
      case ErrorDisplayType.calibrating:
        return Icons.hourglass_top_rounded;
    }
  }

  String _defaultMessage() {
    switch (type) {
      case ErrorDisplayType.noData:
        return 'Keine Daten vorhanden';
      case ErrorDisplayType.error:
        return 'Ein Fehler ist aufgetreten';
      case ErrorDisplayType.permissionDenied:
        return 'Health Connect Berechtigung fehlt';
      case ErrorDisplayType.calibrating:
        return 'Baseline wird aufgebaut';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _accentColor(isDark);
    final displayIcon = icon ?? _defaultIcon();
    final displayMessage = message ?? _defaultMessage();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bgColor(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(displayIcon, color: color, size: 36),
          const SizedBox(height: 12),
          Text(
            displayMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          if (onRetry != null || onOpenSettings != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onRetry != null)
                  _ActionChip(
                    label: 'Erneut versuchen',
                    icon: Icons.refresh_rounded,
                    color: color,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onRetry!.call();
                    },
                  ),
                if (onRetry != null && onOpenSettings != null)
                  const SizedBox(width: 8),
                if (onOpenSettings != null)
                  _ActionChip(
                    label: 'Einstellungen',
                    icon: Icons.settings_rounded,
                    color: color,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onOpenSettings!.call();
                    },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

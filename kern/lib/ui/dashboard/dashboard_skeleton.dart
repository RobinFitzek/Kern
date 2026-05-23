import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withValues(alpha: 0.05),
      highlightColor: Colors.black.withValues(alpha: 0.02),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Status bar chip
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 28,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main zone (Readiness rings or calibration banner)
          Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          ),
          const SizedBox(height: 24),

          // Insight row (Sleep + Strain side by side)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recommendation card
          Container(
            height: 130,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          ),
          const SizedBox(height: 32),

          // Trend chart
          Row(
            children: [
              Container(width: 80, height: 18, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 180,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          ),
        ],
      ),
    );
  }
}

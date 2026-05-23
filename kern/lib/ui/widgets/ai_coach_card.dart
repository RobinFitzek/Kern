import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../plugins/derived/derived_providers.dart';
import '../theme/app_theme.dart';
import '../../plugins/ai/ai_coach_service.dart';

class AiCoachCard extends ConsumerStatefulWidget {
  const AiCoachCard({super.key});

  @override
  ConsumerState<AiCoachCard> createState() => _AiCoachCardState();
}

enum _Phase { loading, greeting, waitingForAdvice, advice, noKey, error }

class _AiCoachCardState extends ConsumerState<AiCoachCard>
    with SingleTickerProviderStateMixin {
  final AiCoachService _service = AiCoachService();
  AiCoachResponse? _greeting;
  String? _advice;
  String? _selectedOption;
  _Phase _phase = _Phase.loading;
  AiCoachContext? _context;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _loadGreeting();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadGreeting() async {
    _context = await _buildContext();
    if (_context == null) return;

    try {
      final greeting = await _service.generateGreeting(_context!);
      if (!mounted) return;
      if (greeting == null || greeting.options.isEmpty) {
        setState(() => _phase = _Phase.noKey);
        return;
      }
      setState(() {
        _greeting = greeting;
        _phase = _Phase.greeting;
      });
    } catch (e) {
      if (mounted) setState(() => _phase = _Phase.error);
    }
  }

  Future<AiCoachContext?> _buildContext() async {
    try {
      final physComp = await ref.read(readinessPhysicalComponentsProvider().future);
      final mentComp = await ref.read(readinessMentalComponentsProvider().future);
      final sleepScore = await ref.read(sleepScoreProvider().future);
      final sleepMins = await ref.read(sleepMinutesProvider().future);
      final strainScore = await ref.read(strainScoreProvider().future);
      final physScore = await ref.read(readinessPhysicalScoreProvider().future);
      final mentScore = await ref.read(readinessMentalScoreProvider().future);
      final acwr = await ref.read(readinessAcwrProvider().future);
      final sri = await ref.read(readinessSriProvider().future);
      final cal = await ref.read(readinessIsCalibratingProvider().future);
      final stepsY = await ref.read(strainStepsYesterdayProvider().future);
      final stepsA = await ref.read(strainSteps7dAvgProvider().future);
      final trend = await ref.read(historicalReadinessScoresProvider(days: 7).future);

      final trendScores = trend
          .where((t) => t.physical != null)
          .map((t) => t.physical!)
          .toList();

      return AiCoachContext(
        date: _todayString(),
        physicalScore: physScore,
        mentalScore: mentScore,
        hrvMs: physComp?['today_hrv_ms'],
        hrvScore: physComp?['hrv_score'],
        restingHrBpm: physComp?['today_rhr_bpm'],
        rhrScore: physComp?['rhr_score'],
        deepSleepMins: physComp?['today_deep_min'] ?? sleepMins.deep,
        remSleepMins: mentComp?['today_rem_min'] ?? sleepMins.rem,
        lightSleepMins: sleepMins.light,
        totalSleepMins: sleepMins.total,
        sleepQualityScore: sleepScore,
        sleepEfficiencyPct: mentComp?['today_efficiency_pct'],
        sriValue: sri,
        hrvCvScore: mentComp?['cv_score'],
        strainScore: strainScore,
        stepsYesterday: stepsY,
        steps7dAvg: stepsA,
        acwrValue: acwr,
        acwrPenalty: physComp?['acwr_penalty'],
        isCalibrating: cal,
        recentReadinessTrend: trendScores,
      );
    } catch (e) {
      return null;
    }
  }

  String _todayString() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectOption(String option) async {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedOption = option;
      _phase = _Phase.waitingForAdvice;
    });

    if (_context == null) {
      setState(() => _phase = _Phase.error);
      return;
    }

    try {
      final advice = await _service.generateAdvice(
        context: _context!,
        userAnswer: option,
      );
      if (!mounted) return;
      setState(() {
        _advice = advice ?? 'Basiere auf deinen Daten empfehle ich dir heute einen ausgewogenen Tag mit moderater Belastung und ausreichend Erholung.';
        _phase = _Phase.advice;
      });
    } catch (e) {
      if (mounted) setState(() => _phase = _Phase.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeIn,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF673AB7).withValues(alpha: isDark ? 0.3 : 0.12),
              const Color(0xFF9C27B0).withValues(alpha: isDark ? 0.09 : 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF673AB7).withValues(alpha: 0.25),
          ),
        ),
        child: _buildContent(isDark),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    switch (_phase) {
      case _Phase.loading:
        return _buildLoading(isDark);
      case _Phase.greeting:
        return _buildGreeting(isDark);
      case _Phase.waitingForAdvice:
        return _buildThinking(isDark);
      case _Phase.advice:
        return _buildAdviceColumn(isDark);
      case _Phase.noKey:
        return _buildNoKey(isDark);
      case _Phase.error:
        return _buildError(isDark);
    }
  }

  Widget _buildLoading(bool isDark) {
    return const Center(
      child: SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildGreeting(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isDark),
        const SizedBox(height: 10),
        if (_greeting!.observation.isNotEmpty)
          Text(
            _greeting!.observation,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        if (_greeting!.question.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF673AB7).withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.chat_bubble_rounded, color: Color(0xFF673AB7), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _greeting!.question,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _greeting!.options.map((option) {
            return _OptionChip(
              label: option,
              onTap: () => _selectOption(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildThinking(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isDark),
        const SizedBox(height: 10),
        if (_greeting?.observation.isNotEmpty == true)
          Text(
            _greeting!.observation,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        if (_greeting?.question.isNotEmpty == true) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF673AB7).withValues(alpha: isDark ? 0.1 : 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.chat_bubble_rounded, color: Color(0xFF673AB7), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _greeting!.question,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF673AB7).withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF673AB7).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '"${_selectedOption ?? ''}"',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF673AB7),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF673AB7)),
              ),
              const SizedBox(width: 8),
              const Text(
                'Analysiere...',
                style: TextStyle(fontSize: 13, color: Color(0xFF673AB7)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdviceColumn(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isDark, done: true),
        const SizedBox(height: 10),
        // Show the conversation summary (collapsed)
        if (_greeting != null && _selectedOption != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F0FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting!.observation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF673AB7)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${_greeting!.question} → "${_selectedOption}"',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        // The advice
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF673AB7).withValues(alpha: isDark ? 0.3 : 0.18),
                const Color(0xFF9C27B0).withValues(alpha: isDark ? 0.12 : 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _advice ?? '',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoKey(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isDark),
        const SizedBox(height: 12),
        Text(
          'Konfiguriere deinen Gemini API-Key in den KI-Coach-Einstellungen, '
          'um personalisierte tägliche Empfehlungen zu erhalten.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildError(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isDark),
        const SizedBox(height: 12),
        Text(
          'Konnte keine Empfehlung generieren. Versuche es später erneut.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white38 : AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark, {bool done = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF673AB7).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            done ? Icons.check_circle_rounded : Icons.auto_awesome_rounded,
            color: done ? AppTheme.textMint : const Color(0xFF673AB7),
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          done ? 'KI-Coach' : 'KI-Coach',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF673AB7),
          ),
        ),
        const Spacer(),
        if (done)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.textMint.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Erledigt',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textMint),
            ),
          ),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF673AB7).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF673AB7).withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF673AB7),
          ),
        ),
      ),
    );
  }
}

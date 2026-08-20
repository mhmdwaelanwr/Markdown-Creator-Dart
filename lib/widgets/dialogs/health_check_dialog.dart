import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/project_provider.dart';
import '../../services/health_check_service.dart';
import '../../services/ai_service.dart';
import '../../utils/dialog_helper.dart';
import '../../core/constants/app_colors.dart';

class HealthCheckDialog extends StatefulWidget {
  final List<HealthIssue> issues;
  final ProjectProvider provider;

  const HealthCheckDialog({
    super.key,
    required this.issues,
    required this.provider,
  });

  @override
  State<HealthCheckDialog> createState() => _HealthCheckDialogState();
}

class _HealthCheckDialogState extends State<HealthCheckDialog> {
  String? _aiFeedback;
  bool _isAnalyzingAI = false;

  @override
  void initState() {
    super.initState();
    if (widget.provider.geminiApiKey.trim().isNotEmpty) {
      _triggerAIAnalysis();
    }
  }

  Future<void> _triggerAIAnalysis() async {
    final apiKey = widget.provider.geminiApiKey.trim();
    if (apiKey.isEmpty) return;

    setState(() => _isAnalyzingAI = true);
    try {
      final feedback = await AIService.improveText(
        "Audit this README structure and give 3 professional tips: ${widget.provider.elements.map((e) => e.description).join(', ')}",
        apiKey: apiKey
      );
      if (mounted) setState(() => _aiFeedback = feedback);
    } catch (e) {
      debugPrint('AI Health Check ignored (Offline or Invalid Key)');
    } finally {
      if (mounted) setState(() => _isAnalyzingAI = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = HealthCheckService.calculateDocumentationScore(widget.provider.elements);
    final hasAI = widget.provider.geminiApiKey.trim().isNotEmpty;
    final l10n = AppLocalizations.of(context)!;

    return StyledDialog(
      title: DialogHeader(
        title: l10n.projectHealthCenter,
        icon: Icons.health_and_safety_rounded,
        color: AppColors.primary,
      ),
      width: 600,
      height: 650,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreHeader(score),
            const SizedBox(height: 20),
            if (hasAI) ...[
              _buildAIInsightsCard(),
              const SizedBox(height: 24),
            ],
            _buildSectionTitle(l10n.structuralAudit),
            const SizedBox(height: 12),
            if (widget.issues.isEmpty) 
              _buildCleanState() 
            else 
              ...widget.issues.map((i) => _buildIssueItem(context, i)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.closeBtn, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildScoreHeader(double score) {
    final color = score > 80 ? Colors.green : (score > 50 ? Colors.orange : Colors.redAccent);
    final l10n = AppLocalizations.of(context)!;
    return GlassCard(
      opacity: 0.1,
      color: color,
      borderRadius: 20,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50, height: 50,
                child: CircularProgressIndicator(value: score / 100, strokeWidth: 6, color: color, backgroundColor: color.withAlpha(30)),
              ),
              Text('${score.toInt()}%', style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 13)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(score > 80 ? l10n.eliteDocumentation : l10n.optimizationRequired, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 17)),
                Text(l10n.scoreBasedOnGitHub, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightsCard() {
    final l10n = AppLocalizations.of(context)!;
    return GlassCard(
      opacity: 0.1,
      color: Colors.purple,
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_rounded, color: Colors.purpleAccent, size: 22),
              const SizedBox(width: 10),
              Text(l10n.aiStrategicAudit, style: GoogleFonts.poppins(fontWeight: FontWeight.w900, color: Colors.purpleAccent, fontSize: 12, letterSpacing: 1.2)),
              const Spacer(),
              if (_isAnalyzingAI) const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.purpleAccent)),
            ],
          ),
          const SizedBox(height: 12),
          if (_aiFeedback != null)
            Text(_aiFeedback!, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey, height: 1.6))
          else if (!_isAnalyzingAI)
            Text(l10n.aiAnalysisFailed, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildIssueItem(BuildContext context, HealthIssue issue) {
    final color = issue.severity == IssueSeverity.error ? Colors.redAccent : Colors.orange;
    return GlassCard(
      padding: EdgeInsets.zero,
      color: color,
      child: ListTile(
        leading: Icon(issue.severity == IssueSeverity.error ? Icons.error_outline_rounded : Icons.info_outline_rounded, color: color),
        title: Text(issue.message, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: issue.suggestion != null ? Text(issue.suggestion!, style: const TextStyle(fontSize: 12)) : null,
        onTap: issue.elementId != null ? () {
          widget.provider.selectElement(issue.elementId!);
          Navigator.pop(context);
        } : null,
      ),
    );
  }

  Widget _buildCleanState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded, size: 48, color: Colors.green),
            const SizedBox(height: 16),
            Text(l10n.allChecksPassed, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(text, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5));
  }
}

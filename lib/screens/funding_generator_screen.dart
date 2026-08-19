import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import '../l10n/app_localizations.dart';

class FundingGeneratorScreen extends StatefulWidget {
  const FundingGeneratorScreen({super.key});

  @override
  State<FundingGeneratorScreen> createState() => _FundingGeneratorScreenState();
}

class _FundingGeneratorScreenState extends State<FundingGeneratorScreen> {
  // Platforms
  String _github = '';
  String _patreon = '';
  String _openCollective = '';
  String _koFi = '';
  String _tidelift = '';
  String _communityBridge = '';
  String _liberapay = '';
  String _issuehunt = '';
  final List<String> _custom = [];
  final TextEditingController _customController = TextEditingController();

  String _generateYaml() {
    final buffer = StringBuffer();
    // buffer.writeln('# These are supported funding model platforms');

    if (_github.isNotEmpty) {
      // Can be list or single. Assuming single for simplicity or comma separated.
      // GitHub docs say: [user1, user2]
      if (_github.contains(',')) {
        buffer.writeln('github: [$_github]');
      } else {
        buffer.writeln('github: $_github');
      }
    }
    if (_patreon.isNotEmpty) buffer.writeln('patreon: $_patreon');
    if (_openCollective.isNotEmpty) buffer.writeln('open_collective: $_openCollective');
    if (_koFi.isNotEmpty) buffer.writeln('ko_fi: $_koFi');
    if (_tidelift.isNotEmpty) buffer.writeln('tidelift: $_tidelift');
    if (_communityBridge.isNotEmpty) buffer.writeln('community_bridge: $_communityBridge');
    if (_liberapay.isNotEmpty) buffer.writeln('liberapay: $_liberapay');
    if (_issuehunt.isNotEmpty) buffer.writeln('issuehunt: $_issuehunt');

    if (_custom.isNotEmpty) {
       buffer.write('custom: [');
       for (int i = 0; i < _custom.length; i++) {
         buffer.write(_custom[i]);
         if (i < _custom.length - 1) buffer.write(', ');
       }
       buffer.writeln(']');
    }

    return buffer.toString();
  }

  void _addCustomLink() {
    if (_customController.text.isNotEmpty) {
      setState(() {
        _custom.add(_customController.text);
        _customController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final code = _generateYaml();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fundingGeneratorTitle, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: l10n.copyYaml,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.copiedToClipboardShort)));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Inputs
          Expanded(
            flex: 3,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  l10n.sponsorships,
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.sponsorshipsDesc,
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(l10n.supportedPlatforms),
                _buildTextField(l10n.githubUsernames, 'e.g. users (comma separated)', (val) => setState(() => _github = val)),
                _buildTextField(l10n.patreonUsername, 'e.g. user', (val) => setState(() => _patreon = val)),
                _buildTextField(l10n.openCollective, 'e.g. project', (val) => setState(() => _openCollective = val)),
                _buildTextField(l10n.kofiUsername, 'e.g. user', (val) => setState(() => _koFi = val)),
                _buildTextField(l10n.tidelift, 'e.g. platform/package', (val) => setState(() => _tidelift = val)),
                _buildTextField(l10n.communityBridge, 'e.g. cloud-foundry', (val) => setState(() => _communityBridge = val)),
                _buildTextField(l10n.liberapay, 'e.g. user', (val) => setState(() => _liberapay = val)),
                _buildTextField(l10n.issueHunt, 'e.g. user', (val) => setState(() => _issuehunt = val)),

                const SizedBox(height: 24),
                _buildSectionTitle(l10n.customLinks),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customController,
                        decoration: InputDecoration(
                          labelText: l10n.customUrl,
                          hintText: 'https://paypal.me/user',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addCustomLink(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(icon: const Icon(Icons.add_circle, color: Colors.blue, size: 32), onPressed: _addCustomLink),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _custom.map((link) => Chip(
                    label: Text(link),
                    onDeleted: () {
                      setState(() {
                         _custom.remove(link);
                      });
                    },
                  )).toList(),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Preview
          Expanded(
            flex: 2,
            child: Container(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF6F8FA),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.withAlpha(50))),
                    ),
                    child: Text(l10n.fundingYamlPreview, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: HighlightView(
                        code,
                        language: 'yaml',
                        theme: isDark ? draculaTheme : githubTheme,
                        padding: const EdgeInsets.all(16),
                        textStyle: GoogleFonts.firaCode(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }
}


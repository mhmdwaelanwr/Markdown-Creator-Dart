import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/project_provider.dart';
import '../../utils/debouncer.dart';
import '../../utils/dialog_helper.dart';
import 'confirm_dialog.dart';

class ProjectSettingsDialog extends StatefulWidget {
  const ProjectSettingsDialog({super.key});

  @override
  State<ProjectSettingsDialog> createState() => _ProjectSettingsDialogState();
}

class _ProjectSettingsDialogState extends State<ProjectSettingsDialog> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return StyledDialog(
      title: DialogHeader(
        title: l10n.projectSettings,
        icon: Icons.tune_rounded,
        color: AppColors.primary,
      ),
      contentPadding: EdgeInsets.zero,
      width: 650,
      height: 650,
      content: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  dividerColor: Colors.transparent,
                  labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: [
                    Tab(text: l10n.variables),
                    Tab(text: l10n.license),
                    Tab(text: l10n.community),
                    Tab(text: l10n.colors),
                    Tab(text: l10n.formatting),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildVariablesTab(provider, l10n),
                  _buildLicenseTab(provider, l10n),
                  _buildCommunityTab(provider, l10n),
                  _buildColorsTab(provider, l10n),
                  _buildFormattingTab(provider, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildVariablesTab(ProjectProvider provider, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(l10n.variables.toUpperCase()),
          const SizedBox(height: 16),
          ...provider.variables.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildTextField(
                label: entry.key,
                initialValue: entry.value,
                icon: Icons.label_important_outline_rounded,
                onChanged: (value) {
                  _debouncer.run(() {
                    provider.updateVariable(entry.key, value);
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLicenseTab(ProjectProvider provider, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(l10n.license.toUpperCase()),
          const SizedBox(height: 16),
          GlassCard(
            opacity: 0.1,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: provider.licenseType,
                  decoration: InputDecoration(
                    labelText: l10n.selectLicense,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: [
                    'None', 'MIT', 'Apache 2.0', 'GPLv3', 'BSD 3-Clause'
                  ].map((val) => DropdownMenuItem(value: val, child: Text(val, style: GoogleFonts.inter()))).toList(),
                  onChanged: (value) {
                    if (value != null) provider.setLicenseType(value);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.licenseInfo,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityTab(ProjectProvider provider, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionTitle(l10n.communityStandards.toUpperCase()),
        const SizedBox(height: 16),
        _buildSwitchTile('CONTRIBUTING.md', l10n.contributingDesc, provider.includeContributing, (v) => provider.setIncludeContributing(v), Icons.handshake_rounded),
        _buildSwitchTile('SECURITY.md', l10n.securityDesc, provider.includeSecurity, (v) => provider.setIncludeSecurity(v), Icons.security_rounded),
        _buildSwitchTile('SUPPORT.md', l10n.supportDesc, provider.includeSupport, (v) => provider.setIncludeSupport(v), Icons.help_outline_rounded),
        _buildSwitchTile('CODE_OF_CONDUCT.md', l10n.cocDesc, provider.includeCodeOfConduct, (v) => provider.setIncludeCodeOfConduct(v), Icons.gavel_rounded),
        _buildSwitchTile(l10n.issueTemplates, l10n.issueTemplatesDesc, provider.includeIssueTemplates, (v) => provider.setIncludeIssueTemplates(v), Icons.bug_report_rounded),
      ],
    );
  }

  Widget _buildColorsTab(ProjectProvider provider, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionTitle(l10n.colors.toUpperCase()),
        const SizedBox(height: 16),
        _buildColorTile(l10n.primaryColor, provider.primaryColor, (c) => provider.setPrimaryColor(c), l10n),
        _buildColorTile(l10n.secondaryColor, provider.secondaryColor, (c) => provider.setSecondaryColor(c), l10n),
      ],
    );
  }

  Widget _buildFormattingTab(ProjectProvider provider, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionTitle(l10n.formatting.toUpperCase()),
        const SizedBox(height: 16),
        _buildSwitchTile(l10n.exportHtml, l10n.includeHtml, provider.exportHtml, (v) => provider.setExportHtml(v), Icons.html_rounded),
        const SizedBox(height: 16),
        _buildSectionTitle(l10n.markdownStyle.toUpperCase()),
        const SizedBox(height: 16),
        _buildDropdownSetting(
          label: l10n.listBulletStyle,
          value: provider.listBullet,
          items: {'*': '* (Asterisk)', '-': '- (Dash)', '+': '+ (Plus)'},
          onChanged: (v) => provider.setListBullet(v!),
          icon: Icons.list_rounded,
        ),
        const SizedBox(height: 16),
        _buildDropdownSetting(
          label: l10n.sectionSpacing,
          value: provider.sectionSpacing,
          items: {0: 'Compact', 1: 'Standard', 2: 'Spacious'},
          onChanged: (v) => provider.setSectionSpacing(v!),
          icon: Icons.vertical_distribute_rounded,
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required String initialValue, required IconData icon, required ValueChanged<String> onChanged}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10),
      ),
      style: GoogleFonts.inter(),
      onChanged: onChanged,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged, IconData icon) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildColorTile(String title, Color color, ValueChanged<Color> onColorChanged, AppLocalizations l10n) {
    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: () => _showColorPicker(context, color, onColorChanged, l10n),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withAlpha(50))),
        ),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('#${color.toARGB32().toRadixString(16).toUpperCase().substring(2)}', style: GoogleFonts.firaCode(fontSize: 12)),
        trailing: const Icon(Icons.colorize_rounded, size: 18),
      ),
    );
  }

  void _showColorPicker(BuildContext context, Color initialColor, ValueChanged<Color> onColorChanged, AppLocalizations l10n) {
    showSafeDialog(
      context,
      builder: (context) => ConfirmDialog(
        title: l10n.pickColor,
        onConfirm: () {},
        confirmText: l10n.save,
        content: '',
        icon: Icons.colorize_rounded,
      ),
    );
  }

  Widget _buildDropdownSetting<T>({required String label, required T value, required Map<T, String> items, required ValueChanged<T?> onChanged, required IconData icon}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: GoogleFonts.inter()))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

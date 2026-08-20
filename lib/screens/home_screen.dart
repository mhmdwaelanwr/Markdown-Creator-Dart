import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markdown_creator/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../widgets/components_panel.dart';
import '../widgets/editor_canvas.dart';
import '../widgets/settings_panel.dart';
import '../providers/project_provider.dart';
import '../utils/templates.dart';
import '../utils/project_exporter.dart';
import '../utils/downloader.dart';
import 'projects_library_screen.dart';
import 'social_preview_screen.dart';
import 'github_actions_generator.dart';
import '../services/health_check_service.dart';
import '../services/auth_service.dart';
import '../services/subscription_service.dart';
import '../core/constants/app_colors.dart';
import 'package:flutter/foundation.dart';

import '../utils/toast_helper.dart';
import '../widgets/developer_info_dialog.dart';
import '../utils/dialog_helper.dart';

import 'gallery_screen.dart';
import 'funding_generator_screen.dart';
import '../generator/markdown_generator.dart';
import '../widgets/dialogs/project_settings_dialog.dart';
import '../widgets/dialogs/import_markdown_dialog.dart';
import '../widgets/dialogs/generate_codebase_dialog.dart';
import '../widgets/dialogs/publish_to_github_dialog.dart';
import '../widgets/dialogs/save_to_library_dialog.dart';
import '../widgets/dialogs/snapshots_dialog.dart';
import '../widgets/dialogs/health_check_dialog.dart';
import '../widgets/dialogs/keyboard_shortcuts_dialog.dart';
import '../widgets/dialogs/ai_settings_dialog.dart';
import '../widgets/dialogs/extra_files_dialog.dart';
import '../widgets/dialogs/language_dialog.dart';
import '../widgets/dialogs/confirm_dialog.dart';
import '../widgets/dialogs/about_app_dialog.dart';
import '../widgets/dialogs/login_dialog.dart';
import '../widgets/dialogs/paywall_dialog.dart';
import 'admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();
  bool _showPreview = false;
  bool _isFocusMode = false;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(parent: _mainController, curve: Curves.easeOutQuart);
    _mainController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initBannerAd();
    });
  }

  void _initBannerAd() {
    final subService = Provider.of<SubscriptionService>(context, listen: false);
    if (!subService.isPro && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      _bannerAd = BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111', 
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _isAdLoaded = true),
          onAdFailedToLoad: (ad, error) { ad.dispose(); },
        ),
      )..load();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.of(context).size.width > 1200;
    final provider = Provider.of<ProjectProvider>(context);
    final subService = Provider.of<SubscriptionService>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: _buildFutureAppBar(context, isDesktop, provider, subService, l10n),
        drawer: isDesktop ? null : const Drawer(child: ComponentsPanel()),
        endDrawer: isDesktop ? null : const Drawer(child: SettingsPanel()),
        body: Stack(
          children: [
            _buildCinematicBackground(context, isDark),
            Column(
              children: [
                const SizedBox(height: 110), 
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        if (isDesktop && !_isFocusMode) 
                          _buildGlassPanel(const ComponentsPanel(), flex: 2),
                        
                        if (isDesktop && !_isFocusMode) const SizedBox(width: 20),
                        
                        Expanded(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: const EditorCanvas(),
                          ),
                        ),
                        
                        if (_showPreview && isDesktop) ...[
                          const SizedBox(width: 20),
                          _buildGlassPanel(_buildLiveMarkdownPreview(context, provider, isDark), flex: 4),
                        ],
                        
                        if (isDesktop && !_isFocusMode) const SizedBox(width: 20),
                        
                        if (isDesktop && !_isFocusMode) 
                          _buildGlassPanel(const SettingsPanel(), flex: 3),
                      ],
                    ),
                  ),
                ),
                
                if (!subService.isPro && _isAdLoaded && _bannerAd != null)
                  Container(
                    height: _bannerAd!.size.height.toDouble(),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: AdWidget(ad: _bannerAd!),
                  ),

                _buildModernStatusBar(context, provider, subService, isDark, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildFutureAppBar(BuildContext context, bool isDesktop, ProjectProvider provider, SubscriptionService subService, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: (isDark ? Colors.black : Colors.white).withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  _studioIcon(),
                  const SizedBox(width: 14),
                  _buildBrandName(isDark, subService.isPro),
                  const Spacer(),
                  if (isDesktop) ..._buildFullAppBarActions(context, provider, subService, l10n),
                  if (!isDesktop) IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () => _scaffoldKey.currentState?.openEndDrawer()),
                  const SizedBox(width: 8),
                  _buildMoreOptionsButton(context, subService, l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandName(bool isDark, bool isPro) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('MARKDOWN', style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5, color: isDark ? Colors.white : AppColors.primary)),
            if (isPro)
              Container(
                margin: const EdgeInsetsDirectional.only(start: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                child: const Text('PRO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black)),
              ),
          ],
        ),
        Text('STUDIO PRO', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 10, letterSpacing: 2, color: Colors.grey)),
      ],
    );
  }

  List<Widget> _buildFullAppBarActions(BuildContext context, ProjectProvider provider, SubscriptionService subService, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      _actionBtn(Icons.undo_rounded, provider.undo, tooltip: l10n.undo),
      _actionBtn(Icons.redo_rounded, provider.redo, tooltip: l10n.redo),
      _divider(),
      _actionBtn(Icons.file_copy_outlined, () => _showTemplatesMenu(context, provider, l10n), tooltip: l10n.templates),
      _actionBtn(Icons.library_books_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectsLibraryScreen())), tooltip: l10n.projectsLibrary),
      _divider(),
      _deviceBtn(Icons.desktop_mac, DeviceMode.desktop, provider),
      _deviceBtn(Icons.tablet_mac, DeviceMode.tablet, provider),
      _deviceBtn(Icons.phone_iphone, DeviceMode.mobile, provider),
      const SizedBox(width: 8),
      _actionBtn(_showPreview ? Icons.visibility : Icons.visibility_off, () => setState(() => _showPreview = !_showPreview), active: _showPreview, tooltip: l10n.showPreview),
      _actionBtn(_isFocusMode ? Icons.fullscreen_exit : Icons.fullscreen, () => setState(() => _isFocusMode = !_isFocusMode), active: _isFocusMode, tooltip: l10n.focusMode),
      _divider(),
      _actionBtn(Icons.health_and_safety_outlined, () {
        final issues = HealthCheckService.analyze(provider.elements);
        _showHealthCheckDialog(context, issues, provider);
      }, tooltip: l10n.healthy),
      _actionBtn(Icons.print_rounded, () => _handleProtectedAction(context, subService, () => _handlePrint(provider)), tooltip: l10n.print),
      _divider(),
      _actionBtn(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, provider.toggleTheme, color: isDark ? Colors.amber : Colors.blueGrey, tooltip: l10n.toggleTheme),
      _actionBtn(Icons.settings_outlined, () => _showProjectSettingsDialog(context, provider), tooltip: l10n.projectSettings),
      const SizedBox(width: 8),
      _buildAccountButton(context, l10n),
      const SizedBox(width: 16),
      ElevatedButton.icon(
        onPressed: () => _handleExport(provider),
        icon: const Icon(Icons.rocket_launch_rounded, size: 16),
        label: Text(l10n.export.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1, fontSize: 12)),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      ),
    ];
  }

  Widget _buildAccountButton(BuildContext context, AppLocalizations l10n) {
    return StreamBuilder<User?>(
      stream: _authService.user,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return _actionBtn(
          user != null ? Icons.account_circle : Icons.login_rounded,
          () {
            if (user != null) {
              _authService.signOut();
            } else {
              showSafeDialog(context, builder: (_) => const LoginDialog());
            }
          },
          tooltip: user != null ? '${l10n.account}: ${user.email}' : l10n.signInSync,
          color: user != null ? Colors.teal : null,
        );
      }
    );
  }

  void _handleProtectedAction(BuildContext context, SubscriptionService subService, VoidCallback action) {
    if (subService.isPro) {
      action();
    } else {
      showSafeDialog(context, builder: (_) => const PaywallDialog());
    }
  }

  Widget _buildMoreOptionsButton(BuildContext context, SubscriptionService subService, AppLocalizations l10n) {
    final provider = Provider.of<ProjectProvider>(context, listen: false);
    return PopupMenuButton<String>(
      icon: const Icon(Icons.grid_view_rounded, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      offset: const Offset(0, 50),
      itemBuilder: (context) => [
        _menuHeader(l10n.projectAndFiles),
        _menuItem('save', Icons.save_alt_rounded, l10n.saveProject, Colors.blue),
        _menuItem('snapshots', Icons.history_rounded, l10n.localSnapshots, Colors.blue),
        _menuItem('import_md', Icons.file_upload_outlined, l10n.importMarkdown, Colors.blue),
        _menuItem('export_json', Icons.javascript_rounded, l10n.exportProjectJson, Colors.blue),
        _menuItem('import_json', Icons.data_object_rounded, l10n.importProjectJson, Colors.blue),
        _menuItem('clear', Icons.delete_sweep_rounded, l10n.clearWorkspace, Colors.red, isDestructive: true),
        const PopupMenuDivider(),
        _menuHeader(l10n.toolsAndGenerators),
        _menuItem('gallery', Icons.auto_awesome_mosaic_rounded, l10n.showcaseGallery, Colors.orange),
        _menuItem('social', Icons.auto_graph_rounded, l10n.socialPreviewDesigner, Colors.orange),
        _menuItem('actions', Icons.terminal_rounded, l10n.githubActionsGenerator, Colors.orange),
        _menuItem('funding', Icons.volunteer_activism_rounded, l10n.fundingGenerator, Colors.pink),
        _menuItem('extra', Icons.library_add_rounded, l10n.generateExtraFiles, Colors.deepOrange),
        const PopupMenuDivider(),
        _menuHeader(l10n.intelligence),
        _menuItem('ai', Icons.psychology_rounded, l10n.aiSettings, Colors.purple),
        _menuItem('codebase', Icons.auto_awesome_rounded, l10n.generateFromCodebase, Colors.purple),
        _menuItem('publish', Icons.cloud_upload_rounded, l10n.publishToGithub, Colors.teal),
        const PopupMenuDivider(),
        _menuHeader(l10n.application),
        if (_authService.isAdmin) _menuItem('admin', Icons.admin_panel_settings_rounded, l10n.adminDashboard, Colors.purpleAccent),
        _menuItem('upgrade', Icons.star_rounded, l10n.upgradeToPro, Colors.amber),
        _menuItem('lang', Icons.translate_rounded, l10n.changeLanguage, Colors.grey),
        _menuItem('shortcuts', Icons.keyboard_rounded, l10n.keyboardShortcuts, Colors.grey),
        _menuItem('about_dev', Icons.person_rounded, l10n.aboutDeveloper, Colors.grey),
        _menuItem('about', Icons.info_outline_rounded, l10n.aboutApp, Colors.grey),
      ],
      onSelected: (val) {
        if (val == 'save') _showSaveToLibraryDialog(context, provider);
        else if (val == 'snapshots') _showSnapshotsDialog(context, provider);
        else if (val == 'import_md') _showImportMarkdownDialog(context, provider);
        else if (val == 'export_json') downloadJsonFile(provider.exportToJson(), 'readme_project.json');
        else if (val == 'import_json') _handleImportJson(provider);
        else if (val == 'clear') showSafeDialog(context, builder: (context) => ConfirmDialog(title: l10n.confirmClearWorkspace, content: l10n.confirmClearWorkspaceContent, confirmText: l10n.delete, isDestructive: true, onConfirm: () => provider.clearElements()));
        else if (val == 'gallery') Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryScreen()));
        else if (val == 'social') Navigator.push(context, MaterialPageRoute(builder: (_) => const SocialPreviewScreen()));
        else if (val == 'actions') Navigator.push(context, MaterialPageRoute(builder: (_) => const GitHubActionsGenerator()));
        else if (val == 'funding') Navigator.push(context, MaterialPageRoute(builder: (_) => const FundingGeneratorScreen()));
        else if (val == 'extra') _showExtraFilesDialog(context, provider);
        else if (val == 'ai') _handleProtectedAction(context, subService, () => _showAISettingsDialog(context, provider));
        else if (val == 'codebase') _handleProtectedAction(context, subService, () => _showGenerateFromCodebaseDialog(context, provider));
        else if (val == 'publish') _showPublishToGitHubDialog(context, provider);
        else if (val == 'admin') Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
        else if (val == 'upgrade') showSafeDialog(context, builder: (_) => const PaywallDialog());
        else if (val == 'lang') _showLanguageDialog(context, provider);
        else if (val == 'shortcuts') _showKeyboardShortcutsDialog(context);
        else if (val == 'about_dev') _showDeveloperInfoDialog(context);
        else if (val == 'about') _showAboutAppDialog(context);
      },
    );
  }

  Widget _buildGlassPanel(Widget child, {required int flex}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      flex: flex,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? Colors.black26 : Colors.white.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.08)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, VoidCallback onTap, {bool active = false, String? tooltip, Color? color}) => Tooltip(message: tooltip ?? '', child: IconButton(icon: Icon(icon, size: 19, color: active ? AppColors.primary : color), onPressed: onTap, splashRadius: 22));
  Widget _deviceBtn(IconData icon, DeviceMode mode, ProjectProvider provider) => IconButton(icon: Icon(icon, size: 19, color: provider.deviceMode == mode ? AppColors.primary : Colors.grey), onPressed: () => provider.setDeviceMode(mode));
  Widget _divider() => const VerticalDivider(width: 24, indent: 22, endIndent: 22, thickness: 1);
  Widget _studioIcon() => Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20));
  PopupMenuItem<String> _menuHeader(String title) => PopupMenuItem(enabled: false, height: 30, child: Text(title.toUpperCase(), style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.2)));
  PopupMenuItem<String> _menuItem(String val, IconData icon, String text, Color color, {bool isDestructive = false}) => PopupMenuItem(value: val, child: Row(children: [Icon(icon, color: isDestructive ? Colors.red : color, size: 18), const SizedBox(width: 12), Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : null))]));

  Widget _buildCinematicBackground(BuildContext context, bool isDark) {
    return Stack(children: [Positioned(top: -50, right: -50, child: _blob(400, AppColors.primary.withOpacity(isDark ? 0.2 : 0.1))), Positioned(bottom: -100, left: -100, child: _blob(500, Colors.purpleAccent.withOpacity(isDark ? 0.15 : 0.05)))]);
  }
  Widget _blob(double size, Color color) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)]));

  Widget _buildLiveMarkdownPreview(BuildContext context, ProjectProvider provider, bool isDark) {
    final markdown = MarkdownGenerator().generate(provider.elements, variables: provider.variables);
    return Padding(padding: const EdgeInsets.all(24), child: Markdown(data: markdown, styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))));
  }

  Widget _buildModernStatusBar(BuildContext context, ProjectProvider provider, SubscriptionService subService, bool isDark, AppLocalizations l10n) {
    final score = HealthCheckService.calculateDocumentationScore(provider.elements);
    return Container(
      height: 36, 
      padding: const EdgeInsets.symmetric(horizontal: 24), 
      decoration: BoxDecoration(color: isDark ? Colors.black38 : Colors.white70, border: Border(top: BorderSide(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)))), 
      child: Row(
        children: [
          _statusItem(Icons.widgets_outlined, '${provider.elements.length} ${l10n.elements}'), 
          const SizedBox(width: 24), 
          _statusItem(Icons.analytics_outlined, '${l10n.docQuality}: ${score.toInt()}%', color: score > 70 ? Colors.greenAccent : Colors.orangeAccent), 
          const Spacer(),
          if (subService.isPro)
            _statusItem(Icons.verified_rounded, l10n.proActive, color: Colors.amber)
          else
            _statusItem(Icons.ads_click_rounded, l10n.freePlan, color: Colors.grey),
          const SizedBox(width: 16),
          if (provider.isSaving) const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)) else _statusItem(Icons.cloud_done_rounded, l10n.synced, color: AppColors.primary)
        ]
      )
    );
  }
  Widget _statusItem(IconData icon, String label, {Color? color}) => Row(children: [Icon(icon, size: 14, color: color ?? Colors.grey), const SizedBox(width: 6), Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: color ?? Colors.grey))]);

  void _showTemplatesMenu(BuildContext context, ProjectProvider provider, AppLocalizations l10n) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(Rect.fromPoints(button.localToGlobal(Offset.zero, ancestor: overlay), button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay)), Offset.zero & overlay.size);
    showMenu<ProjectTemplate>(context: context, position: position, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), items: provider.allTemplates.map((t) => PopupMenuItem(value: t, child: ListTile(leading: const Icon(Icons.article_outlined, color: AppColors.primary), title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(t.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11))))).toList()).then((template) {
      if (template != null) showSafeDialog(context, builder: (context) => ConfirmDialog(title: l10n.loadTemplate, content: l10n.replaceWorkspace, confirmText: l10n.load, onConfirm: () => provider.loadTemplate(template)));
    });
  }

  Future<void> _handleImportJson(ProjectProvider provider) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      if (result != null) {
        String? content;
        if (result.files.first.bytes != null) content = utf8.decode(result.files.first.bytes!);
        if (content != null) {
          provider.importFromJson(content);
          if (context.mounted) ToastHelper.show(context, 'Project imported successfully');
        }
      }
    } catch (e) {
      if (context.mounted) ToastHelper.show(context, 'Error: $e', isError: true);
    }
  }

  void _handlePrint(ProjectProvider provider) async {
    final markdown = MarkdownGenerator().generate(provider.elements, variables: provider.variables);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
        format: format,
        html: '<html><body>${md.markdownToHtml(markdown)}</body></html>',
      ),
    );
  }

  void _handleExport(ProjectProvider provider) => ProjectExporter.export(elements: provider.elements, variables: provider.variables, licenseType: provider.licenseType, includeContributing: provider.includeContributing);
  void _showProjectSettingsDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const ProjectSettingsDialog());
  void _showSaveToLibraryDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const SaveToLibraryDialog());
  void _showSnapshotsDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const SnapshotsDialog());
  void _showHealthCheckDialog(BuildContext context, List<HealthIssue> issues, ProjectProvider provider) => showSafeDialog(context, builder: (_) => HealthCheckDialog(issues: issues, provider: provider));
  void _showImportMarkdownDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const ImportMarkdownDialog());
  void _showAISettingsDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const AISettingsDialog());
  void _showGenerateFromCodebaseDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const GenerateCodebaseDialog());
  void _showPublishToGitHubDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const PublishToGitHubDialog());
  void _showExtraFilesDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const ExtraFilesDialog());
  void _showLanguageDialog(BuildContext context, ProjectProvider provider) => showSafeDialog(context, builder: (_) => const LanguageDialog());
  void _showKeyboardShortcutsDialog(BuildContext context) => showSafeDialog(context, builder: (_) => const KeyboardShortcutsDialog());
  void _showDeveloperInfoDialog(BuildContext context) => showSafeDialog(context, builder: (_) => const DeveloperInfoDialog());
  void _showAboutAppDialog(BuildContext context) => showSafeDialog(context, builder: (_) => const AboutAppDialog());
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/project_provider.dart';
import '../utils/templates.dart';
import '../models/readme_element.dart';
import '../core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  String? _goal;

  final _projectNameController = TextEditingController();
  final _projectDescController = TextEditingController();
  final _usernameController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectDescController.dispose();
    _usernameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _finish() {
    final provider = Provider.of<ProjectProvider>(context, listen: false);
    provider.clearElements();

    if (_goal == 'project') {
      final template = Templates.all.firstWhere((t) => t.name == 'Full Project');
      provider.loadTemplate(template);
      provider.updateVariable('PROJECT_NAME', _projectNameController.text.isNotEmpty ? _projectNameController.text : 'My Project');
      if (_projectDescController.text.isNotEmpty) {
        for (var element in provider.elements) {
          if (element is ParagraphElement && element.text.contains('A complete solution for')) {
            element.text = _projectDescController.text;
            break;
          }
        }
      }
    } else {
      final template = Templates.all.firstWhere((t) => t.name == 'Developer Profile');
      provider.loadTemplate(template);
      final username = _usernameController.text.isNotEmpty ? _usernameController.text : 'username';
      provider.updateVariable('GITHUB_USERNAME', username);
      if (_roleController.text.isNotEmpty) {
         for (var element in provider.elements) {
          if (element is ParagraphElement && element.text.contains('passionate developer')) {
            element.text = 'I\'m a ${_roleController.text} from ...';
            break;
          }
        }
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 650,
        height: 600,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(isDark ? 100 : 20), blurRadius: 40, offset: const Offset(0, 20))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Background Accents
              Positioned(
                top: -100,
                right: -100,
                child: CircleAvatar(radius: 150, backgroundColor: AppColors.primary.withAlpha(isDark ? 30 : 15)),
              ),
              
              Column(
                children: [
                  // Progress Indicator
                  _buildProgressIndicator(),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: _step == 0 ? _buildStep1() : _buildStep2(),
                      ),
                    ),
                  ),
                  
                  // Bottom Navigation
                  _buildBottomActions(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _progressDot(active: _step >= 0),
          _progressLine(active: _step >= 1),
          _progressDot(active: _step >= 1),
        ],
      ),
    );
  }

  Widget _progressDot({required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 12, height: 12,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.grey.withAlpha(50),
        shape: BoxShape.circle,
        boxShadow: active ? [BoxShadow(color: AppColors.primary.withAlpha(100), blurRadius: 8)] : null,
      ),
    );
  }

  Widget _progressLine({required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 60, height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.grey.withAlpha(50),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildStep1() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey(0),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.welcomeToReadmeCreator,
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.whatToBuild,
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionCard(
              icon: Icons.auto_awesome_motion_rounded,
              title: l10n.projectReadme,
              subtitle: l10n.softwareAndApps,
              value: 'project',
            ),
            const SizedBox(width: 20),
            _buildOptionCard(
              icon: Icons.face_rounded,
              title: l10n.githubProfile,
              subtitle: l10n.personalPortfolio,
              value: 'profile',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard({required IconData icon, required String title, required String subtitle, required String value}) {
    final isSelected = _goal == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => _goal = value),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 240,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.primary.withAlpha(isDark ? 30 : 15) 
            : (isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(3)),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withAlpha(30),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: isSelected ? Colors.white : Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey(1),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _goal == 'project' ? l10n.projectIntelligence : l10n.personalBranding,
          style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.fillBasics,
          style: GoogleFonts.inter(color: Colors.grey),
        ),
        const SizedBox(height: 40),
        if (_goal == 'project') ...[
          _buildTextField(controller: _projectNameController, label: l10n.projectName, icon: Icons.title_rounded),
          const SizedBox(height: 16),
          _buildTextField(controller: _projectDescController, label: l10n.briefDescription, icon: Icons.description_rounded, maxLines: 3),
        ] else ...[
          _buildTextField(controller: _usernameController, label: l10n.githubUsername, icon: Icons.alternate_email_rounded),
          const SizedBox(height: 16),
          _buildTextField(controller: _roleController, label: l10n.professionalTitle, icon: Icons.badge_rounded, hint: 'e.g. Flutter Developer'),
        ],
      ],
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, String? hint, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      style: GoogleFonts.inter(),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _step > 0 ? setState(() => _step--) : Navigator.pop(context),
            child: Text(_step > 0 ? l10n.goBack : l10n.skipSetup, style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_step == 0) {
                if (_goal != null) setState(() => _step++);
              } else {
                _finish();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(_step == 0 ? l10n.continueBtn : l10n.startCreating, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

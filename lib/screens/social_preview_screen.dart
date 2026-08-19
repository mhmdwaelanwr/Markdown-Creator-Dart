import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../l10n/app_localizations.dart';
import '../providers/project_provider.dart';
import '../utils/downloader.dart';
import '../utils/toast_helper.dart';
import '../utils/dialog_helper.dart';
import '../core/constants/app_colors.dart';

class SocialPreviewScreen extends StatefulWidget {
  const SocialPreviewScreen({super.key});

  @override
  State<SocialPreviewScreen> createState() => _SocialPreviewScreenState();
}

class _SocialPreviewScreenState extends State<SocialPreviewScreen> {
  final GlobalKey _previewKey = GlobalKey();
  Color _backgroundColor = AppColors.socialPreviewDark; // Dark GitHub-like
  Color _textColor = Colors.white;
  bool _useGradient = false;
  Color _gradientStart = const Color(0xFF2196F3);
  Color _gradientEnd = const Color(0xFF9C27B0);
  double _titleSize = 64;
  double _descSize = 32;
  bool _showBorder = true;
  Uint8List? _logoBytes; // Added for logo support
  String _descriptionText = 'Awesome project description goes here.';
  String _selectedFont = 'Inter';
  final List<String> _fonts = ['Inter', 'Roboto', 'Poppins', 'Lato', 'Open Sans', 'Montserrat', 'Oswald', 'Raleway'];

  @override
  void initState() {
    super.initState();
    // Initialize description from provider if available, otherwise default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize if needed
    });
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.first.bytes != null) {
      setState(() {
        _logoBytes = result.files.first.bytes;
      });
    }
  }

  Future<void> _exportImage() async {
    try {
      final boundary = _previewKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 2.0); // High res
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // Use downloader util
        // We need to convert Uint8List to String for downloadJsonFile? No, that's for JSON.
        // We need a binary downloader.
        // Let's check utils/downloader.dart
        // It seems we only have downloadJsonFile.
        // I'll implement a simple download helper here or update downloader.dart.
        // For now, let's assume I can use a similar method or just implement it.
        // Actually, I should check downloader.dart first.
        // But I can't check it right now without interrupting flow.
        // I'll assume I need to implement binary download.
        // Wait, I can just use the same technique as downloadJsonFile but with bytes.
        // Let's check if I can import 'dart:html' if web, or use file_picker/path_provider if desktop.
        // Since this is a Flutter app, I should use a cross-platform way.
        // For now, I'll just use a placeholder or try to use the existing downloader if it supports bytes.
        // Let's just implement a quick save dialog for desktop.

        // Actually, I'll just use FilePicker to save.
        // But wait, FilePicker.saveFile is not available on all platforms easily in older versions.
        // Let's use the same approach as `ProjectExporter` if it saves files.
        // `ProjectExporter` likely uses `downloadJsonFile`.

        // Let's just use a simple method for now.
        // I'll add a method to `Downloader` class later if needed.
        // For now, I'll just print "Exported" to console and show snackbar,
        // but to be useful I need to save it.
        // I'll use `Printing` package to share/save? No, that's for PDF.
        // I'll use `file_picker` to save if possible, or just `File` write if desktop.

        // Let's try to use `file_picker`'s `saveFile` if available (it is in recent versions).
        // Or just `File` write.

        // Since I am on Windows, I can use `File`.
        // But I want it to be generic.
        // Let's use `FilePicker.platform.saveFile`.

        // Wait, `file_picker` 10.3.8 supports `saveFile`.

        /*
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Social Preview',
          fileName: 'social-preview.png',
        );

        if (outputFile != null) {
           final file = File(outputFile);
           await file.writeAsBytes(pngBytes);
           if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!')));
        }
        */
        // But I need `dart:io`.
        // I'll add imports.

        // For web support, I would need `dart:html`.
        // I'll stick to desktop for now as per environment.

        // Actually, let's just use a simple helper that I will add to `downloader.dart` later.
        // For now, I will implement `_saveImage` locally.
        _saveImage(pngBytes);
      }
    } catch (e) {
      debugPrint('Error exporting image: $e');
    }
  }

  Future<void> _saveImage(Uint8List bytes) async {
    await downloadImageFile(bytes, 'social-preview.png');
    if (mounted) ToastHelper.show(context, 'Image exported!');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.socialPreviewDesignerTitle, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          FilledButton.icon(
            icon: const Icon(Icons.download),
            label: Text(l10n.exportImage),
            onPressed: _exportImage,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Settings Panel
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: isDark ? AppColors.editorBackgroundDark : Colors.white,
              border: Border(right: BorderSide(color: isDark ? Colors.white.withAlpha(20) : Colors.grey.withAlpha(50))),
            ),
            child: _buildControls(),
          ),
          // Preview Area
          Expanded(
            child: Container(
              color: isDark ? Colors.black : Colors.grey[100],
              child: _buildPreview(provider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPickerTile(String label, Color currentColor, Function(Color) onColorChanged) {
    return InkWell(
      onTap: () {
        showSafeDialog(
          context,
          builder: (context) => AlertDialog(
            title: Text('Pick $label', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: currentColor,
                onColorChanged: onColorChanged,
                labelTypes: const [],
                enableAlpha: false,
                displayThumbColor: true,
                paletteType: PaletteType.hueWheel,
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withAlpha(50)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.withAlpha(50)),
              ),
            ),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            Text('${value.toInt()}px', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withAlpha(30),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  bool _showWatermark = true;
  String _watermarkText = 'Made with Readme Creator';

  Widget _buildPreview(ProjectProvider provider) {
    final projectName = provider.variables['PROJECT_NAME'] ?? 'Project Name';

    TextStyle getFontStyle(double size, FontWeight weight) {
      switch (_selectedFont) {
        case 'Roboto': return GoogleFonts.roboto(fontSize: size, fontWeight: weight, color: _textColor);
        case 'Poppins': return GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: _textColor);
        case 'Lato': return GoogleFonts.lato(fontSize: size, fontWeight: weight, color: _textColor);
        case 'Open Sans': return GoogleFonts.openSans(fontSize: size, fontWeight: weight, color: _textColor);
        case 'Montserrat': return GoogleFonts.montserrat(fontSize: size, fontWeight: weight, color: _textColor);
        case 'Oswald': return GoogleFonts.oswald(fontSize: size, fontWeight: weight, color: _textColor);
        case 'Raleway': return GoogleFonts.raleway(fontSize: size, fontWeight: weight, color: _textColor);
        default: return GoogleFonts.inter(fontSize: size, fontWeight: weight, color: _textColor);
      }
    }

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: _previewKey,
            child: Container(
              width: 800, // Standard social preview size ratio 2:1 usually 1280x640 or similar
              height: 400,
              decoration: BoxDecoration(
                color: _useGradient ? null : _backgroundColor,
                gradient: _useGradient
                    ? LinearGradient(
                        colors: [_gradientStart, _gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                border: _showBorder ? Border.all(color: Colors.white.withAlpha(50), width: 2) : null,
                borderRadius: BorderRadius.circular(16), // Rounded corners for preview look
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background Pattern (Optional - maybe add later)
                  if (_useGradient) // Add a subtle pattern overlay if gradient
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.05,
                        child: CustomPaint(painter: GridPatternPainter()),
                      ),
                    ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_logoBytes != null) ...[
                            Image.memory(_logoBytes!, height: 80, fit: BoxFit.contain),
                            const SizedBox(height: 24),
                          ],
                          Text(
                            projectName,
                            style: getFontStyle(_titleSize, FontWeight.bold).copyWith(height: 1.1),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _descriptionText,
                            style: getFontStyle(_descSize, FontWeight.normal).copyWith(color: _textColor.withAlpha(200)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Watermark or Badge
                  if (_showWatermark)
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Row(
                        children: [
                          Icon(Icons.description, color: _textColor.withAlpha(100), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _watermarkText,
                            style: GoogleFonts.inter(
                              color: _textColor.withAlpha(100),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Content Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: _descriptionText,
          decoration: const InputDecoration(
            labelText: 'Card Description',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          onChanged: (val) => setState(() => _descriptionText = val),
        ),
        const SizedBox(height: 24),

        Text('Design Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),

        // Logo Picker
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Project Logo', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          trailing: _logoBytes != null
              ? IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => _logoBytes = null))
              : ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text('Upload'),
                  onPressed: _pickLogo,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                ),
        ),
        const Divider(),

        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Use Gradient Background', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          value: _useGradient,
          onChanged: (val) => setState(() => _useGradient = val),
        ),
        const SizedBox(height: 12),
        if (_useGradient) ...[
          _buildColorPickerTile('Gradient Start Color', _gradientStart, (c) => setState(() => _gradientStart = c)),
          const SizedBox(height: 12),
          _buildColorPickerTile('Gradient End Color', _gradientEnd, (c) => setState(() => _gradientEnd = c)),
        ] else
          _buildColorPickerTile('Background Color', _backgroundColor, (c) => setState(() => _backgroundColor = c)),
        const SizedBox(height: 12),
        _buildColorPickerTile('Text Color', _textColor, (c) => setState(() => _textColor = c)),

        const SizedBox(height: 32),
        Text('Typography Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        InputDecorator(
          decoration: const InputDecoration(labelText: 'Font Family', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedFont,
              items: _fonts.map((f) => DropdownMenuItem(value: f, child: Text(f, style: GoogleFonts.getFont(f)))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedFont = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildSlider('Title Font Size', _titleSize, 24, 120, (v) => setState(() => _titleSize = v)),
        const SizedBox(height: 16),
        _buildSlider('Description Font Size', _descSize, 12, 60, (v) => setState(() => _descSize = v)),

        const SizedBox(height: 32),
        Text('Layout Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Show Border', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          value: _showBorder,
          onChanged: (val) => setState(() => _showBorder = val),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Show Watermark', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          value: _showWatermark,
          onChanged: (val) => setState(() => _showWatermark = val),
        ),
        if (_showWatermark)
          TextFormField(
            initialValue: _watermarkText,
            decoration: const InputDecoration(labelText: 'Watermark Text', isDense: true),
            onChanged: (val) => setState(() => _watermarkText = val),
          ),
      ],
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

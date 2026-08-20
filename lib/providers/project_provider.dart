import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../models/readme_element.dart';
import '../models/snippet.dart';
import '../utils/templates.dart';
import '../utils/markdown_importer.dart';
import '../services/firestore_service.dart';

enum DeviceMode { desktop, tablet, mobile }

class ProjectProvider with ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _cloudTemplatesSubscription;
  
  final List<ReadmeElement> _elements = [];
  List<ProjectTemplate> _cloudTemplates = [];
  String? _selectedElementId;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isSaving = false; // Internal saving state
  
  final Map<String, String> _variables = {
    'PROJECT_NAME': 'My Project',
    'GITHUB_USERNAME': 'username',
    'CURRENT_YEAR': DateTime.now().year.toString(),
  };

  // State variables
  String _licenseType = 'None';
  bool _includeContributing = false;
  bool _includeSecurity = false;
  bool _includeSupport = false;
  bool _includeCodeOfConduct = false;
  bool _includeIssueTemplates = false;
  Color _primaryColor = Colors.blue;
  Color _secondaryColor = Colors.green;
  bool _showGrid = true;
  List<String> _snapshots = [];
  String _listBullet = '*';
  int _sectionSpacing = 1;
  DeviceMode _deviceMode = DeviceMode.desktop;
  bool _exportHtml = false;
  String? _geminiApiKey;
  String? _githubToken;
  Locale? _locale;
  String _targetLanguage = 'en';

  final List<String> _undoStack = [];
  final List<String> _redoStack = [];

  // Getters
  List<ReadmeElement> get elements => _elements;
  List<ProjectTemplate> get cloudTemplates => _cloudTemplates;
  String? get selectedElementId => _selectedElementId;
  bool get isSaving => _isSaving; // RESTORED: Required by Status Bar
  
  ReadmeElement? get selectedElement {
    if (_selectedElementId == null) return null;
    try {
      return _elements.firstWhere((e) => e.id == _selectedElementId);
    } catch (e) {
      return null;
    }
  }

  ThemeMode get themeMode => _themeMode;
  Map<String, String> get variables => _variables;
  String get licenseType => _licenseType;
  bool get includeContributing => _includeContributing;
  bool get includeSecurity => _includeSecurity;
  bool get includeSupport => _includeSupport;
  bool get includeCodeOfConduct => _includeCodeOfConduct;
  bool get includeIssueTemplates => _includeIssueTemplates;
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  bool get showGrid => _showGrid;
  List<String> get snapshots => _snapshots;
  String get listBullet => _listBullet;
  int get sectionSpacing => _sectionSpacing;
  DeviceMode get deviceMode => _deviceMode;
  bool get exportHtml => _exportHtml;
  String get geminiApiKey => _geminiApiKey ?? '';
  String get githubToken => _githubToken ?? '';
  Locale? get locale => _locale;
  String get targetLanguage => _targetLanguage;

  ProjectProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadPreferences();
    _listenToCloudTemplates();
  }

  void _listenToCloudTemplates() {
    _cloudTemplatesSubscription?.cancel();
    _cloudTemplatesSubscription = _firestoreService.getPublicTemplates().listen((data) {
      _cloudTemplates = data.map((map) {
        final List<dynamic> elementsJson = map['elements'] ?? [];
        return ProjectTemplate(
          name: map['name'] ?? 'Cloud Template',
          description: map['description'] ?? '',
          elements: elementsJson.map((e) => ReadmeElement.fromJson(e)).toList(),
        );
      }).toList();
      notifyListeners();
    });
  }

  List<ProjectTemplate> get allTemplates => [...Templates.all, ..._cloudTemplates];

  @override
  void dispose() {
    _cloudTemplatesSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    _themeMode = await _prefsService.loadThemeMode();
    final loadedElements = await _prefsService.loadElements();
    if (loadedElements.isNotEmpty) {
      _elements.clear();
      _elements.addAll(loadedElements);
    }
    final loadedVariables = await _prefsService.loadVariables();
    if (loadedVariables.isNotEmpty) _variables.addAll(loadedVariables);

    _licenseType = await _prefsService.loadString(PreferencesService.keyLicenseType) ?? 'None';
    _includeContributing = await _prefsService.loadBool(PreferencesService.keyIncludeContributing) ?? false;
    _includeSecurity = await _prefsService.loadBool(PreferencesService.keyIncludeSecurity) ?? false;
    _includeSupport = await _prefsService.loadBool(PreferencesService.keyIncludeSupport) ?? false;
    _includeCodeOfConduct = await _prefsService.loadBool(PreferencesService.keyIncludeCodeOfConduct) ?? false;
    _includeIssueTemplates = await _prefsService.loadBool(PreferencesService.keyIncludeIssueTemplates) ?? false;

    final pColor = await _prefsService.loadInt(PreferencesService.keyPrimaryColor);
    if (pColor != null) _primaryColor = Color(pColor);

    final sColor = await _prefsService.loadInt(PreferencesService.keySecondaryColor);
    if (sColor != null) _secondaryColor = Color(sColor);

    _showGrid = await _prefsService.loadBool(PreferencesService.keyShowGrid) ?? true;
    _snapshots = await _prefsService.loadStringList(PreferencesService.keySnapshots) ?? [];
    _listBullet = await _prefsService.loadString(PreferencesService.keyListBullet) ?? '*';
    _sectionSpacing = await _prefsService.loadInt(PreferencesService.keySectionSpacing) ?? 1;
    _exportHtml = await _prefsService.loadBool(PreferencesService.keyExportHtml) ?? false;
    _geminiApiKey = await _prefsService.loadString(PreferencesService.keyGeminiApiKey);
    _githubToken = await _prefsService.loadString(PreferencesService.keyGithubToken);

    final localeCode = await _prefsService.loadString(PreferencesService.keyLocale);
    if (localeCode != null) _locale = Locale(localeCode);
    _targetLanguage = await _prefsService.loadString(PreferencesService.keyTargetLanguage) ?? 'en';

    notifyListeners();
  }

  void _recordHistory() {
    _undoStack.add(exportToJson());
    if (_undoStack.length > 30) _undoStack.removeAt(0);
    _redoStack.clear();
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(exportToJson());
    importFromJson(_undoStack.removeLast());
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(exportToJson());
    importFromJson(_redoStack.removeLast());
  }

  // --- Core Methods ---
  void addElement(ReadmeElementType type) {
    _recordHistory();
    final newElement = _createElementByType(type);
    _elements.add(newElement);
    _selectedElementId = newElement.id;
    _saveState();
    notifyListeners();
  }

  void insertElement(int index, ReadmeElementType type) {
    _recordHistory();
    final newElement = _createElementByType(type);
    _elements.insert(index.clamp(0, _elements.length), newElement);
    _selectedElementId = newElement.id;
    _saveState();
    notifyListeners();
  }

  void addSnippet(Snippet snippet) {
    _recordHistory();
    final newElement = ReadmeElement.fromJson(jsonDecode(snippet.elementJson));
    _elements.add(newElement);
    _saveState();
    notifyListeners();
  }

  void insertSnippet(int index, Snippet snippet) {
    _recordHistory();
    final newElement = ReadmeElement.fromJson(jsonDecode(snippet.elementJson));
    _elements.insert(index.clamp(0, _elements.length), newElement);
    _saveState();
    notifyListeners();
  }

  void removeElement(String id) {
    _recordHistory();
    _elements.removeWhere((e) => e.id == id);
    if (_selectedElementId == id) _selectedElementId = null;
    _saveState();
    notifyListeners();
  }

  void selectElement(String id) { _selectedElementId = id; notifyListeners(); }
  void toggleGrid() { _showGrid = !_showGrid; _saveState(); notifyListeners(); }
  void toggleTheme() { _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark; _saveState(); notifyListeners(); }
  void setDeviceMode(DeviceMode mode) { _deviceMode = mode; notifyListeners(); }
  void setLocale(Locale? locale) { _locale = locale; notifyListeners(); }
  void clearElements() { _recordHistory(); _elements.clear(); _saveState(); notifyListeners(); }
  
  void moveElementUp(String id) { 
    final i = _elements.indexWhere((e) => e.id == id);
    if (i > 0) { _recordHistory(); final e = _elements.removeAt(i); _elements.insert(i-1, e); _saveState(); notifyListeners(); }
  }
  
  void moveElementDown(String id) {
    final i = _elements.indexWhere((e) => e.id == id);
    if (i != -1 && i < _elements.length - 1) { _recordHistory(); final e = _elements.removeAt(i); _elements.insert(i+1, e); _saveState(); notifyListeners(); }
  }
  
  void duplicateElement(String id) {
    final i = _elements.indexWhere((e) => e.id == id);
    if (i != -1) { _recordHistory(); _elements.insert(i+1, _elements[i].copy()); _saveState(); notifyListeners(); }
  }
  
  void reorderElements(int oldI, int newI) {
    if (oldI < newI) newI -= 1;
    _recordHistory(); final e = _elements.removeAt(oldI); _elements.insert(newI, e); _saveState(); notifyListeners();
  }

  void updateElement() { _saveState(); notifyListeners(); }
  void updateVariable(String k, String v) { _variables[k] = v; _saveState(); notifyListeners(); }
  void setLicenseType(String t) { _licenseType = t; _saveState(); notifyListeners(); }
  void setIncludeContributing(bool v) { _includeContributing = v; _saveState(); notifyListeners(); }
  void setIncludeSecurity(bool v) { _includeSecurity = v; _saveState(); notifyListeners(); }
  void setIncludeSupport(bool v) { _includeSupport = v; _saveState(); notifyListeners(); }
  void setIncludeCodeOfConduct(bool v) { _includeCodeOfConduct = v; _saveState(); notifyListeners(); }
  void setIncludeIssueTemplates(bool v) { _includeIssueTemplates = v; _saveState(); notifyListeners(); }
  void setPrimaryColor(Color c) { _primaryColor = c; _saveState(); notifyListeners(); }
  void setSecondaryColor(Color c) { _secondaryColor = c; _saveState(); notifyListeners(); }
  void setExportHtml(bool v) { _exportHtml = v; _saveState(); notifyListeners(); }
  void setListBullet(String b) { _listBullet = b; _saveState(); notifyListeners(); }
  void setSectionSpacing(int s) { _sectionSpacing = s; _saveState(); notifyListeners(); }
  void setGeminiApiKey(String k) { _geminiApiKey = k; _prefsService.saveString(PreferencesService.keyGeminiApiKey, k); notifyListeners(); }
  void setGitHubToken(String t) { _githubToken = t; _prefsService.saveString(PreferencesService.keyGithubToken, t); notifyListeners(); }
  
  void saveSnapshot() { _snapshots.insert(0, exportToJson()); _saveState(); notifyListeners(); }
  void restoreSnapshot(int i) { if (i >= 0 && i < _snapshots.length) importFromJson(_snapshots[i]); }
  void deleteSnapshot(int i) { if (i >= 0 && i < _snapshots.length) { _snapshots.removeAt(i); _saveState(); notifyListeners(); } }
  
  void loadTemplate(ProjectTemplate t) { 
    _recordHistory(); 
    _elements.clear(); 
    _elements.addAll(t.elements.map((e) => e.copy())); 
    _saveState(); 
    notifyListeners(); 
  }
  
  Future<void> importMarkdown(String m) async { 
    _recordHistory(); 
    final e = MarkdownImporter().parse(m); 
    _elements.clear(); 
    _elements.addAll(e); 
    _saveState(); 
    notifyListeners(); 
  }

  String exportToJson() => jsonEncode({'elements': _elements.map((e) => e.toJson()).toList(), 'variables': _variables});
  
  void importFromJson(String s) {
    try {
      final d = jsonDecode(s);
      if (d['elements'] != null) {
        _elements.clear();
        for (var i in d['elements']) {
          _elements.add(ReadmeElement.fromJson(i));
        }
      }
      if (d['variables'] != null) {
        _variables.clear();
        _variables.addAll(Map<String, String>.from(d['variables']));
      }
      notifyListeners();
    } catch(e) {
      debugPrint("Error importing JSON: $e");
    }
  }

  Future<void> _saveState() async {
    _isSaving = true; // Start saving animation
    notifyListeners();
    
    await _prefsService.saveElements(_elements);
    await _prefsService.saveVariables(_variables);
    await _prefsService.saveStringList(PreferencesService.keySnapshots, _snapshots);
    
    _isSaving = false; // End saving animation
    notifyListeners();
  }

  ReadmeElement _createElementByType(ReadmeElementType type) {
    switch (type) {
      case ReadmeElementType.heading: return HeadingElement();
      case ReadmeElementType.paragraph: return ParagraphElement();
      case ReadmeElementType.codeBlock: return CodeBlockElement();
      case ReadmeElementType.image: return ImageElement();
      case ReadmeElementType.list: return ListElement();
      case ReadmeElementType.badge: return BadgeElement();
      case ReadmeElementType.table: return TableElement();
      case ReadmeElementType.linkButton: return LinkButtonElement();
      case ReadmeElementType.icon: return IconElement();
      case ReadmeElementType.embed: return EmbedElement();
      case ReadmeElementType.githubStats: return GitHubStatsElement();
      case ReadmeElementType.contributors: return ContributorsElement();
      case ReadmeElementType.mermaid: return MermaidElement();
      case ReadmeElementType.toc: return TOCElement();
      case ReadmeElementType.socials: return SocialsElement();
      case ReadmeElementType.blockquote: return BlockquoteElement();
      case ReadmeElementType.divider: return DividerElement();
      case ReadmeElementType.collapsible: return CollapsibleElement();
      case ReadmeElementType.dynamicWidget: return DynamicWidgetElement();
      case ReadmeElementType.raw: return RawElement();
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/readme_element.dart';

class PreferencesService {
  static const String keyIsDarkMode = 'isDarkMode';
  static const String keyElements = 'elements';
  static const String keyVariables = 'variables';
  static const String keyLicenseType = 'licenseType';
  static const String keyIncludeContributing = 'includeContributing';
  static const String keyIncludeSecurity = 'includeSecurity';
  static const String keyIncludeSupport = 'includeSupport';
  static const String keyIncludeCodeOfConduct = 'includeCodeOfConduct';
  static const String keyIncludeIssueTemplates = 'includeIssueTemplates';
  static const String keyPrimaryColor = 'primaryColor';
  static const String keySecondaryColor = 'secondaryColor';
  static const String keyShowGrid = 'showGrid';
  static const String keySnapshots = 'snapshots';
  static const String keyListBullet = 'listBullet';
  static const String keySectionSpacing = 'sectionSpacing';
  static const String keyExportHtml = 'exportHtml';
  static const String keyGeminiApiKey = 'gemini_api_key';
  static const String keyGithubToken = 'github_token';
  static const String keyLocale = 'locale';
  static const String keyTargetLanguage = 'targetLanguage';
  static const String keySavedProjects = 'saved_projects';
  static const String keySavedSnippets = 'saved_snippets';
  static const String keyHasSeenOnboarding = 'hasSeenOnboarding';
  static const String keyHasSeenSetupWizard = 'hasSeenSetupWizard';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await _getInstance();
    if (prefs.containsKey(keyIsDarkMode)) {
      final isDark = prefs.getBool(keyIsDarkMode) ?? false;
      return isDark ? ThemeMode.dark : ThemeMode.light;
    }
    return ThemeMode.system;
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await _getInstance();
    if (mode == ThemeMode.system) {
      await prefs.remove(keyIsDarkMode);
    } else {
      await prefs.setBool(keyIsDarkMode, mode == ThemeMode.dark);
    }
  }

  Future<List<ReadmeElement>> loadElements() async {
    final prefs = await _getInstance();
    final elementsJson = prefs.getString(keyElements);
    if (elementsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(elementsJson);
        return decoded.map((e) => ReadmeElement.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading elements: $e');
      }
    }
    return [];
  }

  Future<void> saveElements(List<ReadmeElement> elements) async {
    final prefs = await _getInstance();
    final elementsJson = jsonEncode(elements.map((e) => e.toJson()).toList());
    await prefs.setString(keyElements, elementsJson);
  }

  Future<Map<String, String>> loadVariables() async {
    final prefs = await _getInstance();
    final variablesJson = prefs.getString(keyVariables);
    if (variablesJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(variablesJson);
        return decoded.cast<String, String>();
      } catch (e) {
        debugPrint('Error loading variables: $e');
      }
    }
    return {};
  }

  Future<void> saveVariables(Map<String, String> variables) async {
    final prefs = await _getInstance();
    final variablesJson = jsonEncode(variables);
    await prefs.setString(keyVariables, variablesJson);
  }

  Future<void> saveString(String key, String value) async {
    final prefs = await _getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> loadString(String key) async {
    final prefs = await _getInstance();
    return prefs.getString(key);
  }

  Future<void> saveBool(String key, bool value) async {
    final prefs = await _getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool?> loadBool(String key) async {
    final prefs = await _getInstance();
    return prefs.getBool(key);
  }

  Future<void> saveInt(String key, int value) async {
    final prefs = await _getInstance();
    await prefs.setInt(key, value);
  }

  Future<int?> loadInt(String key) async {
    final prefs = await _getInstance();
    return prefs.getInt(key);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await _getInstance();
    await prefs.setStringList(key, value);
  }

  Future<List<String>?> loadStringList(String key) async {
    final prefs = await _getInstance();
    return prefs.getStringList(key);
  }

  Future<void> remove(String key) async {
    final prefs = await _getInstance();
    await prefs.remove(key);
  }
}

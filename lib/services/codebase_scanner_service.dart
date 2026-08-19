import 'dart:io';
import 'package:path/path.dart' as path;

class CodebaseScannerService {
  static const List<String> _ignoredDirectories = [
    '.git',
    '.idea',
    '.vscode',
    'build',
    'dist',
    'node_modules',
    'android',
    'ios',
    'windows',
    'linux',
    'macos',
    'web',
    'coverage',
    '__pycache__',
    'venv',
    'env',
    '.dart_tool',
  ];

  static const List<String> _ignoredExtensions = [
    '.png', '.jpg', '.jpeg', '.gif', '.ico', '.svg', '.webp',
    '.mp4', '.mov', '.avi',
    '.mp3', '.wav',
    '.pdf', '.doc', '.docx',
    '.zip', '.tar', '.gz', '.rar',
    '.exe', '.dll', '.so', '.dylib', '.bin',
    '.class', '.o', '.obj',
    '.lock', '.log',
    '.ttf', '.otf', '.woff', '.woff2',
    '.db', '.sqlite', '.sqlite3',
  ];

  static Future<String> scanDirectory(String directoryPath) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      throw Exception('Directory not found: $directoryPath');
    }

    final buffer = StringBuffer();
    buffer.writeln('Project Codebase Context:');
    buffer.writeln('=========================\n');

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        if (_shouldIgnore(entity.path, directoryPath)) continue;

        try {
          // Check if it's likely a text file
          if (_isBinary(entity.path)) continue;

          final content = await entity.readAsString();
          final relativePath = path.relative(entity.path, from: directoryPath);

          buffer.writeln('File: $relativePath');
          buffer.writeln('---START---');
          buffer.writeln(content);
          buffer.writeln('---END---\n');
        } catch (e) {
          // Skip files that can't be read as string (likely binary or encoding issues)
          continue;
        }
      }
    }

    return buffer.toString();
  }

  static bool _shouldIgnore(String filePath, String rootPath) {
    final relativePath = path.relative(filePath, from: rootPath);
    final parts = path.split(relativePath);

    // Check directories
    for (final part in parts) {
      if (_ignoredDirectories.contains(part)) return true;
      if (part.startsWith('.')) return true; // Ignore hidden files/folders generally
    }

    // Check extension
    final ext = path.extension(filePath).toLowerCase();
    if (_ignoredExtensions.contains(ext)) return true;

    return false;
  }

  static bool _isBinary(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    const binaryExtensions = [
      '.png', '.jpg', '.jpeg', '.gif', '.ico', '.svg', '.webp', '.bmp', '.tiff',
      '.mp4', '.mov', '.avi', '.mkv', '.flv', '.wmv',
      '.mp3', '.wav', '.flac', '.aac', '.ogg',
      '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
      '.zip', '.tar', '.gz', '.rar', '.7z',
      '.exe', '.dll', '.so', '.dylib',
      '.woff', '.woff2', '.ttf', '.eot',
      '.sqlite', '.db',
    ];
    return binaryExtensions.contains(ext);
  }
}


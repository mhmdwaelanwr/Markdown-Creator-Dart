import 'package:uuid/uuid.dart';
import 'dart:typed_data';

enum ReadmeElementType {
  heading,
  paragraph,
  image,
  linkButton,
  codeBlock,
  list,
  badge,
  table,
  icon,
  embed,
  githubStats,
  contributors,
  mermaid,
  toc,
  socials,
  blockquote,
  divider,
  raw,
  collapsible,
  dynamicWidget,
}

abstract class ReadmeElement {
  final String id;
  final ReadmeElementType type;

  ReadmeElement({required this.type, String? id}) : id = id ?? const Uuid().v4();

  String get description;

  Map<String, dynamic> toJson();
  
  ReadmeElement copy();

  factory ReadmeElement.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = ReadmeElementType.values.firstWhere(
      (e) => e.toString() == typeStr || e.name == typeStr,
      orElse: () => throw Exception('Unknown element type: $typeStr'),
    );
    switch (type) {
      case ReadmeElementType.heading:
        return HeadingElement.fromJson(json);
      case ReadmeElementType.paragraph:
        return ParagraphElement.fromJson(json);
      case ReadmeElementType.image:
        return ImageElement.fromJson(json);
      case ReadmeElementType.linkButton:
        return LinkButtonElement.fromJson(json);
      case ReadmeElementType.codeBlock:
        return CodeBlockElement.fromJson(json);
      case ReadmeElementType.list:
        return ListElement.fromJson(json);
      case ReadmeElementType.badge:
        return BadgeElement.fromJson(json);
      case ReadmeElementType.table:
        return TableElement.fromJson(json);
      case ReadmeElementType.icon:
        return IconElement.fromJson(json);
      case ReadmeElementType.embed:
        return EmbedElement.fromJson(json);
      case ReadmeElementType.githubStats:
        return GitHubStatsElement.fromJson(json);
      case ReadmeElementType.contributors:
        return ContributorsElement.fromJson(json);
      case ReadmeElementType.mermaid:
        return MermaidElement.fromJson(json);
      case ReadmeElementType.toc:
        return TOCElement.fromJson(json);
      case ReadmeElementType.socials:
        return SocialsElement.fromJson(json);
      case ReadmeElementType.blockquote:
        return BlockquoteElement.fromJson(json);
      case ReadmeElementType.divider:
        return DividerElement.fromJson(json);
      case ReadmeElementType.raw:
        return RawElement.fromJson(json);
      case ReadmeElementType.collapsible:
        return CollapsibleElement.fromJson(json);
      case ReadmeElementType.dynamicWidget:
        return DynamicWidgetElement.fromJson(json);
    }
  }
}

class SocialProfile {
  final String platform;
  final String username;

  SocialProfile({required this.platform, required this.username});

  Map<String, dynamic> toJson() => {
    'platform': platform,
    'username': username,
  };

  factory SocialProfile.fromJson(Map<String, dynamic> json) {
    return SocialProfile(
      platform: json['platform'],
      username: json['username'],
    );
  }

  SocialProfile copy() => SocialProfile(platform: platform, username: username);
}

class SocialsElement extends ReadmeElement {
  List<SocialProfile> profiles;
  String style;

  SocialsElement({List<SocialProfile>? profiles, this.style = 'for-the-badge', super.id})
      : profiles = profiles ?? [],
        super(type: ReadmeElementType.socials);

  @override
  String get description => 'Social Links';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'profiles': profiles.map((e) => e.toJson()).toList(),
    'style': style,
  };

  @override
  SocialsElement copy() => SocialsElement(
    profiles: profiles.map((p) => p.copy()).toList(),
    style: style,
  );

  factory SocialsElement.fromJson(Map<String, dynamic> json) {
    return SocialsElement(
      profiles: (json['profiles'] as List).map((e) => SocialProfile.fromJson(e)).toList(),
      style: json['style'] ?? 'for-the-badge',
      id: json['id'],
    );
  }
}

class MermaidElement extends ReadmeElement {
  String code;

  MermaidElement({this.code = 'graph TD;\n    A-->B;', super.id}) : super(type: ReadmeElementType.mermaid);

  @override
  String get description => 'Mermaid Diagram';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'code': code,
  };

  @override
  MermaidElement copy() => MermaidElement(code: code);

  factory MermaidElement.fromJson(Map<String, dynamic> json) {
    return MermaidElement(
      code: json['code'] ?? '',
      id: json['id'],
    );
  }
}

class TOCElement extends ReadmeElement {
  String title;

  TOCElement({this.title = 'Table of Contents', super.id}) : super(type: ReadmeElementType.toc);

  @override
  String get description => 'Table of Contents';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'title': title,
  };

  @override
  TOCElement copy() => TOCElement(title: title);

  factory TOCElement.fromJson(Map<String, dynamic> json) {
    return TOCElement(
      title: json['title'] ?? 'Table of Contents',
      id: json['id'],
    );
  }
}

class HeadingElement extends ReadmeElement {
  String text;
  int level;

  HeadingElement({this.text = 'Heading', this.level = 1, super.id}) : super(type: ReadmeElementType.heading);

  @override
  String get description => 'Heading $level';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'text': text,
    'level': level,
  };

  @override
  HeadingElement copy() => HeadingElement(text: text, level: level);

  factory HeadingElement.fromJson(Map<String, dynamic> json) {
    return HeadingElement(
      text: json['text'],
      level: json['level'],
      id: json['id'],
    );
  }
}

class ParagraphElement extends ReadmeElement {
  String text;

  ParagraphElement({this.text = 'Paragraph text', super.id}) : super(type: ReadmeElementType.paragraph);

  @override
  String get description => 'Paragraph';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'text': text,
  };

  @override
  ParagraphElement copy() => ParagraphElement(text: text);

  factory ParagraphElement.fromJson(Map<String, dynamic> json) {
    return ParagraphElement(
      text: json['text'],
      id: json['id'],
    );
  }
}

class ImageElement extends ReadmeElement {
  String url;
  String altText;
  double? width;
  Uint8List? localData;

  ImageElement({this.url = 'https://placehold.co/600x400/e2e8f0/475569?text=Your+Image', this.altText = 'Image', this.width, this.localData, super.id}) : super(type: ReadmeElementType.image);

  @override
  String get description => 'Image';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'url': url,
    'altText': altText,
    'width': width,
  };

  @override
  ImageElement copy() => ImageElement(
    url: url,
    altText: altText,
    width: width,
    localData: localData != null ? Uint8List.fromList(localData!) : null,
  );

  factory ImageElement.fromJson(Map<String, dynamic> json) {
    return ImageElement(
      url: json['url'],
      altText: json['altText'],
      width: json['width'],
      id: json['id'],
    );
  }
}

class LinkButtonElement extends ReadmeElement {
  String text;
  String url;

  LinkButtonElement({this.text = 'Link', this.url = 'https://example.com', super.id}) : super(type: ReadmeElementType.linkButton);

  @override
  String get description => 'Link Button';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'text': text,
    'url': url,
  };

  @override
  LinkButtonElement copy() => LinkButtonElement(text: text, url: url);

  factory LinkButtonElement.fromJson(Map<String, dynamic> json) {
    return LinkButtonElement(
      text: json['text'],
      url: json['url'],
      id: json['id'],
    );
  }
}

class CodeBlockElement extends ReadmeElement {
  String code;
  String language;

  CodeBlockElement({this.code = 'print("Hello World");', this.language = 'dart', super.id}) : super(type: ReadmeElementType.codeBlock);

  @override
  String get description => 'Code Block';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'code': code,
    'language': language,
  };

  @override
  CodeBlockElement copy() => CodeBlockElement(code: code, language: language);

  factory CodeBlockElement.fromJson(Map<String, dynamic> json) {
    return CodeBlockElement(
      code: json['code'],
      language: json['language'],
      id: json['id'],
    );
  }
}

class ListElement extends ReadmeElement {
  List<String> items;
  bool isOrdered;

  ListElement({List<String>? items, this.isOrdered = false, super.id}) : items = items ?? ['Item 1'], super(type: ReadmeElementType.list);

  @override
  String get description => 'List';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'items': items,
    'isOrdered': isOrdered,
  };

  @override
  ListElement copy() => ListElement(items: List<String>.from(items), isOrdered: isOrdered);

  factory ListElement.fromJson(Map<String, dynamic> json) {
    return ListElement(
      items: List<String>.from(json['items']),
      isOrdered: json['isOrdered'] ?? false,
      id: json['id'],
    );
  }
}

class BadgeElement extends ReadmeElement {
  String imageUrl;
  String targetUrl;
  String label;
  String? badgeLabel;
  String? badgeMessage;
  String? badgeColor;
  String? badgeStyle;
  String? badgeLogo;
  String? badgeLogoColor;
  String? badgeLabelColor;

  BadgeElement({
    this.imageUrl = 'https://img.shields.io/badge/Label-Message-blue',
    this.targetUrl = '',
    this.label = 'Badge',
    this.badgeLabel,
    this.badgeMessage,
    this.badgeColor,
    this.badgeStyle,
    this.badgeLogo,
    this.badgeLogoColor,
    this.badgeLabelColor,
    super.id
  }) : super(type: ReadmeElementType.badge);

  @override
  String get description => 'Badge: $label';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'imageUrl': imageUrl,
    'targetUrl': targetUrl,
    'label': label,
    'badgeLabel': badgeLabel,
    'badgeMessage': badgeMessage,
    'badgeColor': badgeColor,
    'badgeStyle': badgeStyle,
    'badgeLogo': badgeLogo,
    'badgeLogoColor': badgeLogoColor,
    'badgeLabelColor': badgeLabelColor,
  };

  @override
  BadgeElement copy() => BadgeElement(
    imageUrl: imageUrl,
    targetUrl: targetUrl,
    label: label,
    badgeLabel: badgeLabel,
    badgeMessage: badgeMessage,
    badgeColor: badgeColor,
    badgeStyle: badgeStyle,
    badgeLogo: badgeLogo,
    badgeLogoColor: badgeLogoColor,
    badgeLabelColor: badgeLabelColor,
  );

  factory BadgeElement.fromJson(Map<String, dynamic> json) {
    return BadgeElement(
      imageUrl: json['imageUrl'],
      targetUrl: json['targetUrl'],
      label: json['label'],
      badgeLabel: json['badgeLabel'],
      badgeMessage: json['badgeMessage'],
      badgeColor: json['badgeColor'],
      badgeStyle: json['badgeStyle'],
      badgeLogo: json['badgeLogo'],
      badgeLogoColor: json['badgeLogoColor'],
      badgeLabelColor: json['badgeLabelColor'],
      id: json['id'],
    );
  }
}

enum ColumnAlignment { left, center, right }

class TableElement extends ReadmeElement {
  List<String> headers;
  List<List<String>> rows;
  List<ColumnAlignment> alignments;

  TableElement({
    List<String>? headers,
    List<List<String>>? rows,
    List<ColumnAlignment>? alignments,
    super.id,
  })  : headers = headers != null ? List<String>.from(headers) : ['Header 1', 'Header 2'],
        rows = rows != null
            ? rows.map((r) => List<String>.from(r)).toList()
            : [['Cell 1', 'Cell 2']],
        alignments = alignments != null
            ? List<ColumnAlignment>.from(alignments)
            : [ColumnAlignment.left, ColumnAlignment.left],
        super(type: ReadmeElementType.table);

  @override
  String get description => 'Table';

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString(),
        'headers': headers,
        'rows': rows,
        'alignments': alignments.map((e) => e.toString()).toList(),
      };

  @override
  TableElement copy() => TableElement(
    headers: List<String>.from(headers),
    rows: rows.map((r) => List<String>.from(r)).toList(),
    alignments: List<ColumnAlignment>.from(alignments),
  );

  factory TableElement.fromJson(Map<String, dynamic> json) {
    return TableElement(
      headers: List<String>.from(json['headers']),
      rows: (json['rows'] as List).map((row) => List<String>.from(row)).toList(),
      alignments: (json['alignments'] as List).map((e) {
        if (e is int) {
          if (e >= 0 && e < ColumnAlignment.values.length) {
            return ColumnAlignment.values[e];
          }
          return ColumnAlignment.left;
        }
        final str = e.toString();
        return ColumnAlignment.values.firstWhere(
          (a) => a.toString() == str || a.name == str,
          orElse: () => ColumnAlignment.left,
        );
      }).toList(),
      id: json['id'],
    );
  }
}

class IconElement extends ReadmeElement {
  String name;
  String url;
  double size;

  IconElement({this.name = 'Flutter', this.url = 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg', this.size = 40, super.id}) : super(type: ReadmeElementType.icon);

  @override
  String get description => 'Icon: $name';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'name': name,
    'url': url,
    'size': size,
  };

  @override
  IconElement copy() => IconElement(name: name, url: url, size: size);

  factory IconElement.fromJson(Map<String, dynamic> json) {
    return IconElement(
      name: json['name'],
      url: json['url'],
      size: json['size']?.toDouble() ?? 40.0,
      id: json['id'],
    );
  }
}

class EmbedElement extends ReadmeElement {
  String url;
  String typeName;

  EmbedElement({this.url = '', this.typeName = 'gist', super.id}) : super(type: ReadmeElementType.embed);

  @override
  String get description => 'Embed: $typeName';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'url': url,
    'typeName': typeName,
  };

  @override
  EmbedElement copy() => EmbedElement(url: url, typeName: typeName);

  factory EmbedElement.fromJson(Map<String, dynamic> json) {
    return EmbedElement(
      url: json['url'],
      typeName: json['typeName'],
      id: json['id'],
    );
  }
}

class GitHubStatsElement extends ReadmeElement {
  String repoName;
  bool showStars;
  bool showForks;
  bool showIssues;
  bool showLicense;

  GitHubStatsElement({
    this.repoName = '',
    this.showStars = true,
    this.showForks = true,
    this.showIssues = true,
    this.showLicense = true,
    super.id,
  }) : super(type: ReadmeElementType.githubStats);

  @override
  String get description => 'GitHub Stats';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'repoName': repoName,
    'showStars': showStars,
    'showForks': showForks,
    'showIssues': showIssues,
    'showLicense': showLicense,
  };

  @override
  GitHubStatsElement copy() => GitHubStatsElement(
    repoName: repoName,
    showStars: showStars,
    showForks: showForks,
    showIssues: showIssues,
    showLicense: showLicense,
  );

  factory GitHubStatsElement.fromJson(Map<String, dynamic> json) {
    return GitHubStatsElement(
      repoName: json['repoName'] ?? '',
      showStars: json['showStars'] ?? true,
      showForks: json['showForks'] ?? true,
      showIssues: json['showIssues'] ?? true,
      showLicense: json['showLicense'] ?? true,
      id: json['id'],
    );
  }
}

class ContributorsElement extends ReadmeElement {
  String repoName;
  String style;

  ContributorsElement({
    this.repoName = '',
    this.style = 'grid',
    super.id,
  }) : super(type: ReadmeElementType.contributors);

  @override
  String get description => 'Contributors';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'repoName': repoName,
    'style': style,
  };

  @override
  ContributorsElement copy() => ContributorsElement(repoName: repoName, style: style);

  factory ContributorsElement.fromJson(Map<String, dynamic> json) {
    return ContributorsElement(
      repoName: json['repoName'] ?? '',
      style: json['style'] ?? 'grid',
      id: json['id'],
    );
  }
}

class BlockquoteElement extends ReadmeElement {
  String text;

  BlockquoteElement({this.text = 'Blockquote text', super.id}) : super(type: ReadmeElementType.blockquote);

  @override
  String get description => 'Blockquote';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'text': text,
  };

  @override
  BlockquoteElement copy() => BlockquoteElement(text: text);

  factory BlockquoteElement.fromJson(Map<String, dynamic> json) {
    return BlockquoteElement(
      text: json['text'],
      id: json['id'],
    );
  }
}

class DividerElement extends ReadmeElement {
  DividerElement({super.id}) : super(type: ReadmeElementType.divider);

  @override
  String get description => 'Divider';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
  };

  @override
  DividerElement copy() => DividerElement();

  factory DividerElement.fromJson(Map<String, dynamic> json) {
    return DividerElement(id: json['id']);
  }
}

class CollapsibleElement extends ReadmeElement {
  String summary;
  String content;

  CollapsibleElement({this.summary = 'Click to expand', this.content = 'Hidden content', super.id}) : super(type: ReadmeElementType.collapsible);

  @override
  String get description => 'Collapsible Section';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'summary': summary,
    'content': content,
  };

  @override
  CollapsibleElement copy() => CollapsibleElement(summary: summary, content: content);

  factory CollapsibleElement.fromJson(Map<String, dynamic> json) {
    return CollapsibleElement(
      summary: json['summary'],
      content: json['content'],
      id: json['id'],
    );
  }
}

enum DynamicWidgetType { spotify, youtube, medium, activity }

class DynamicWidgetElement extends ReadmeElement {
  DynamicWidgetType widgetType;
  String identifier;
  String theme;

  DynamicWidgetElement({
    this.widgetType = DynamicWidgetType.spotify,
    this.identifier = '',
    this.theme = 'default',
    super.id,
  }) : super(type: ReadmeElementType.dynamicWidget);

  @override
  String get description => 'Dynamic Widget: ${widgetType.name}';

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString(),
        'widgetType': widgetType.toString(),
        'identifier': identifier,
        'theme': theme,
      };

  @override
  DynamicWidgetElement copy() => DynamicWidgetElement(
    widgetType: widgetType,
    identifier: identifier,
    theme: theme,
  );

  factory DynamicWidgetElement.fromJson(Map<String, dynamic> json) {
    return DynamicWidgetElement(
      widgetType: DynamicWidgetType.values.firstWhere(
          (e) => e.toString() == json['widgetType'] || e.name == json['widgetType'],
          orElse: () => DynamicWidgetType.spotify),
      identifier: json['identifier'] ?? '',
      theme: json['theme'] ?? 'default',
      id: json['id'],
    );
  }
}

class RawElement extends ReadmeElement {
  String content;
  String css;

  RawElement({this.content = '', this.css = '', super.id}) : super(type: ReadmeElementType.raw);

  @override
  String get description => 'Raw Markdown / HTML';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'content': content,
    'css': css,
  };

  @override
  RawElement copy() => RawElement(content: content, css: css);

  factory RawElement.fromJson(Map<String, dynamic> json) {
    return RawElement(
      content: json['content'] ?? '',
      css: json['css'] ?? '',
      id: json['id'],
    );
  }
}

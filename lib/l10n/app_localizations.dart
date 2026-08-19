import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Markdown Studio Pro'**
  String get appTitle;

  /// No description provided for @saveToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Save to Library'**
  String get saveToLibrary;

  /// No description provided for @localSnapshots.
  ///
  /// In en, this message translates to:
  /// **'Local Snapshots'**
  String get localSnapshots;

  /// No description provided for @clearWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Clear Workspace'**
  String get clearWorkspace;

  /// No description provided for @importMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Import Markdown'**
  String get importMarkdown;

  /// No description provided for @socialPreviewDesigner.
  ///
  /// In en, this message translates to:
  /// **'Social Preview Designer'**
  String get socialPreviewDesigner;

  /// No description provided for @githubActionsGenerator.
  ///
  /// In en, this message translates to:
  /// **'GitHub Actions Generator'**
  String get githubActionsGenerator;

  /// No description provided for @exportProjectJson.
  ///
  /// In en, this message translates to:
  /// **'Export Project (JSON)'**
  String get exportProjectJson;

  /// No description provided for @importProjectJson.
  ///
  /// In en, this message translates to:
  /// **'Import Project (JSON)'**
  String get importProjectJson;

  /// No description provided for @aiSettings.
  ///
  /// In en, this message translates to:
  /// **'AI Settings'**
  String get aiSettings;

  /// No description provided for @generateFromCodebase.
  ///
  /// In en, this message translates to:
  /// **'Scan Codebase (AI)'**
  String get generateFromCodebase;

  /// No description provided for @showTour.
  ///
  /// In en, this message translates to:
  /// **'Show Tour'**
  String get showTour;

  /// No description provided for @keyboardShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get keyboardShortcuts;

  /// No description provided for @aboutDeveloper.
  ///
  /// In en, this message translates to:
  /// **'About Developer'**
  String get aboutDeveloper;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get changeLanguage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @projectSaved.
  ///
  /// In en, this message translates to:
  /// **'Project saved successfully'**
  String get projectSaved;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @confirmClearWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Clear Workspace?'**
  String get confirmClearWorkspace;

  /// No description provided for @confirmClearWorkspaceContent.
  ///
  /// In en, this message translates to:
  /// **'This will remove all elements. This action cannot be undone.'**
  String get confirmClearWorkspaceContent;

  /// No description provided for @pickProjectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get pickProjectFolder;

  /// No description provided for @repoUrl.
  ///
  /// In en, this message translates to:
  /// **'Repository URL'**
  String get repoUrl;

  /// No description provided for @scanAndGenerate.
  ///
  /// In en, this message translates to:
  /// **'Analyze & Generate'**
  String get scanAndGenerate;

  /// No description provided for @geminiApiKey.
  ///
  /// In en, this message translates to:
  /// **'Gemini API Key'**
  String get geminiApiKey;

  /// No description provided for @githubToken.
  ///
  /// In en, this message translates to:
  /// **'GitHub Token'**
  String get githubToken;

  /// No description provided for @getApiKey.
  ///
  /// In en, this message translates to:
  /// **'Get API key from Google'**
  String get getApiKey;

  /// No description provided for @generateToken.
  ///
  /// In en, this message translates to:
  /// **'Generate GitHub Token'**
  String get generateToken;

  /// No description provided for @elements.
  ///
  /// In en, this message translates to:
  /// **'Elements'**
  String get elements;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get words;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Optimal'**
  String get healthy;

  /// No description provided for @errors.
  ///
  /// In en, this message translates to:
  /// **'Critical Issues'**
  String get errors;

  /// No description provided for @warnings.
  ///
  /// In en, this message translates to:
  /// **'Improvements'**
  String get warnings;

  /// No description provided for @focusMode.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusMode;

  /// No description provided for @autoSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes Saved'**
  String get autoSaved;

  /// No description provided for @projectSettings.
  ///
  /// In en, this message translates to:
  /// **'Project Settings'**
  String get projectSettings;

  /// No description provided for @variables.
  ///
  /// In en, this message translates to:
  /// **'Variables'**
  String get variables;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @contributing.
  ///
  /// In en, this message translates to:
  /// **'Contributing'**
  String get contributing;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Branding Colors'**
  String get colors;

  /// No description provided for @formatting.
  ///
  /// In en, this message translates to:
  /// **'Formatting'**
  String get formatting;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// No description provided for @secondaryColor.
  ///
  /// In en, this message translates to:
  /// **'Secondary Color'**
  String get secondaryColor;

  /// No description provided for @exportHtml.
  ///
  /// In en, this message translates to:
  /// **'Export HTML'**
  String get exportHtml;

  /// No description provided for @listBulletStyle.
  ///
  /// In en, this message translates to:
  /// **'Bullet Style'**
  String get listBulletStyle;

  /// No description provided for @sectionSpacing.
  ///
  /// In en, this message translates to:
  /// **'Section Spacing'**
  String get sectionSpacing;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @load.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// No description provided for @viewOnGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get viewOnGithub;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @rightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get rightsReserved;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings updated!'**
  String get settingsSaved;

  /// No description provided for @commonShortcuts.
  ///
  /// In en, this message translates to:
  /// **'General Shortcuts'**
  String get commonShortcuts;

  /// No description provided for @elementShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Editor Shortcuts'**
  String get elementShortcuts;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @openProject.
  ///
  /// In en, this message translates to:
  /// **'Open Project'**
  String get openProject;

  /// No description provided for @saveProject.
  ///
  /// In en, this message translates to:
  /// **'Save Project'**
  String get saveProject;

  /// No description provided for @exportProject.
  ///
  /// In en, this message translates to:
  /// **'Export Project'**
  String get exportProject;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print PDF'**
  String get print;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @showPreview.
  ///
  /// In en, this message translates to:
  /// **'Live Preview'**
  String get showPreview;

  /// No description provided for @toggleGrid.
  ///
  /// In en, this message translates to:
  /// **'Toggle Grid'**
  String get toggleGrid;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get toggleTheme;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get openSettings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get help;

  /// No description provided for @addHeading.
  ///
  /// In en, this message translates to:
  /// **'Add Heading'**
  String get addHeading;

  /// No description provided for @addSubheading.
  ///
  /// In en, this message translates to:
  /// **'Add Subheading'**
  String get addSubheading;

  /// No description provided for @addParagraph.
  ///
  /// In en, this message translates to:
  /// **'Add Paragraph'**
  String get addParagraph;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @addTable.
  ///
  /// In en, this message translates to:
  /// **'Add Table'**
  String get addTable;

  /// No description provided for @addList.
  ///
  /// In en, this message translates to:
  /// **'Add List'**
  String get addList;

  /// No description provided for @addQuote.
  ///
  /// In en, this message translates to:
  /// **'Add Quote'**
  String get addQuote;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add Link'**
  String get addLink;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'The ultimate SaaS suite for professional Markdown documentation. Built for speed, precision, and efficiency.'**
  String get aboutDescription;

  /// No description provided for @enterGeminiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter Gemini API Key to unlock AI features.'**
  String get enterGeminiKey;

  /// No description provided for @githubIntegration.
  ///
  /// In en, this message translates to:
  /// **'GitHub Sync'**
  String get githubIntegration;

  /// No description provided for @enterGithubToken.
  ///
  /// In en, this message translates to:
  /// **'Optional: GitHub Token for enhanced repository scanning.'**
  String get enterGithubToken;

  /// No description provided for @localFolder.
  ///
  /// In en, this message translates to:
  /// **'Local Directory'**
  String get localFolder;

  /// No description provided for @githubRepo.
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository'**
  String get githubRepo;

  /// No description provided for @scanLocalFolder.
  ///
  /// In en, this message translates to:
  /// **'Scan a folder to build documentation.'**
  String get scanLocalFolder;

  /// No description provided for @scanGithubRepo.
  ///
  /// In en, this message translates to:
  /// **'Generate docs from a public GitHub repo.'**
  String get scanGithubRepo;

  /// No description provided for @fetchingRepo.
  ///
  /// In en, this message translates to:
  /// **'Syncing repository...'**
  String get fetchingRepo;

  /// No description provided for @analyzingAI.
  ///
  /// In en, this message translates to:
  /// **'AI Engine Analyzing...'**
  String get analyzingAI;

  /// No description provided for @readmeGenerated.
  ///
  /// In en, this message translates to:
  /// **'README crafted successfully!'**
  String get readmeGenerated;

  /// No description provided for @projectImported.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get projectImported;

  /// No description provided for @contentFetched.
  ///
  /// In en, this message translates to:
  /// **'Content ready for review.'**
  String get contentFetched;

  /// No description provided for @fetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync Failed'**
  String get fetchFailed;

  /// No description provided for @generateExtraFiles.
  ///
  /// In en, this message translates to:
  /// **'Extra Project Files'**
  String get generateExtraFiles;

  /// No description provided for @publishToGithub.
  ///
  /// In en, this message translates to:
  /// **'Push to GitHub'**
  String get publishToGithub;

  /// No description provided for @contributionGuidelinesBuilder.
  ///
  /// In en, this message translates to:
  /// **'Community Builder'**
  String get contributionGuidelinesBuilder;

  /// No description provided for @contributionGuidelinesDesc.
  ///
  /// In en, this message translates to:
  /// **'Standard open-source guidelines.'**
  String get contributionGuidelinesDesc;

  /// No description provided for @contributingMdDesc.
  ///
  /// In en, this message translates to:
  /// **'Contribution workflow guide.'**
  String get contributingMdDesc;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @codeOfConductDesc.
  ///
  /// In en, this message translates to:
  /// **'Code of Conduct policy.'**
  String get codeOfConductDesc;

  /// No description provided for @githubTokenMissing.
  ///
  /// In en, this message translates to:
  /// **'GitHub Token required.'**
  String get githubTokenMissing;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @repoName.
  ///
  /// In en, this message translates to:
  /// **'Repo Name'**
  String get repoName;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchName;

  /// No description provided for @commitMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get commitMessage;

  /// No description provided for @publishDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a new branch and PR instantly.'**
  String get publishDialogDesc;

  /// No description provided for @ownerRepoRequired.
  ///
  /// In en, this message translates to:
  /// **'Identity required'**
  String get ownerRepoRequired;

  /// No description provided for @prCreated.
  ///
  /// In en, this message translates to:
  /// **'Pull Request Sent!'**
  String get prCreated;

  /// No description provided for @viewPrs.
  ///
  /// In en, this message translates to:
  /// **'Open PRs'**
  String get viewPrs;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copiedToClipboard;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'PRO ACTIVE'**
  String get proActive;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'FREE PLAN'**
  String get freePlan;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @becomeSponsor.
  ///
  /// In en, this message translates to:
  /// **'Become a Sponsor'**
  String get becomeSponsor;

  /// No description provided for @claimReward.
  ///
  /// In en, this message translates to:
  /// **'Claim Reward'**
  String get claimReward;

  /// No description provided for @supportAndFeedback.
  ///
  /// In en, this message translates to:
  /// **'Support & Feedback'**
  String get supportAndFeedback;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @proMembers.
  ///
  /// In en, this message translates to:
  /// **'Pro Members'**
  String get proMembers;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'User Feedback'**
  String get feedbackTitle;

  /// No description provided for @viewAttachment.
  ///
  /// In en, this message translates to:
  /// **'View Attachment'**
  String get viewAttachment;

  /// No description provided for @dragAndDropHint.
  ///
  /// In en, this message translates to:
  /// **'Drag & Drop files here'**
  String get dragAndDropHint;

  /// No description provided for @ctrlPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Ctrl+V to paste image'**
  String get ctrlPasteHint;

  /// No description provided for @projectsLibrary.
  ///
  /// In en, this message translates to:
  /// **'Projects Library'**
  String get projectsLibrary;

  /// No description provided for @docQuality.
  ///
  /// In en, this message translates to:
  /// **'Doc Quality'**
  String get docQuality;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @loadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Load Template?'**
  String get loadTemplate;

  /// No description provided for @replaceWorkspace.
  ///
  /// In en, this message translates to:
  /// **'This will replace your current workspace.'**
  String get replaceWorkspace;

  /// No description provided for @fundingGenerator.
  ///
  /// In en, this message translates to:
  /// **'Funding Generator'**
  String get fundingGenerator;

  /// No description provided for @showcaseGallery.
  ///
  /// In en, this message translates to:
  /// **'Showcase Gallery'**
  String get showcaseGallery;

  /// No description provided for @projectAndFiles.
  ///
  /// In en, this message translates to:
  /// **'Project & Files'**
  String get projectAndFiles;

  /// No description provided for @toolsAndGenerators.
  ///
  /// In en, this message translates to:
  /// **'Tools & Generators'**
  String get toolsAndGenerators;

  /// No description provided for @intelligence.
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get intelligence;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @signInSync.
  ///
  /// In en, this message translates to:
  /// **'Sign In & Sync'**
  String get signInSync;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @branding.
  ///
  /// In en, this message translates to:
  /// **'Branding'**
  String get branding;

  /// No description provided for @selectLicense.
  ///
  /// In en, this message translates to:
  /// **'Select License'**
  String get selectLicense;

  /// No description provided for @licenseInfo.
  ///
  /// In en, this message translates to:
  /// **'A LICENSE file will be generated and included in the export.'**
  String get licenseInfo;

  /// No description provided for @communityStandards.
  ///
  /// In en, this message translates to:
  /// **'Community Standards'**
  String get communityStandards;

  /// No description provided for @contributingDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds a standard contributing guide.'**
  String get contributingDesc;

  /// No description provided for @securityPolicy.
  ///
  /// In en, this message translates to:
  /// **'Security Policy'**
  String get securityPolicy;

  /// No description provided for @securityDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds a security policy.'**
  String get securityDesc;

  /// No description provided for @supportInfo.
  ///
  /// In en, this message translates to:
  /// **'Support Info'**
  String get supportInfo;

  /// No description provided for @supportDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds support information.'**
  String get supportDesc;

  /// No description provided for @cocDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds a code of conduct.'**
  String get cocDesc;

  /// No description provided for @issueTemplates.
  ///
  /// In en, this message translates to:
  /// **'Issue Templates'**
  String get issueTemplates;

  /// No description provided for @issueTemplatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds GitHub issue and PR templates.'**
  String get issueTemplatesDesc;

  /// No description provided for @includeHtml.
  ///
  /// In en, this message translates to:
  /// **'Include a formatted HTML file.'**
  String get includeHtml;

  /// No description provided for @markdownStyle.
  ///
  /// In en, this message translates to:
  /// **'Markdown Style'**
  String get markdownStyle;

  /// No description provided for @pickColor.
  ///
  /// In en, this message translates to:
  /// **'Pick Color'**
  String get pickColor;

  /// No description provided for @typography.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get typography;

  /// No description provided for @mediaAndGraphics.
  ///
  /// In en, this message translates to:
  /// **'Media & Graphics'**
  String get mediaAndGraphics;

  /// No description provided for @structure.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get structure;

  /// No description provided for @snippets.
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get snippets;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @saveSelected.
  ///
  /// In en, this message translates to:
  /// **'Save Selected'**
  String get saveSelected;

  /// No description provided for @noSnippets.
  ///
  /// In en, this message translates to:
  /// **'No snippets found'**
  String get noSnippets;

  /// No description provided for @saveSnippet.
  ///
  /// In en, this message translates to:
  /// **'Save Snippet'**
  String get saveSnippet;

  /// No description provided for @snippetName.
  ///
  /// In en, this message translates to:
  /// **'Snippet Name'**
  String get snippetName;

  /// No description provided for @snippetSaved.
  ///
  /// In en, this message translates to:
  /// **'Snippet saved successfully!'**
  String get snippetSaved;

  /// No description provided for @heading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get heading;

  /// No description provided for @paragraph.
  ///
  /// In en, this message translates to:
  /// **'Paragraph'**
  String get paragraph;

  /// No description provided for @quote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get quote;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @button.
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get button;

  /// No description provided for @badge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get badge;

  /// No description provided for @socials.
  ///
  /// In en, this message translates to:
  /// **'Socials'**
  String get socials;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @widget.
  ///
  /// In en, this message translates to:
  /// **'Widget'**
  String get widget;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @divider.
  ///
  /// In en, this message translates to:
  /// **'Divider'**
  String get divider;

  /// No description provided for @foldout.
  ///
  /// In en, this message translates to:
  /// **'Foldout'**
  String get foldout;

  /// No description provided for @designShowcase.
  ///
  /// In en, this message translates to:
  /// **'Design Showcase'**
  String get designShowcase;

  /// No description provided for @exploreTemplates.
  ///
  /// In en, this message translates to:
  /// **'Explore Templates'**
  String get exploreTemplates;

  /// No description provided for @jumpstartDoc.
  ///
  /// In en, this message translates to:
  /// **'Jumpstart your documentation with professional layouts.'**
  String get jumpstartDoc;

  /// No description provided for @cloud.
  ///
  /// In en, this message translates to:
  /// **'CLOUD'**
  String get cloud;

  /// No description provided for @useThisTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use This Template'**
  String get useThisTemplate;

  /// No description provided for @applyTemplate.
  ///
  /// In en, this message translates to:
  /// **'Apply {name}?'**
  String applyTemplate(String name);

  /// No description provided for @templateApplied.
  ///
  /// In en, this message translates to:
  /// **'Template Applied!'**
  String get templateApplied;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed?'**
  String get proceed;

  /// No description provided for @replaceCurrentWorkspace.
  ///
  /// In en, this message translates to:
  /// **'This will replace your current workspace elements. Proceed?'**
  String get replaceCurrentWorkspace;

  /// No description provided for @selectElementToPreview.
  ///
  /// In en, this message translates to:
  /// **'Select an element to preview code'**
  String get selectElementToPreview;

  /// No description provided for @githubIntegrationInactive.
  ///
  /// In en, this message translates to:
  /// **'GitHub integration inactive. Login to enable auto-import.'**
  String get githubIntegrationInactive;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @startMasterpiece.
  ///
  /// In en, this message translates to:
  /// **'Start Your Masterpiece'**
  String get startMasterpiece;

  /// No description provided for @dragComponentsHint.
  ///
  /// In en, this message translates to:
  /// **'Drag components from the library to build your documentation'**
  String get dragComponentsHint;

  /// No description provided for @compact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get compact;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @spacious.
  ///
  /// In en, this message translates to:
  /// **'Spacious'**
  String get spacious;

  /// No description provided for @projectIntelligenceImport.
  ///
  /// In en, this message translates to:
  /// **'Project Intelligence Import'**
  String get projectIntelligenceImport;

  /// No description provided for @connectNow.
  ///
  /// In en, this message translates to:
  /// **'Connect Now'**
  String get connectNow;

  /// No description provided for @limitedAccessGitHub.
  ///
  /// In en, this message translates to:
  /// **'Limited access. Connect GitHub for seamless project engineering'**
  String get limitedAccessGitHub;

  /// No description provided for @manualFile.
  ///
  /// In en, this message translates to:
  /// **'Manual / File'**
  String get manualFile;

  /// No description provided for @projectContext.
  ///
  /// In en, this message translates to:
  /// **'Project Context #'**
  String get projectContext;

  /// No description provided for @writingPasteHint.
  ///
  /// In en, this message translates to:
  /// **'... Starting writing or paste here'**
  String get writingPasteHint;

  /// No description provided for @finalizeImport.
  ///
  /// In en, this message translates to:
  /// **'Finalize Import'**
  String get finalizeImport;

  /// No description provided for @contentSettings.
  ///
  /// In en, this message translates to:
  /// **'Content Settings'**
  String get contentSettings;

  /// No description provided for @cardDescription.
  ///
  /// In en, this message translates to:
  /// **'Card Description'**
  String get cardDescription;

  /// No description provided for @awesomeProjectDesc.
  ///
  /// In en, this message translates to:
  /// **'Awesome project description goes here'**
  String get awesomeProjectDesc;

  /// No description provided for @designSettings.
  ///
  /// In en, this message translates to:
  /// **'Design Settings'**
  String get designSettings;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @projectLogo.
  ///
  /// In en, this message translates to:
  /// **'Project Logo'**
  String get projectLogo;

  /// No description provided for @useGradientBackground.
  ///
  /// In en, this message translates to:
  /// **'Use Gradient Background'**
  String get useGradientBackground;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get backgroundColor;

  /// No description provided for @textColor.
  ///
  /// In en, this message translates to:
  /// **'Text Color'**
  String get textColor;

  /// No description provided for @typographySettings.
  ///
  /// In en, this message translates to:
  /// **'Typography Settings'**
  String get typographySettings;

  /// No description provided for @fontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamily;

  /// No description provided for @titleFontSize.
  ///
  /// In en, this message translates to:
  /// **'Title Font Size'**
  String get titleFontSize;

  /// No description provided for @fundingGeneratorTitle.
  ///
  /// In en, this message translates to:
  /// **'Funding Generator (FUNDING.yml)'**
  String get fundingGeneratorTitle;

  /// No description provided for @sponsorships.
  ///
  /// In en, this message translates to:
  /// **'Sponsorships'**
  String get sponsorships;

  /// No description provided for @sponsorshipsDesc.
  ///
  /// In en, this message translates to:
  /// **'Sponsorships help your community know how to financially support this repository. This generates a FUNDING.yml file for your .github folder'**
  String get sponsorshipsDesc;

  /// No description provided for @supportedPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Supported Platforms'**
  String get supportedPlatforms;

  /// No description provided for @githubUsernames.
  ///
  /// In en, this message translates to:
  /// **'GitHub Username(s)'**
  String get githubUsernames;

  /// No description provided for @patreonUsername.
  ///
  /// In en, this message translates to:
  /// **'Patreon Username'**
  String get patreonUsername;

  /// No description provided for @openCollective.
  ///
  /// In en, this message translates to:
  /// **'Open Collective'**
  String get openCollective;

  /// No description provided for @kofiUsername.
  ///
  /// In en, this message translates to:
  /// **'Ko-fi Username'**
  String get kofiUsername;

  /// No description provided for @tidelift.
  ///
  /// In en, this message translates to:
  /// **'Tidelift'**
  String get tidelift;

  /// No description provided for @communityBridge.
  ///
  /// In en, this message translates to:
  /// **'Community Bridge'**
  String get communityBridge;

  /// No description provided for @liberapay.
  ///
  /// In en, this message translates to:
  /// **'Liberapay'**
  String get liberapay;

  /// No description provided for @issueHunt.
  ///
  /// In en, this message translates to:
  /// **'IssueHunt'**
  String get issueHunt;

  /// No description provided for @extraFilesSelectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Select standard documentation files to generate and download for your project repository.'**
  String get extraFilesSelectionDesc;

  /// No description provided for @licenseLegalPermission.
  ///
  /// In en, this message translates to:
  /// **'Legal permission for others to use your code'**
  String get licenseLegalPermission;

  /// No description provided for @contributingGuidelinesHint.
  ///
  /// In en, this message translates to:
  /// **'Guidelines for people who want to contribute'**
  String get contributingGuidelinesHint;

  /// No description provided for @securityInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Instructions for reporting vulnerabilities'**
  String get securityInstructionsHint;

  /// No description provided for @cocPolicyHint.
  ///
  /// In en, this message translates to:
  /// **'Policy for contributor behavior'**
  String get cocPolicyHint;

  /// No description provided for @googleGeminiAi.
  ///
  /// In en, this message translates to:
  /// **'Google Gemini AI'**
  String get googleGeminiAi;

  /// No description provided for @geminiAiDesc.
  ///
  /// In en, this message translates to:
  /// **'Powering your README generation with next-gen intelligence.'**
  String get geminiAiDesc;

  /// No description provided for @apiConfiguration.
  ///
  /// In en, this message translates to:
  /// **'API CONFIGURATION'**
  String get apiConfiguration;

  /// No description provided for @apiKeyStorageHint.
  ///
  /// In en, this message translates to:
  /// **'Your API key is stored locally on your device and is only used to communicate with Google Gemini AI services'**
  String get apiKeyStorageHint;

  /// No description provided for @analyzeCodeAi.
  ///
  /// In en, this message translates to:
  /// **'Analyze Code (with AI)'**
  String get analyzeCodeAi;

  /// No description provided for @pointToFolderHint.
  ///
  /// In en, this message translates to:
  /// **'Point to your project folder, and our AI will analyze the structure to generate a tailored README'**
  String get pointToFolderHint;

  /// No description provided for @projectPath.
  ///
  /// In en, this message translates to:
  /// **'Project Path'**
  String get projectPath;

  /// No description provided for @pasteGithubUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a public GitHub URL to automatically fetch and document your repository.'**
  String get pasteGithubUrlHint;

  /// No description provided for @githubRepoUrl.
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository URL'**
  String get githubRepoUrl;

  /// No description provided for @fetchAndGenerate.
  ///
  /// In en, this message translates to:
  /// **'Fetch & Generate'**
  String get fetchAndGenerate;

  /// No description provided for @publishToGithubDesc.
  ///
  /// In en, this message translates to:
  /// **'This will create a new branch and open a Pull Request with your generated README.md directly on GitHub'**
  String get publishToGithubDesc;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'AUTHENTICATION'**
  String get authentication;

  /// No description provided for @personalAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Personal Access Token'**
  String get personalAccessToken;

  /// No description provided for @needTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Need a token? Generate one in GitHub settings with \'repo\' scope'**
  String get needTokenHint;

  /// No description provided for @repositoryDetails.
  ///
  /// In en, this message translates to:
  /// **'REPOSITORY DETAILS'**
  String get repositoryDetails;

  /// No description provided for @repository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repository;

  /// No description provided for @newBranchName.
  ///
  /// In en, this message translates to:
  /// **'New Branch Name'**
  String get newBranchName;

  /// No description provided for @createPullRequest.
  ///
  /// In en, this message translates to:
  /// **'Create Pull Request'**
  String get createPullRequest;

  /// No description provided for @premiumAccess.
  ///
  /// In en, this message translates to:
  /// **'Premium Access'**
  String get premiumAccess;

  /// No description provided for @proStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Pro Status: ACTIVE'**
  String get proStatusActive;

  /// No description provided for @proStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Pro Status: INACTIVE'**
  String get proStatusInactive;

  /// No description provided for @unlimitedAiGeneration.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI Document Generation'**
  String get unlimitedAiGeneration;

  /// No description provided for @unlockGeminiPower.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full power of Gemini AI'**
  String get unlockGeminiPower;

  /// No description provided for @proPdfExporting.
  ///
  /// In en, this message translates to:
  /// **'Pro PDF Exporting'**
  String get proPdfExporting;

  /// No description provided for @exportFormattedDocs.
  ///
  /// In en, this message translates to:
  /// **'Export beautifully formatted documents'**
  String get exportFormattedDocs;

  /// No description provided for @cloudSyncLibrary.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync & Library'**
  String get cloudSyncLibrary;

  /// No description provided for @saveProjectsCloud.
  ///
  /// In en, this message translates to:
  /// **'Save your projects to the cloud'**
  String get saveProjectsCloud;

  /// No description provided for @zeroAdvertisements.
  ///
  /// In en, this message translates to:
  /// **'Zero Advertisements'**
  String get zeroAdvertisements;

  /// No description provided for @enjoyFocusedWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Enjoy a clean, focused workspace'**
  String get enjoyFocusedWorkspace;

  /// No description provided for @donateSupportReward.
  ///
  /// In en, this message translates to:
  /// **'Donate to support development and get Lifetime Pro Access as a reward'**
  String get donateSupportReward;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @headingText.
  ///
  /// In en, this message translates to:
  /// **'Heading Text'**
  String get headingText;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @altText.
  ///
  /// In en, this message translates to:
  /// **'Alt Text'**
  String get altText;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get uploadFile;

  /// No description provided for @giphy.
  ///
  /// In en, this message translates to:
  /// **'GIPHY'**
  String get giphy;

  /// No description provided for @buttonText.
  ///
  /// In en, this message translates to:
  /// **'Button Text'**
  String get buttonText;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @linkToSection.
  ///
  /// In en, this message translates to:
  /// **'Or link to section'**
  String get linkToSection;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @orderedList.
  ///
  /// In en, this message translates to:
  /// **'Ordered List'**
  String get orderedList;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @itemN.
  ///
  /// In en, this message translates to:
  /// **'Item {number}'**
  String itemN(String number);

  /// No description provided for @searchIcon.
  ///
  /// In en, this message translates to:
  /// **'Search Icon Name'**
  String get searchIcon;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @embedType.
  ///
  /// In en, this message translates to:
  /// **'Embed Type'**
  String get embedType;

  /// No description provided for @embedUrl.
  ///
  /// In en, this message translates to:
  /// **'Embed URL'**
  String get embedUrl;

  /// No description provided for @repoUserRepo.
  ///
  /// In en, this message translates to:
  /// **'Repo Name (user/repo)'**
  String get repoUserRepo;

  /// No description provided for @fetchInfo.
  ///
  /// In en, this message translates to:
  /// **'Fetch Info'**
  String get fetchInfo;

  /// No description provided for @showStars.
  ///
  /// In en, this message translates to:
  /// **'Show Stars'**
  String get showStars;

  /// No description provided for @showForks.
  ///
  /// In en, this message translates to:
  /// **'Show Forks'**
  String get showForks;

  /// No description provided for @showIssues.
  ///
  /// In en, this message translates to:
  /// **'Show Issues'**
  String get showIssues;

  /// No description provided for @showLicense.
  ///
  /// In en, this message translates to:
  /// **'Show License'**
  String get showLicense;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @gridAvatars.
  ///
  /// In en, this message translates to:
  /// **'Grid (Avatars)'**
  String get gridAvatars;

  /// No description provided for @listNames.
  ///
  /// In en, this message translates to:
  /// **'List (Names)'**
  String get listNames;

  /// No description provided for @addColumn.
  ///
  /// In en, this message translates to:
  /// **'Col'**
  String get addColumn;

  /// No description provided for @addRow.
  ///
  /// In en, this message translates to:
  /// **'Row'**
  String get addRow;

  /// No description provided for @columnsHeaders.
  ///
  /// In en, this message translates to:
  /// **'Columns & Headers'**
  String get columnsHeaders;

  /// No description provided for @headerN.
  ///
  /// In en, this message translates to:
  /// **'Header {number}'**
  String headerN(String number);

  /// No description provided for @rowsData.
  ///
  /// In en, this message translates to:
  /// **'Rows Data'**
  String get rowsData;

  /// No description provided for @rowN.
  ///
  /// In en, this message translates to:
  /// **'Row {number}'**
  String rowN(String number);

  /// No description provided for @insertImageBadge.
  ///
  /// In en, this message translates to:
  /// **'Insert Image/Badge'**
  String get insertImageBadge;

  /// No description provided for @mermaidCode.
  ///
  /// In en, this message translates to:
  /// **'Mermaid Code'**
  String get mermaidCode;

  /// No description provided for @tocAutoDesc.
  ///
  /// In en, this message translates to:
  /// **'This element will automatically generate a table of contents based on headings in your project.'**
  String get tocAutoDesc;

  /// No description provided for @rawMarkdownHtml.
  ///
  /// In en, this message translates to:
  /// **'Raw Markdown / HTML'**
  String get rawMarkdownHtml;

  /// No description provided for @rawHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any valid Markdown or HTML code here.'**
  String get rawHint;

  /// No description provided for @rawRenderDesc.
  ///
  /// In en, this message translates to:
  /// **'This content will be rendered exactly as written in the final README.'**
  String get rawRenderDesc;

  /// No description provided for @widgetType.
  ///
  /// In en, this message translates to:
  /// **'Widget Type'**
  String get widgetType;

  /// No description provided for @themeOptional.
  ///
  /// In en, this message translates to:
  /// **'Theme (Optional)'**
  String get themeOptional;

  /// No description provided for @badgeBuilder.
  ///
  /// In en, this message translates to:
  /// **'Static Badge Builder'**
  String get badgeBuilder;

  /// No description provided for @labelLeft.
  ///
  /// In en, this message translates to:
  /// **'Label (Left)'**
  String get labelLeft;

  /// No description provided for @messageRight.
  ///
  /// In en, this message translates to:
  /// **'Message (Right)'**
  String get messageRight;

  /// No description provided for @colorRight.
  ///
  /// In en, this message translates to:
  /// **'Color (Right)'**
  String get colorRight;

  /// No description provided for @logoSlug.
  ///
  /// In en, this message translates to:
  /// **'Logo (Slug)'**
  String get logoSlug;

  /// No description provided for @logoColor.
  ///
  /// In en, this message translates to:
  /// **'Logo Color'**
  String get logoColor;

  /// No description provided for @labelColor.
  ///
  /// In en, this message translates to:
  /// **'Label Color (Left Background)'**
  String get labelColor;

  /// No description provided for @simpleIconsHint.
  ///
  /// In en, this message translates to:
  /// **'Available logos can be found on simpleicons.org. Use the \"slug\" or name.'**
  String get simpleIconsHint;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// No description provided for @addProfile.
  ///
  /// In en, this message translates to:
  /// **'Add Profile'**
  String get addProfile;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @usernameHandle.
  ///
  /// In en, this message translates to:
  /// **'Username / Handle'**
  String get usernameHandle;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @editCell.
  ///
  /// In en, this message translates to:
  /// **'Edit Cell Content'**
  String get editCell;

  /// No description provided for @cellContent.
  ///
  /// In en, this message translates to:
  /// **'Content (Text, Markdown, HTML)'**
  String get cellContent;

  /// No description provided for @insertMedia.
  ///
  /// In en, this message translates to:
  /// **'Insert Media:'**
  String get insertMedia;

  /// No description provided for @youtubeHelper.
  ///
  /// In en, this message translates to:
  /// **'YouTube URL Helper'**
  String get youtubeHelper;

  /// No description provided for @youtubeDesc.
  ///
  /// In en, this message translates to:
  /// **'To embed a YouTube video, paste the video URL below. We will help you extract the video ID if needed.'**
  String get youtubeDesc;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview:'**
  String get preview;

  /// No description provided for @useThisVideo.
  ///
  /// In en, this message translates to:
  /// **'Use This Video'**
  String get useThisVideo;

  /// No description provided for @codepenHelper.
  ///
  /// In en, this message translates to:
  /// **'CodePen Helper'**
  String get codepenHelper;

  /// No description provided for @codepenDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste your CodePen URL. We will generate a preview image link for your README.'**
  String get codepenDesc;

  /// No description provided for @useThisPen.
  ///
  /// In en, this message translates to:
  /// **'Use This Pen'**
  String get useThisPen;

  /// No description provided for @gistHelper.
  ///
  /// In en, this message translates to:
  /// **'GitHub Gist Helper'**
  String get gistHelper;

  /// No description provided for @gistDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste your Gist URL or ID.'**
  String get gistDesc;

  /// No description provided for @useThisGist.
  ///
  /// In en, this message translates to:
  /// **'Use This Gist'**
  String get useThisGist;

  String get projectHealthCenter;
  String get eliteDocumentation;
  String get optimizationRequired;
  String get scoreBasedOnGitHub;
  String get aiStrategicAudit;
  String get aiAnalysisFailed;
  String get structuralAudit;
  String get allChecksPassed;
  String get feedbackAndSupport;
  String get howCanWeHelp;
  String get describeIssueHint;
  String get sendFeedback;
  String get sending;
  String get dropImageHere;
  String get attachmentDropOrPaste;
  String get addFile;
  String get fundingYamlPreview;
  String get copyYaml;
  String get copiedToClipboardShort;
  String get customLinks;
  String get customUrl;
  String get welcomeToReadmeCreator;
  String get whatToBuild;
  String get projectReadme;
  String get softwareAndApps;
  String get githubProfile;
  String get personalPortfolio;
  String get projectIntelligence;
  String get personalBranding;
  String get fillBasics;
  String get briefDescription;
  String get githubUsername;
  String get professionalTitle;
  String get goBack;
  String get skipSetup;
  String get continueBtn;
  String get startCreating;
  String get addPublicTemplate;
  String get templateName;
  String get templateCategory;
  String get templateContentJson;
  String get addTemplate;
  String get templateAdded;
  String get exportImage;
  String get socialPreviewDesignerTitle;
  String get localFolderTab;
  String get githubRepoTab;
  String get analyzeAndGenerate;
  String get fetchAndGenerateBtn;
  String get closeBtn;
  String get cancelBtn;
  String get deleteBtn;
  String get saveBtn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

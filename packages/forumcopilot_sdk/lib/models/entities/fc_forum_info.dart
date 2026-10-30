import 'package:dart_mappable/dart_mappable.dart';

part 'fc_forum_info.mapper.dart';

/// A notice the forum shows the visitor (XenForo's notices), as getConfig
/// sends them from add-on 1.11.0.
@MappableClass()
class FCForumNotice with FCForumNoticeMappable {
  const FCForumNotice({
    required this.id,
    this.type = 'block',
    this.title = '',
    this.message = '',
    this.dismissible = false,
  });

  final int id;

  /// XenForo's notice type: `block`, `floating`, `scrolling`, `bottom_fixer`.
  final String type;
  final String title;

  /// The notice as plain text.
  final String message;

  /// Whether the member may close it for good.
  final bool dismissible;

  /// From a getConfig `notices` list; null when there is none (older
  /// add-ons). Notices without text are left out.
  static List<FCForumNotice>? listFromJson(Object? json) {
    if (json is! List) return null;
    return [
      for (final n in json)
        if (n is Map && int.tryParse('${n['id']}') != null && '${n['message'] ?? ''}'.trim().isNotEmpty)
          FCForumNotice(
            id: int.parse('${n['id']}'),
            type: '${n['type'] ?? 'block'}',
            title: '${n['title'] ?? ''}'.trim(),
            message: '${n['message']}'.trim(),
            dismissible: n['dismissible'] == true,
          ),
    ];
  }
}

/// A page of the forum's own: a help page, or its terms, privacy policy or
/// contact page.
@MappableClass()
class FCForumPage with FCForumPageMappable {
  const FCForumPage({required this.title, required this.url});

  final String title;
  final String url;

  /// From a getConfig `helpPages` list; null when there is none (older
  /// add-ons).
  static List<FCForumPage>? listFromJson(Object? json) {
    if (json is! List) return null;
    return [
      for (final p in json)
        if (p is Map && '${p['title'] ?? ''}'.trim().isNotEmpty && '${p['url'] ?? ''}'.trim().isNotEmpty)
          FCForumPage(title: '${p['title']}'.trim(), url: '${p['url']}'.trim()),
    ];
  }
}

/// The member still has to accept the forum's updated terms or privacy
/// policy, on the website (getConfig `policyAcceptance`, add-on 1.11.0).
@MappableClass()
class FCPolicyAcceptance with FCPolicyAcceptanceMappable {
  const FCPolicyAcceptance({this.termsRequired = false, this.privacyRequired = false, this.acceptUrl = ''});

  final bool termsRequired;
  final bool privacyRequired;

  /// The website's page where the member accepts them.
  final String acceptUrl;

  /// Null unless acceptance is required and there is a page for it.
  static FCPolicyAcceptance? fromJson(Object? json) {
    if (json is! Map || json['required'] != true) return null;
    final url = '${json['acceptUrl'] ?? ''}'.trim();
    if (url.isEmpty) return null;
    return FCPolicyAcceptance(
      termsRequired: json['termsRequired'] == true,
      privacyRequired: json['privacyRequired'] == true,
      acceptUrl: url,
    );
  }
}

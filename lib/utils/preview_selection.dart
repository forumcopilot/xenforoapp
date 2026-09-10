/// Which single preview card a post shows under its body.
///
/// A post used to render up to thirty cards -- ten links, ten videos, ten
/// tweets -- each of which fetched on appearance and rebuilt itself on
/// completion (audit finding 4). The web shows one. This picks it, in the
/// order a reader would expect: a video if there is one, else a tweet, else
/// the first external link. At most one field is non-null.
class PreviewSelection {
  const PreviewSelection._({this.videoUrl, this.tweetUrl, this.linkUrl});

  static const PreviewSelection none = PreviewSelection._();

  final String? videoUrl;
  final String? tweetUrl;
  final String? linkUrl;

  bool get isEmpty => videoUrl == null && tweetUrl == null && linkUrl == null;

  static PreviewSelection choose({
    required Iterable<String> videos,
    required Iterable<String> tweets,
    required Iterable<String> links,
  }) {
    for (final v in videos) {
      return PreviewSelection._(videoUrl: v);
    }
    for (final t in tweets) {
      return PreviewSelection._(tweetUrl: t);
    }
    for (final l in links) {
      return PreviewSelection._(linkUrl: l);
    }
    return none;
  }
}

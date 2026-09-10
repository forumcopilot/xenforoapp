import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/utils/preview_selection.dart';

void main() {
  test('a video wins over tweets and links', () {
    final s = PreviewSelection.choose(
        videos: ['v1', 'v2'], tweets: ['t1'], links: ['l1', 'l2']);
    expect(s.videoUrl, 'v1');
    expect(s.tweetUrl, isNull);
    expect(s.linkUrl, isNull);
  });

  test('a tweet wins over links when there is no video', () {
    final s = PreviewSelection.choose(videos: [], tweets: ['t1', 't2'], links: ['l1']);
    expect(s.tweetUrl, 't1');
    expect(s.linkUrl, isNull);
  });

  test('otherwise the first link, and only the first', () {
    final s = PreviewSelection.choose(videos: [], tweets: [], links: ['l1', 'l2', 'l3']);
    expect(s.linkUrl, 'l1');
    expect(s.videoUrl, isNull);
    expect(s.tweetUrl, isNull);
  });

  test('nothing to preview', () {
    expect(PreviewSelection.choose(videos: [], tweets: [], links: []).isEmpty, isTrue);
  });
}

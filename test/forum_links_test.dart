import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/utils/forum_links.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';

/// Links to the open forum open on their own screens: whatever the scheme,
/// with or without www., friendly or plain URLs, and only inside the
/// forum's folder.
void main() {
  const site = Site(
    name: 'Example',
    url: 'https://www.example.com/community',
    description: '',
    baseUrl: 'https://www.example.com/community',
    endpoint: 'forumcopilot.php',
    siteType: 'xenforo',
  );

  ForumLinkTarget? parse(String url) => ForumLinks.parse(url, site);

  test('threads, at a post when the link has one', () {
    final t = parse('https://www.example.com/community/threads/hello-world.123/') as ThreadLink;
    expect((t.topicId, t.postId), ('123', null));
    final p = parse('https://example.com/community/threads/hello.world.123/post-456') as ThreadLink;
    expect((p.topicId, p.postId), ('123', '456'));
    final f = parse('http://example.com/community/threads/123/page-3#post-789') as ThreadLink;
    expect((f.topicId, f.postId), ('123', '789'));
  });

  test('posts, forums, members and conversations', () {
    expect((parse('https://example.com/community/posts/55/') as PostLink).postId, '55');
    expect((parse('https://example.com/community/goto/post?id=56') as PostLink).postId, '56');
    expect((parse('https://example.com/community/forums/news.7/') as ForumSectionLink).forumId, '7');
    expect((parse('https://example.com/community/members/alice.42/') as MemberLink).userId, '42');
    final c = parse('https://example.com/community/conversations/hi.9/#convMessage-12') as ConversationLink;
    expect((c.conversationId, c.messageId), ('9', '12'));
    expect((parse('https://example.com/community/direct-messages/hi.10/') as ConversationLink).conversationId, '10');
  });

  test('plain (non-friendly) URLs', () {
    final t = parse('https://example.com/community/index.php?threads/hello.123/&page=2') as ThreadLink;
    expect(t.topicId, '123');
    expect((parse('https://example.com/community/index.php?goto/post&id=77') as PostLink).postId, '77');
    expect((parse('https://example.com/community/index.php/members/bob.5/') as MemberLink).userId, '5');
  });

  test('not this forum, or no screen for it: null', () {
    expect(parse('https://other.com/community/threads/a.1/'), isNull);
    expect(parse('https://example.com/shop/threads/a.1/'), isNull, reason: 'outside the forum folder');
    expect(parse('https://example.com/community/attachments/x.1/'), isNull);
    expect(parse('https://example.com/community/'), isNull);
    expect(parse('mailto:someone@example.com'), isNull);
    expect(parse('https://medium.com/@someone/a-post-123'), isNull);
  });

  test('a forum at the root, and one without an endpoint', () {
    const root = Site(name: 'R', url: 'https://forum.example.org', description: '', siteType: 'xenforo');
    expect(ForumLinks.parse('https://www.forum.example.org/threads/a.1/', root), isA<ThreadLink>());
    const sub = Site(name: 'S', url: 'https://example.net/xen', description: '', siteType: 'xenforo');
    expect(ForumLinks.parse('https://example.net/xen/threads/a.1/', sub), isA<ThreadLink>());
    expect(ForumLinks.parse('https://example.net/threads/a.1/', sub), isNull);
  });

  test("a post's link works with or without friendly URLs", () {
    expect(ForumLinks.postUrl(site, '99'), 'https://www.example.com/community/index.php?posts/99/');
    expect(ForumLinks.parse(ForumLinks.postUrl(site, '99')!, site), isA<PostLink>());
  });
}

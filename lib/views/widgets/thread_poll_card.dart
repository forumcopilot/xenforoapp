import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_poll.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import '../../l10n/generated/app_localizations.dart';

/// Twitter/X-style poll card shown at the top of a thread when the thread has a poll.
class ThreadPollCard extends StatefulWidget {
  final FCPoll poll;
  final String topicId;
  final SiteContext siteContext;
  final void Function(FCPoll updatedPoll) onVoteSuccess;

  const ThreadPollCard({
    super.key,
    required this.poll,
    required this.topicId,
    required this.siteContext,
    required this.onVoteSuccess,
  });

  @override
  State<ThreadPollCard> createState() => _ThreadPollCardState();
}

class _ThreadPollCardState extends State<ThreadPollCard> {
  /// Selected response IDs for submission. For single-choice maxVotes==1, at most one; for multi, up to maxVotes.
  final Set<String> _selectedIds = {};
  bool _isSubmitting = false;

  int get _maxSelections => widget.poll.maxVotes == 0 ? widget.poll.responses.length : widget.poll.maxVotes;

  void _toggleOption(String responseId) {
    if (!widget.poll.canVote || widget.poll.hasVoted || _isSubmitting) return;
    setState(() {
      if (_selectedIds.contains(responseId)) {
        _selectedIds.remove(responseId);
      } else {
        if (_maxSelections == 1) {
          _selectedIds.clear();
          _selectedIds.add(responseId);
        } else if (_selectedIds.length < _maxSelections) {
          _selectedIds.add(responseId);
        }
      }
    });
  }

  Future<void> _submitVote() async {
    if (_selectedIds.isEmpty || !widget.poll.canVote || widget.poll.hasVoted || _isSubmitting) return;
    if (widget.poll.maxVotes > 0 && _selectedIds.length > widget.poll.maxVotes) return;

    setState(() => _isSubmitting = true);
    try {
      final postProxy = SiteProxyService.getPostProxy();
      final updated = await postProxy.votePollAsync(widget.topicId, _selectedIds.toList());
      if (updated != null && mounted) {
        widget.onVoteSuccess(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.vote,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            behavior: SnackBarBehavior.floating,
            margin: DesignTokens.paddingS,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (mounted) {
        _showError('Vote failed. Please try again.');
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        margin: DesignTokens.paddingS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;
    final showResults = widget.poll.canViewResults &&
        widget.poll.voterCount != null &&
        widget.poll.voterCount! > 0;
    final canVote = widget.poll.canVote && !widget.poll.hasVoted;
    final voterCount = widget.poll.voterCount;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(DesignTokens.opacityLow),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityMediumLow),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Padding(
        padding: DesignTokens.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.poll.question,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: DesignTokens.fontWeightSemiBold,
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: DesignTokens.spacingM),
            ...widget.poll.responses.map((r) => _buildOptionRow(
                  context,
                  r,
                  showResults: showResults,
                  canVote: canVote,
                  voterCount: voterCount,
                )),
            SizedBox(height: DesignTokens.spacingM),
            if (canVote) ...[
              FilledButton(
                onPressed: (_selectedIds.isNotEmpty && !_isSubmitting) ? _submitVote : null,
                child: _isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(l10n.vote),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.spacingS),
            ],
            _buildFooter(l10n, colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(
    BuildContext context,
    FCPollResponse r, {
    required bool showResults,
    required bool canVote,
    int? voterCount,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isSelected = _selectedIds.contains(r.id) || r.viewerVotedFor;
    double fraction = 0.0;
    if (showResults && voterCount != null && voterCount > 0 && r.voteCount != null) {
      fraction = (r.voteCount! / voterCount).clamp(0.0, 1.0);
    }
    final showBar = showResults && voterCount != null && voterCount > 0;
    final percent = showBar && r.voteCount != null ? (fraction * 100).round() : null;

    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacingS),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canVote ? () => _toggleOption(r.id) : null,
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingM,
              vertical: DesignTokens.spacingS + DesignTokens.spacingXS,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              color: isSelected
                  ? colorScheme.primaryContainer.withOpacity(DesignTokens.opacityMediumLow)
                  : null,
              border: isSelected
                  ? Border.all(
                      color: colorScheme.primary.withOpacity(DesignTokens.opacityMediumLow),
                      width: DesignTokens.borderWidthThin,
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBar) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 6,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        r.viewerVotedFor ? colorScheme.primary : colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacingXS),
                ],
                Row(
                  children: [
                    if (canVote && !widget.poll.hasVoted)
                      Padding(
                        padding: EdgeInsets.only(right: DesignTokens.spacingS),
                        child: Icon(
                          widget.poll.maxVotes <= 1
                              ? (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked)
                              : (isSelected ? Icons.check_box : Icons.check_box_outlined),
                          size: DesignTokens.iconSizeM,
                          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        r.text,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: r.viewerVotedFor ? DesignTokens.fontWeightSemiBold : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (percent != null)
                      Text(
                        '$percent%',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    String footer = '';
    if (widget.poll.isClosed) {
      footer = l10n.pollClosed;
    } else if (widget.poll.closeDate > 0) {
      final date = DateTime.fromMillisecondsSinceEpoch(widget.poll.closeDate);
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      footer = l10n.pollEndsOn(dateStr);
    }
    if (widget.poll.voterCount != null) {
      footer = footer.isEmpty ? l10n.votesCount(widget.poll.voterCount!) : '$footer · ${l10n.votesCount(widget.poll.voterCount!)}';
    }
    if (footer.isEmpty && !widget.poll.canViewResults && !widget.poll.hasVoted) {
      footer = l10n.voteToSeeResults;
    }
    if (footer.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: DesignTokens.spacingXS),
      child: Text(
        footer,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/image_optimization_utils.dart';
import '../../utils/file_utils.dart';
import '../../l10n/generated/app_localizations.dart';

/// Shows a dialog asking user to confirm image optimization
/// Returns true if user confirms, false if cancelled
Future<bool> showImageOptimizationDialog(
  BuildContext context,
  XFile imageFile,
  ImageOptimizationPlan plan,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.image, color: Colors.orange),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)?.optimizeImage ?? 'Optimize Image'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This image exceeds the upload limits and needs to be optimized:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                'Original Size',
                formatFileSize(plan.originalSize),
              ),
              if (plan.originalWidth != null && plan.originalHeight != null)
                _buildInfoRow(
                  context,
                  'Original Dimensions',
                  '${plan.originalWidth} × ${plan.originalHeight} px',
                ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Optimizations to be applied:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              if (plan.needsResize)
                _buildActionRow(
                  context,
                  Icons.aspect_ratio,
                  'Resize',
                  '${plan.originalWidth} × ${plan.originalHeight} → ${plan.targetWidth} × ${plan.targetHeight} px',
                ),
              if (plan.needsFormatConversion)
                _buildActionRow(
                  context,
                  Icons.transform,
                  'Convert Format',
                  plan.originalFormat != null && plan.targetFormat != null
                      ? '${plan.originalFormat!.toUpperCase()} → ${plan.targetFormat!.toUpperCase()}${plan.originalFormat!.toLowerCase() != 'jpg' && plan.originalFormat!.toLowerCase() != 'jpeg' ? ' (smaller file size)' : ' (format not supported)'}'
                      : 'Convert to JPG (format not supported or for size reduction)',
                ),
              if (plan.needsCompression)
                _buildActionRow(
                  context,
                  Icons.compress,
                  'Compress',
                  'Quality: ${plan.quality}% to meet size limit',
                ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              if (plan.estimatedSize != null)
                _buildInfoRow(
                  context,
                  'Estimated Final Size',
                  formatFileSize(plan.estimatedSize!),
                  isHighlight: true,
                ),
              if (plan.estimatedSize != null)
                Text(
                  'Reduction: ${((1 - plan.estimatedSize! / plan.originalSize) * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppLocalizations.of(context)?.optimizeAndUpload ?? 'Optimize and Upload'),
          ),
        ],
      );
    },
  );

  return confirmed ?? false;
}

Widget _buildInfoRow(BuildContext context, String label, String value, {bool isHighlight = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                color: isHighlight
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    ),
  );
}

Widget _buildActionRow(BuildContext context, IconData icon, String action, String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

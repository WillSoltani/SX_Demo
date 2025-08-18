// Author: Will Soltani
// Version: 1.1
// Revised: 2025-08-17

import 'package:flutter/material.dart';
import 'package:sxui/app/Extensions/dashboard_box.dart';
import 'package:sxui/app/shared/constants.dart';

/// Displays today's sales and a progress bar vs yesterday.
/// - Responsive: scales icon, text, paddings for small boxes
/// - Safe: clamps progress 0..1 and avoids tiny unreadable sizes
///
/// Optional: you can pass [today], [yesterday], and [title]. If not provided,
/// sensible defaults are used so existing calls continue to work.
class SalesSum extends StatelessWidget {
  final double today;
  final double yesterday;
  final String title;

  const SalesSum({
    Key? key,
    this.today = 5300.0,
    this.yesterday = 7066.67, // ~75% of yesterday
    this.title = "Today's Sales",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Compute progress safely
    final double ratio = (yesterday <= 0) ? 0 : (today / yesterday);
    final double progress = ratio.clamp(0.0, 1.0);
    final int percent = (progress * 100).round();

    return DashboardBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double boxWidth = constraints.maxWidth;

          // Base sizes
          double iconSize = 35.0;
          double textSize = 14.0;
          double progressBarHeight = 12.0;
          double padding = 16.0;

          // Scale down if narrow
          if (boxWidth < 300) {
            final scale = (boxWidth / 300).clamp(0.6, 1.0);
            iconSize *= scale;
            textSize *= scale;
            progressBarHeight *= scale;
            padding *= scale;
          }

          // Minimum thresholds
          iconSize = iconSize.clamp(20.0, 40.0);
          textSize = textSize.clamp(10.0, 16.0);
          progressBarHeight = progressBarHeight.clamp(8.0, 14.0);
          padding = padding.clamp(8.0, 18.0);

          String _formatMoney(double v) {
            // Lightweight formatting to avoid introducing intl dependency here
            final s = v.toStringAsFixed(0);
            // Add thousands separators
            final buf = StringBuffer();
            for (int i = 0; i < s.length; i++) {
              final fromEnd = s.length - i;
              buf.write(s[i]);
              if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
            }
            return '\$${buf.toString()}';
          }

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leading $ icon
                Icon(Icons.attach_money, color: darkPurple, size: iconSize),
                SizedBox(width: padding),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Amount
                      Text(
                        _formatMoney(today),
                        style: TextStyle(
                          color: darkPurple,
                          fontSize: textSize * 1.25,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: padding),

                      // Progress + caption
                      LayoutBuilder(
                        builder: (context, progressConstraints) {
                          final double barWidth = progressConstraints.maxWidth;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Track
                              Container(
                                height: progressBarHeight,
                                width: barWidth,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.white24, width: 1),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: progress, // 0..1
                                    child: Container(
                                      height: progressBarHeight,
                                      decoration: BoxDecoration(
                                        color: darkPurple,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: padding / 2),
                              // Caption
                              Text(
                                '$percent% of yesterday\'s sales',
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: textSize * 0.85,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

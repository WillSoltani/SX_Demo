//Author: Will Soltani
//Version 1.0
//Revised: 30-09-2024
import 'package:flutter/material.dart';
import '../../Extensions/dashboard_box.dart';
import '../../constants.dart';

/// A box that displays the daily sales performance of the business, showing a sales amount and a progress bar.
/// It visually compares today's sales to yesterday's, providing a clear overview of business progress.
///
/// This widget includes:
/// - A dollar sign icon for visual emphasis on the financial aspect.
/// - Text to display the sales amount for the day.
/// - A progress bar representing the percentage of today's sales compared to yesterday's.
/// - Responsive design: Adjusts icon size, text size, and padding based on the available box width to ensure visibility on different screen sizes.
///
/// @param key The optional key for this widget.
class BoxX4 extends StatelessWidget {
  const BoxX4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double boxWidth = constraints.maxWidth;
          final double boxHeight = constraints.maxHeight;

          // Define base sizes
          double iconSize = 35.0;
          double textSize = 14.0;
          double progressBarHeight = 12.0;
          double padding = 16.0;

          // Adjust sizes if boxWidth is small
          if (boxWidth < 300) {
            double scaleFactor = boxWidth / 300;
            iconSize *= scaleFactor;
            textSize *= scaleFactor;
            progressBarHeight *= scaleFactor;
            padding *= scaleFactor;
          }

          // Ensure sizes don't go below minimum thresholds
          iconSize = iconSize.clamp(20.0, 35.0);
          textSize = textSize.clamp(10.0, 14.0);
          progressBarHeight = progressBarHeight.clamp(8.0, 12.0);
          padding = padding.clamp(8.0, 16.0);

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dollar sign icon on the left
                Icon(
                  Icons.attach_money,
                  color: darkPurple,
                  size: iconSize,
                ),
                SizedBox(width: padding),
                // All other info on the right
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Today's Sales" text
                      Text(
                        "Today's Sales",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // "$5,300" text
                      Text(
                        "\$5,300",
                        style: TextStyle(
                          color: darkPurple,
                          fontSize: textSize * 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: padding),
                      // Progress bar and percentage text
                      LayoutBuilder(
                        builder: (context, progressConstraints) {
                          double progressBarWidth =
                              progressConstraints.maxWidth;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Progress bar
                              Container(
                                height: progressBarHeight,
                                width: progressBarWidth,
                                decoration: BoxDecoration(
                                  color: Colors.grey[500],
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: 0.75, // 75% filled
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: darkPurple,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: padding / 2),
                              // "75% of yesterday's sales" text
                              Text(
                                "75% of yesterday's sales",
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: textSize * 0.8,
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

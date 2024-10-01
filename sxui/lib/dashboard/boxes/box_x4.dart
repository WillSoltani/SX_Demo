import 'package:flutter/material.dart';
import '../widgets/dashboard_box.dart';
import '../constants.dart';

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
                          double progressBarWidth = progressConstraints.maxWidth;

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
                                  border: Border.all(color: Colors.white, width: 1),
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

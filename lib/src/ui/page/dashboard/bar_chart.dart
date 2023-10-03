import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rin_wallet/src/models/charts/bar_chart.dart';
import 'package:rin_wallet/src/utils/number.utils.dart';

class BarChartSample extends StatefulWidget {
  List<BarChartModel> rawData;
  String title = '';
  final Color leftBarColor = Colors.purple;
  final Color rightBarColor = Colors.blueGrey;
  final Color avgColor = Colors.orange;

  BarChartSample(
      {super.key,
      required List<BarChartModel> this.rawData,
      required this.title});

  @override
  State<StatefulWidget> createState() => BarChartSampleState();
}

class BarChartSampleState extends State<BarChartSample> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double interval = 1000;
    double max = 0;
    List<BarChartGroupData> items = [];
    for (int i = 0; i < widget.rawData.length; i++) {
      var element = widget.rawData[i];
      BarChartGroupData barGroup = makeGroupData(i, element.y1, element.y2);
      items.add(barGroup);
      print(inspect(barGroup));

      List list = [max, element.y1, element.y2];
      double _max = list.reduce((curr, next) => curr > next ? curr : next);
      max = _max;
    }

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
    interval = max > 0 ? max / 5 : 1000;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ],
          ),
          const SizedBox(
            height: 38,
          ),
          AspectRatio(
            aspectRatio: 1,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey[200],
                    // getTooltipItem: (a, b, c, d) => null,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String weekDay = widget.rawData[groupIndex].originalX;
                      // switch (group.x) {
                      //   case 0:
                      //     weekDay = 'Monday';
                      //     break;
                      //   case 1:
                      //     weekDay = 'Tuesday';
                      //     break;
                      //   case 2:
                      //     weekDay = 'Wednesday';
                      //     break;
                      //   case 3:
                      //     weekDay = 'Thursday';
                      //     break;
                      //   case 4:
                      //     weekDay = 'Friday';
                      //     break;
                      //   case 5:
                      //     weekDay = 'Saturday';
                      //     break;
                      //   case 6:
                      //     weekDay = 'Sunday';
                      //     break;
                      //   default:
                      //     throw Error();
                      // }
                      String txt = formatNumber(trailingZero(rod.toY));
                      return BarTooltipItem(
                          txt,
                          const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ));
                      return BarTooltipItem(
                        '$weekDay\n',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: txt,
                            style: TextStyle(
                              color: Colors.deepPurpleAccent[200],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // touchCallback: (FlTouchEvent event, response) {
                  //   if (response == null || response.spot == null) {
                  //     setState(() {
                  //       touchedGroupIndex = -1;
                  //       showingBarGroups = List.of(rawBarGroups);
                  //     });
                  //     return;
                  //   }

                  //   touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                  //   setState(() {
                  //     if (!event.isInterestedForInteractions) {
                  //       touchedGroupIndex = -1;
                  //       showingBarGroups = List.of(rawBarGroups);
                  //       return;
                  //     }
                  //     showingBarGroups = List.of(rawBarGroups);
                  //     if (touchedGroupIndex != -1) {
                  //       var sum = 0.0;
                  //       for (final rod
                  //           in showingBarGroups[touchedGroupIndex]
                  //               .barRods) {
                  //         sum += rod.toY;
                  //       }
                  //       final avg = sum /
                  //           showingBarGroups[touchedGroupIndex]
                  //               .barRods
                  //               .length;

                  //       showingBarGroups[touchedGroupIndex] =
                  //           showingBarGroups[touchedGroupIndex].copyWith(
                  //         barRods: showingBarGroups[touchedGroupIndex]
                  //             .barRods
                  //             .map((rod) {
                  //           return rod.copyWith(
                  //               toY: avg, color: widget.avgColor);
                  //         }).toList(),
                  //       );
                  //     }
                  //   });
                  // },

                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    print('touched callback');
                    print(event);
                    // setState(() {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      // touchedIndex = -1;
                      return;
                    }
                    print(inspect(barTouchResponse));
                    print(barTouchResponse.spot!.touchedBarGroupIndex);

                    // touchedIndex =
                    //     barTouchResponse.spot!.touchedBarGroupIndex;
                    // });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 42,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: interval,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black12),
                ),
                barGroups: showingBarGroups,
                gridData: FlGridData(
                  show: true,
                  verticalInterval: 1,
                  checkToShowVerticalLine: (value) => value % 1 == 0,
                  checkToShowHorizontalLine: (value) => value % 2 == 0,
                  getDrawingHorizontalLine: (value) {
                    if (value == 0) {
                      return FlLine(
                        color: Colors.black12,
                        strokeWidth: 3,
                      );
                    }
                    // horizontal
                    return FlLine(
                      color: Colors.black12,
                      strokeWidth: 0.8,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String num = NumberFormat.compactCurrency(
      decimalDigits: 2,
      symbol:
          '', // if you want to add currency symbol then pass that in this else leave it empty.
    ).format(value);

    String text = num + ' ';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = Text(
      widget.rawData[value.toInt()].originalX,
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    final double width = 16;
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      // showingTooltipIndicators: [0, 1],
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ],
    );
  }
}

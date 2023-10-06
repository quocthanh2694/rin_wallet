import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/charts/pie_chart.dart';
import 'package:rin_wallet/src/utils/number.utils.dart';

class PieChartSample extends StatefulWidget {
  List<PieChartModel> rawData;
  PieChartSample({
    super.key,
    required List<PieChartModel> this.rawData,
  });

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<PieChartSample> {
  int touchedIndex = -1;
  List<PieChartSectionData> showingPieCharts = [];

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> items = [];

    for (int i = 0; i < widget.rawData.length; i++) {
      var element = widget.rawData[i];
      PieChartSectionData pieSection = generatePieSection(element, i);
      items.add(pieSection);
    }

    showingPieCharts = items;
    if (showingPieCharts.length == 0) {
      return Container(
        child: Text('Pie chart is empty data'),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingPieCharts,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: generateColumn(),
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  generatePieSection(
    PieChartModel elem,
    int i,
  ) {
    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 30.0 : 16.0;
    final radius = isTouched ? 68.0 : 50.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 8)];
    return PieChartSectionData(
      color: COLORS[i],
      value: elem.value,
      title: formatNumber(trailingZero(elem.value)),
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: shadows,
      ),
    );
  }

  generateColumn() {
    List<Widget> _list = [];
    int i = 0;
    var res = widget.rawData.forEach((item) {
      _list.add(Indicator(
        color: COLORS[i],
        text: item.name,
        isSquare: true,
      ));
      _list.add(SizedBox(
        height: 8,
      ));
      i++;
    });
    return _list;
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 20,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

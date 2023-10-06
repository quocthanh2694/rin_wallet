class ChartType {
  late ChartType _chartType;

  get chartType async {
    if (_chartType == null) {
      _chartType = await initializeChartType();
    }
    return _chartType as dynamic;
  }

  initializeChartType() async {
    return ChartType();
  }

  List<ChartTypeModel> getList() {
    List<ChartTypeModel> list = [
      ChartTypeModel(id: 'month', name: 'Month'),
      ChartTypeModel(id: 'day', name: 'Day'),
    ];
    return list;
  }
}

class ChartTypeModel {
  String id = '';
  String name = '';

  ChartTypeModel({required String this.id, required String this.name}) {}
}

class CurrencyUnit {
  late CurrencyUnit _currencyUnit;

  get currencyUnit {
    return _currencyUnit as dynamic;
  }

  initializeCurrencyUnit() {
    return CurrencyUnit();
  }

  List<CurrencyUnitModel> getList() {
    List<CurrencyUnitModel> list = [
      CurrencyUnitModel(id: 'vnd', name: 'VND'),
      CurrencyUnitModel(id: 'dollar', name: "\$"),
    ];
    return list;
  }
}

class CurrencyUnitModel {
  String id = '';
  String name = '';

  CurrencyUnitModel({required String this.id, required String this.name}) {}
}

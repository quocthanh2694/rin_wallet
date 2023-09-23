class TransactionCategory {
  late TransactionCategory _walletType;

  get walletType async {
    if (_walletType == null) {
      _walletType = await initialize();
    }
    return _walletType as dynamic;
  }

  initialize() async {
    return TransactionCategory();
  }

  List<TransactionCategoryModel> getList() {
    List<TransactionCategoryModel> list = [
      TransactionCategoryModel(id: 'category1', name: 'Category 1'),
      TransactionCategoryModel(id: 'category2', name: 'Category 2'),
    ];
    return list;
  }
}

class TransactionCategoryModel {
  String id = '';
  String name = '';

  TransactionCategoryModel({required String this.id, required String this.name}) {}
}

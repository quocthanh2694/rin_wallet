class TransactionType {
  late TransactionType _walletType;

  get walletType async {
    if (_walletType == null) {
      _walletType = await initialize();
    }
    return _walletType as dynamic;
  }

  initialize() async {
    return TransactionType();
  }

  List<TransactionTypeModel> getList() {
    List<TransactionTypeModel> list = [
      TransactionTypeModel(id: 'deposit', name: 'Deposit'),
      TransactionTypeModel(id: 'withdraw', name: 'Withdraw'),
      // TransactionTypeModel(id: 'transfer', name: 'Transfer'),
    ];
    return list;
  }

  isDeposit(String id) {
    return id == 'deposit';
  }

  isWithdraw(String id) {
    return id == 'withdraw';
  }

  isTransfer(String id) {
    return id == 'transfer';
  }
}

class TransactionTypeModel {
  String id = '';
  String name = '';

  TransactionTypeModel({required String this.id, required String this.name}) {}
}

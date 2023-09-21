class WalletType {
  late WalletType _walletType;

  get walletType async {
    if (_walletType == null) {
      _walletType = await initializeWalletType();
    }
    return _walletType as dynamic;
  }

  initializeWalletType() async {
    return WalletType();
  }

  List<WalletTypeModel> getList() {
    List<WalletTypeModel> list = [
      WalletTypeModel(id: 'Cash', name: 'Cash'),
      WalletTypeModel(id: 'Bank', name: 'Bank'),
      WalletTypeModel(id: 'Ewallet', name: 'E-wallet'),
      WalletTypeModel(
        id: 'Credit',
        name: 'Credit',
      ),
      WalletTypeModel(id: 'Other', name: 'Other'),
    ];
    return list;
  }
}

class WalletTypeModel {
  String id = '';
  String name = '';

  WalletTypeModel({required String this.id, required String this.name}) {}
}

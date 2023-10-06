class TotalWithdrawByWallet {
  late String walletId;
  late String walletName;
  late double total;

  TotalWithdrawByWallet.fromObject(dynamic o) {
    walletId = o["walletId"];
    walletName = o["walletName"];
    total = o["total"];
  }
}

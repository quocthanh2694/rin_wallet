import 'package:flutter/material.dart';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/transaction_category.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/ui/page/transaction_page.dart';

class TransactionCategoryCard extends StatelessWidget {
  final VoidCallback onPressed;
  final TransactionCategory transactionCategory;

  const TransactionCategoryCard(
      {super.key, required this.transactionCategory, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    if (transactionCategory == null) return Container();

    return InkWell(
      borderRadius: BorderRadius.circular(radiusSm),
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radiusSm),
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "${this.transactionCategory.name}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ]),
            ],
          )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransactionPage(
                    walletId: this.transactionCategory.id,
                  )),
        );
      },
    );
  }
}

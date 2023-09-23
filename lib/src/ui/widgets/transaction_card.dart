import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/transaction.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/ui/page/transaction_page.dart';
import 'package:rin_wallet/src/utils/datetime.util.dart';
import 'package:rin_wallet/src/utils/number.utils.dart';

class TransactionCard extends StatelessWidget {
  final VoidCallback onPressed;
  final WalletTransaction transaction;

  const TransactionCard(
      {super.key, required this.transaction, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    if (transaction == null) return Container();

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
                  "${this.transaction.description}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                Text(
                  "${formatNumber(trailingZero(transaction.amount ?? 0.0))}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                // Text(
                //   this.wallet.currencyUnit,
                //   style: Theme.of(context).textTheme.headlineSmall,
                // ),
              ]),
              transaction.description!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${transaction.description}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    formatDateTime(transaction.dateTime),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Text(
              //       // TODO: test float double to int here
              //       "${formatNumber(trailingZero(this.wallet.initialAmount))}${this.wallet.currencyUnit == '\$' ? '\$' : ''}",
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //   ],
              // )
            ],
          )),
      // onLongPress: (){

      // },
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => TransactionPage(
        //             walletId: this.transaction.id,
        //           )),
        // );
      },
    );
  }
}

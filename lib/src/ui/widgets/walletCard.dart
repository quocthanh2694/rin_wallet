import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/utils/datetime.util.dart';
import 'package:rin_wallet/src/utils/number.utils.dart';

class WalletCard extends StatelessWidget {
  final VoidCallback onPressed;
  final Wallet wallet;

  const WalletCard({super.key, required this.wallet, required this.onPressed});
  @override
  Widget build(BuildContext context) {
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
                  "${this.wallet.name}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                Text(
                  "${formatNumber(trailingZero(wallet.balance ?? 0.0))}${this.wallet.currencyUnit == '\$' ? '\$' : ''}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                // Text(
                //   this.wallet.currencyUnit,
                //   style: Theme.of(context).textTheme.headlineSmall,
                // ),
              ]),
              wallet.description!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${wallet.description}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    formatDateTime(this.wallet.dateTime),
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
      onTap: () {
        print('tapped');
      },
    );
  }
}

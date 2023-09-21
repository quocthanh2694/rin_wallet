import 'package:flutter/material.dart';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/wallet.dart';

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
                  this.wallet.currencyUnit,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text("Pressed Follow on $platform button"),
                //         duration: const Duration(seconds: 1),
                //       ),
                //     );
                //     onPressed();
                //   },
                //   child: Text("Follow"),
                // )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    this.wallet.initialAmount.toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              )
            ],
          )),
      onTap: () {
        print('tapped');
      },
    );
  }
}

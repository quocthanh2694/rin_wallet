// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:rin_wallet/src/models/wallet.dart';
// import 'package:uuid/uuid.dart';

class AppStoreModel extends ChangeNotifier {
  /// The private field backing [catalog].
  // late CatalogModel _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.
  // final List<Uuid> _itemIds = [];

  /// The current catalog. Used to construct items from numeric ids.
  // CatalogModel get catalog => _catalog;

  // set catalog(CatalogModel newCatalog) {
  //   _catalog = newCatalog;
  //   // Notify listeners, in case the new catalog provides information
  //   // different from the previous one. For example, availability of an item
  //   // might have changed.
  //   notifyListeners();
  // }

  /// List of items in the cart.
  List<Wallet> wallets = [];

  /// The current total price of all items.
  // int get totalPrice =>
  //     items.fold(0, (total, current) => total + current.price);

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void addWallet(Wallet item) {
    wallets.add(item);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    // notifyListeners();
  }

  void removeWallet(Wallet item) {
    wallets.remove(item);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    // notifyListeners();
  }
}

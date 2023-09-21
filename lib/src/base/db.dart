import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db as dynamic;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "rin_wallet_db.db");
    var rinWalletDb =
        await openDatabase(dbPath, version: 1, onCreate: createDb);
    return rinWalletDb;
  }

  FutureOr<void> createDb(Database db, int version) async {
    await db.execute("""
      Create table wallets(
        id text primary key, 
        name text,
        walletTypeId text,
        dateTime text,
        currencyUnit text,
        description text,
        initialAmount int,
        totalDeposit int,
        totalWithdraw int,
        balance int
      )
      """);
  }

  Future<List<Wallet>> getWallets() async {
    Database db = await this.db;
    var result = await db.query("wallets");
    List<Wallet> list = List.generate(result.length, (i) {
      // dynamic item = result[i];
      // return new Wallet(item);
      return Wallet.fromObject(result[i]);
    });
    return list;
  }

  Future<int> insertWallet(Wallet wallet) async {
    Database db = await this.db;
    var result = await db.insert("wallets", wallet.toMap());
    return result;
  }

  Future<int> deleteWallet(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete("delete from wallets where id= $id");
    return result;
  }

  Future<void> updateWallet(Wallet wallet) async {
    Database db = await this.db;
    var result = await db.update("wallets", wallet.toMap(),
        where: "id=?", whereArgs: [wallet.id]);
    // return result;
  }

  Future<void> backupDB(String destinationPath) async {
    String dbPath = join(await getDatabasesPath(), "rin_wallet_db.db");
    var file = File(dbPath);
    String today = DateFormat('yyyy_MM_dd').format(DateTime.now());
    await file.copy(destinationPath + "/${today}_${"rin_wallet_db.db"}");
    print('..Copied!!!!');
  }

  Future<void> restoreDB(String restoreFilePath) async {
    var file = File(restoreFilePath);
    await file.copy(await getDatabasesPath() + "/${"rin_wallet_db.db"}");
    print('...Restored!!!!');
  }
}

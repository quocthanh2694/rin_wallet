import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:rin_wallet/src/models/transaction_category.dart';
import 'package:rin_wallet/src/models/user_note.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/models/transaction.dart';
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
        initialAmount double,
        totalDeposit double,
        totalWithdraw double,
        balance double
      )
      """);

    await db.execute("""
      Create table transactions(
        id text primary key, 
        walletId text,
        amount double,
        walletTransactionTypeId text,
        categoryId text,
        description text,
        dateTime text,
        imgUrl text
      )
      """);

    await db.execute("""
      Create table transaction_categories(
        id text primary key, 
        name text
      )
      """);

    await db.execute("""
      Create table user_notes(
        id text primary key, 
        note text,
        description text
      )
      """);
  }

  Future<List<Wallet>> getWallets() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * from wallets ORDER BY name");

    List<Wallet> list = List.generate(result.length, (i) {
      // dynamic item = result[i];
      // return new Wallet(item);
      return Wallet.fromObject(result[i]);
    });
    return list;
  }

  updateWalletAmount(String id, double amount) async {
    // print(id +  '::::==='+ amount.toString());
    Database db = await this.db;
    List<Map<String, Object?>> res = await db.rawQuery(
        "UPDATE wallets SET balance = balance + ? WHERE id=?", [amount, id]);
    return res;
  }

  Future<Wallet?> getWalletById(String id) async {
    Database db = await this.db;
    List<Map> result =
        await db.rawQuery("SELECT * from wallets WHERE id=?", [id]);
    if (result == null) return null;
    return Wallet.fromObject(result[0]);
  }

  Future<int> insertWallet(Wallet wallet) async {
    Database db = await this.db;
    var result = await db.insert("wallets", wallet.toMap());
    return result;
  }

  Future<int> deleteWallet(String id) async {
    Database db = await this.db;
    var result = await db.rawDelete("delete from wallets where id=?", [id]);
    return result;
  }

  Future<void> updateWallet(Wallet wallet) async {
    Database db = await this.db;
    var result = await db.update("wallets", wallet.toMap(),
        where: "id=?", whereArgs: [wallet.id]);
    // return result;
  }

  //#region Transactions
  Future<List<WalletTransaction>> getTransactions(String walletId) async {
    Database db = await this.db;
    List<Map> result = await db.rawQuery(
        "SELECT * from transactions WHERE walletId=? ORDER BY dateTime DESC",
        [walletId]);

    List<WalletTransaction> list = List.generate(result.length, (i) {
      print(result[i]);
      return WalletTransaction.fromObject(result[i]);
    });

    return list;
  }

  Future<int> insertTransaction(WalletTransaction transaction) async {
    Database db = await this.db;
    var result = await db.insert("transactions", transaction.toMap());
    // TODO: validate + or -
    await updateWalletAmount(transaction.walletId, transaction.amount);
    return result;
  }

  deleteTransaction(String transactionId) async {
    Database db = await this.db;
    await db.rawQuery("Delete from transactions WHERE id=?", [transactionId]);

    return true;
  }
  //#endregion

  //#region User notes
  Future<List<UserNote>> getUserNotes() async {
    Database db = await this.db;
    List<Map> result = await db.rawQuery("SELECT * from user_notes");

    List<UserNote> list = List.generate(result.length, (i) {
      print(result[i]);
      return UserNote.fromObject(result[i]);
    });

    return list;
  }

  Future<int> insertUserNotes(UserNote data) async {
    Database db = await this.db;
    var result = await db.insert("user_notes", data.toMap());
    return result;
  }

  deleteUserNote(String id) async {
    Database db = await this.db;
    await db.rawQuery("Delete from user_notes WHERE id=?", [id]);
    return true;
  }
  //#endregion

  //#region Transaction categories
  Future<List<TransactionCategory>> getTransactionCategories() async {
    Database db = await this.db;
    List<Map> result =
        await db.rawQuery("SELECT * from transaction_categories");

    List<TransactionCategory> list = List.generate(result.length, (i) {
      print(result[i]);
      return TransactionCategory.fromObject(result[i]);
    });

    return list;
  }

  Future<int> insertTransactionCategory(TransactionCategory data) async {
    Database db = await this.db;
    var result = await db.insert("transaction_categories", data.toMap());
    return result;
  }

  deleteTransactionCategory(String id) async {
    Database db = await this.db;
    await db.rawQuery("Delete from transaction_categories WHERE id=?", [id]);
    return true;
  }
  //#endregion

  //#region Backup & Restore
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
  //#endregion
}

import 'package:uuid/uuid.dart';

class WalletType {
  final Uuid id;
  final String name;
  final String imgUrl = '';

  WalletType({
    required this.id,
    required this.name,
  }) {}
}

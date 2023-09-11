import 'package:uuid/uuid.dart';

class Category {
  final Uuid id;
  final String name;
  final String description = '';
  final String imgUrl = '';

  Category({required this.id, required this.name}) {}
}

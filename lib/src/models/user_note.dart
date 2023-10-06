class UserNote {
  late String id;
  late String title;
  late String note;
  late String description;

  UserNote({
    String id = '',
    String title = '',
    String note = '',
    String description = '',
  }) {
    this.id = id;
    this.title = title;
    this.note = note;
    this.description = description;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = title;
    map["note"] = note;
    map["description"] = description;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  UserNote.fromObject(dynamic o) {
    id = o["id"];
    title = o["title"].toString();
    note = o["note"].toString();
    description = o["description"].toString();
  }
}

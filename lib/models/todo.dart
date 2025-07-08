class Todo {
  Todo({required this.title, required this.dateTime});

  //---------------Pasta que faz pegar a hora e data atual------------//

  Todo.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      dateTime = DateTime.parse(json['datetime']);

  String title;
  DateTime dateTime;

  Map<String, dynamic> toJson() {
    return {'title': title, 'datetime': dateTime.toIso8601String()};
  }
}

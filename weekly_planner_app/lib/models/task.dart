class Task {
  final int id;
  final String title;
  final String? day;
  final String? time;
  final int? categoryId;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    this.day,
    this.time,
    this.categoryId,
    required this.isDone,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      day: json['day'],
      time: json['time'],
      categoryId: json['category_id'],
      isDone: json['is_done'] == true || json['is_done'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'day': day,
      'time': time,
      'category_id': categoryId,
      'is_done': isDone,
    };
  }
}
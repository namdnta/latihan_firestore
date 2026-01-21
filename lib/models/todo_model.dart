class TodoModel {
  final String id;
  final String taskName;
  final String? dueDate; // ISO8601 string or null
  final String priority; // high|medium|low
  final String category; // study|work|personal|school
  final String? description;
  final bool isDone;
  final String createdAt; // ISO8601
  final String updatedAt; // ISO8601

  const TodoModel({
    required this.id,
    required this.taskName,
    this.dueDate,
    required this.priority,
    required this.category,
    this.description,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoModel.fromMap(Map<dynamic, dynamic> map) {
    return TodoModel(
      id: (map['id'] ?? '').toString(),
      taskName: (map['taskName'] ?? '').toString(),
      dueDate: map['dueDate']?.toString(),
      priority: (map['priority'] ?? 'low').toString(),
      category: (map['category'] ?? '').toString(),
      description: map['description']?.toString(),
      isDone: (map['isDone'] ?? false) == true,
      createdAt: (map['createdAt'] ?? '').toString(),
      updatedAt: (map['updatedAt'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'taskName': taskName,
        'dueDate': dueDate,
        'priority': priority,
        'category': category,
        'description': description,
        'isDone': isDone,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

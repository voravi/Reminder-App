class Reminder {
  int? id;
  final String task;
  final String taskDesc;
  final String endTime;

  Reminder({
    this.id,
    required this.task,
    required this.taskDesc,
    required this.endTime,
  });

  factory Reminder.fromMap({required Map data}) {
    return Reminder(
      id: data["id"],
      task: data["task"],
      taskDesc: data["taskDesc"],
      endTime: data["endTime"],
    );
  }
}


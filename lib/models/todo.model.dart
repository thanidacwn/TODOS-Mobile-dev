import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoModel {
  String? todoId;
  String? todoTopic;
  String? todoDescription;
  String? todoDate;
  String? todoStatus = 'pending';

  ToDoModel({
    this.todoId,
    this.todoTopic,
    this.todoDescription,
    this.todoDate,
    this.todoStatus
  });

  factory ToDoModel.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return ToDoModel(
        todoId: parsedJson['_id'],
        todoTopic: parsedJson['todo_topic'],
        todoDescription: parsedJson['todo_description'],
        todoDate: parsedJson['todo_date'],
        todoStatus: parsedJson['todo_status'],
      );
    } catch (ex) {
      throw ('factory ToDoModel.fromJson ====> $ex');
    }
  }

  factory ToDoModel.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot, [SnapshotOptions? options]) {
    final data = snapshot.data();
    return ToDoModel(
      todoId: snapshot.id,
      todoTopic: data!['todo_topic'],
      todoDescription: data['todo_description'],
      todoDate: data['todo_date'],
      todoStatus: data['todo_status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'todo_topic': todoTopic,
        'todo_description': todoDescription,
        'todo_date': todoDate,
        'todo_status': todoStatus,
      };

  Map<String, Object?> toFirestore(){
    return {
      'todo_topic': todoTopic,
      'todo_description': todoDescription,
      'todo_date': todoDate,
      'todo_status': todoStatus,
    };
  }
}

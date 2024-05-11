import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_ui_flutter/utilities/generateRandomString.dart';

class FireStoreService {
  final CollectionReference todos =
      FirebaseFirestore.instance.collection('todo_list');

// This function will add the todo to the firestore
  Future<void> addTodos(String topic, String description, String date) {
    return todos.add({
      'todoId': GenerateString.generateRandomString(8),
      'todoTopic': topic,
      'todoDescription': description,
      'todoDate': date,
      'todoStatus': 'pending'
    });
  }
  
  Future<void> updateTodos(String id, String topic, String description, String date) {
    return todos.doc(id).update({
      'todoTopic': topic,
      'todoDescription': description,
      'todoDate': date,
      'todoStatus': 'pending'
    });
  }


  Stream<QuerySnapshot> getTodos() {
    return todos.snapshots();
  }


  Future<void> deleteTodo(String id) {
    return todos.doc(id).delete();
  }

  Future<void> deleteTodoDone(String todoId){
    return todos.where('todoId', isEqualTo: todoId).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<void> updateTodoStatus(String id, String status) {
    return todos.doc(id).update({'todoStatus': status});
  }

}

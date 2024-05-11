
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_ui_flutter/models/todo.model.dart';
import 'package:to_do_ui_flutter/services/firestore.dart';
import 'package:to_do_ui_flutter/utilities/datetime_format.dart';
import 'package:to_do_ui_flutter/utilities/generateRandomString.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FireStoreService fireStoreService = FireStoreService();

  TextEditingController topicController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<ToDoModel> items = <ToDoModel>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'To-Do list',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              dialogForm();
            },
            icon: const Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            items = snapshot.data!.docs
                .map((e) => ToDoModel(
                      todoId: e.id,
                      todoTopic: e['todoTopic'],
                      todoDescription: e['todoDescription'],
                      todoDate: e['todoDate'],
                      todoStatus: e['todoStatus'],
                    ))
                    .where((todo) => todo.todoStatus == 'pending')
                .toList();

                return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder:
         (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${items[index].todoTopic}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text('Due date: ${ DateTimeFormat.date(items[index].todoDate!)}'),
                      Text('Description: ${items[index].todoDescription}'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                dialogForm(item: items[index]);
                              },
                              child: const Icon(Icons.edit, color: Colors.yellow),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => GestureDetector(
                                    onTap: () => FocusScope.of(context).unfocus(),
                                    child: AlertDialog(
                                      content: const Text(
                                        'Do you want to delete?',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                      ),
                                      actionsAlignment: MainAxisAlignment.center,
                                      actions: <Widget>[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Colors.redAccent),
                                          onPressed: () {
                                            setState(() {
                                              String todoId = items[index].todoId!;
                                              fireStoreService.deleteTodo(todoId);
                                              items.removeAt(index);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Colors.greenAccent[400], padding: const EdgeInsets.symmetric(horizontal: 12)),
                          onPressed: () {
                            setState(() {
                              String todoId = items[index].todoId!;
                              fireStoreService.updateTodoStatus(todoId, 'complete');
                              items.removeAt(index);
          
                            });
                          },
                          child: const Text('Mark as Done', style: TextStyle(color: Colors.black, fontSize: 12)),
          
                        )
                      ],
                    )),
              ],
            ),
          );
        },
      );
          }else{
            return const Text("No Todos");
          }
          
        },
        )
      

    );
  }

  void dialogForm({ToDoModel? item}) {
    // This function will show the dialog form, and set the value to the controller
    if (item == null) {
      topicController.text = '';
      descriptionController.text = '';
      List<String> datetime = DateTime.now().toString().split(' ');
      dateController.text = '${datetime[0]} ${datetime[1].split(':')[0]}:${datetime[1].split(':')[1]}';
    } else {
      topicController.text = item.todoTopic ?? '';
      descriptionController.text = item.todoDescription ?? '';
      List<String> datetime = DateTime.parse(item.todoDate ?? '').toLocal().toString().split(' ');
      dateController.text = '${datetime[0]} ${datetime[1].split(':')[0]}:${datetime[1].split(':')[1]}';
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          title: Center(child: Text(item != null ? 'Edit To-Do' : 'Add To-Do')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(flex: 2, child: Text('Topic: ')),
                  Expanded(flex: 8, child: TextFormField(controller: topicController)),
                ],
              ),
              Row(
                children: [
                  const Expanded(flex: 3, child: Text('Description: ')),
                  Expanded(flex: 7, child: TextFormField(controller: descriptionController)),
                ],
              ),
              Row(
                children: [
                  const Expanded(flex: 3, child: Text('Due date: ')),
                  Expanded(
                      flex: 6,
                      child: TextFormField(
                        controller: dateController,
                        readOnly: true,
                        onTap: () {
                          datePicker();
                        },
                      )),
                  GestureDetector(
                    onTap: () {
                      datePicker();
                    },
                    child: const Expanded(
                      flex: 1,
                      child: Icon(Icons.date_range),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Colors.deepPurple),
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (item == null) {
                  setState(() {
                    items.add(
                      ToDoModel(
                        todoId: GenerateString.generateRandomString(8),
                        todoTopic: topicController.text,
                        todoDescription: descriptionController.text,
                        todoDate: dateController.text,
                      ),
                    );
                  });

                  fireStoreService.addTodos(topicController.text, descriptionController.text, dateController.text);


                } else {
                  int index = items.indexOf(item);
                  ToDoModel newTodo = ToDoModel(
                    todoId: item.todoId,
                    todoTopic: topicController.text,
                    todoDescription: descriptionController.text,
                    todoDate: dateController.text,
                  );

                  fireStoreService.updateTodos(item.todoId!, topicController.text, descriptionController.text, dateController.text);

                  setState(() {
                    items[index] = newTodo;
                  });

                }
                Navigator.of(context).pop();
              },
              child: Text(
                item != null ? 'Save' : 'Create',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void datePicker() {
    // This function will show the date picker, and set the selected date to the dateController
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime:  DateTime(DateTime.now().year + 2),
      onConfirm: (dateResult) {
        final [date, time] = dateResult.toString().split(' ');
        final [hour, minute, sec] = time.split(':');
        setState(() {
          dateController.text = '$date $hour:$minute';
        });
      },
      currentTime: DateTime.parse(dateController.text),
      locale: LocaleType.th,
    );
  }

}

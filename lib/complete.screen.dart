
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:to_do_ui_flutter/models/todo.model.dart';
import 'package:to_do_ui_flutter/services/firestore.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  final FireStoreService fireStoreService = FireStoreService();
    List<ToDoModel> items = <ToDoModel>[];


  List<ChartData> chartData = [
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Complete',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                    .toList();}


              int completedItems = items.where((element) => element.todoStatus == 'complete').length;

              double completedPercent = (completedItems / items.length) * 100;
              double incompletedPercent = 100 - completedPercent;

              chartData = [
                ChartData('complete', completedPercent, Colors.deepPurple),
                ChartData('non', incompletedPercent, Colors.grey),
              ];

      return Container(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SfCircularChart(
            title: const ChartTitle(
              text: 'Complete',
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Text(
                  '${completedPercent.toStringAsFixed(2)}%',
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ],
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                  dataSource: chartData,
                  pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  innerRadius: '90%')
            ],
          ),
        ),
      );}
    ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

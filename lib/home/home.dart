import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_manager/data/TaskDataHive.dart';

import 'package:my_manager/data/model/taskdatamodel.dart';

import 'package:my_manager/home/bloc/home_bloc.dart';

import 'package:my_manager/them/colors.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();
  TextEditingController taskNameController = TextEditingController();
  String selectedTime = '';
  TaskDataModel taskDataModel = TaskDataModel();
  List<List<TaskData>> taskDataGrid = [];
  int count = 0;
  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHight = MediaQuery.of(context).size.height;
    final DateTime now = DateTime.now();
    final firstDay = now.subtract(Duration(days: now.weekday - 1));
    final lastDay = now.add(Duration(days: 7 - now.weekday));

    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNewTaskAddButtonClickedState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Good Desicion')));
        } else if (state is HomeTaskDeletedState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Ops !! consistance is the key of success')));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeErrorState:
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          case HomeLoadingState:
            return Scaffold(
              appBar: AppBar(
                backgroundColor: primary,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .2),
                child: Center(
                  child: Image.asset(
                    'lib/assets/loading.gif',
                  ),
                ),
              ),
            );
          case HomeLoadSuccessState:
            // ignore: unused_local_variable
            final successState = state as HomeLoadSuccessState;
            final taskDataList = state.taskDataList;
            final dataMap = <String, double>{
              "Completed":
                  taskDataModel.getCompletedCount(taskDataList).toDouble(),
              "Not Completed":
                  taskDataModel.getnotCompletedCount(taskDataList).toDouble(),
            };
            final colorList = <Color>[
              // Colors.greenAccent,
              // Colors.red,
              dcolor1, fcolor1
            ];

            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: primary,
                    expandedHeight: screenHight * .01,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        TableCalendar(
                          headerVisible: false,
                          calendarFormat: CalendarFormat.week,
                          lastDay: lastDay,
                          firstDay: firstDay,
                          focusedDay: now,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * .06),
                          child: taskDataList.length == 0
                              ? Image.asset(
                                  'lib/assets/emptylist.gif',
                                  height: screenHight * .3,
                                  width: screenWidth,
                                )
                              : PieChart(
                                  dataMap: dataMap,
                                  chartType: ChartType.ring,
                                  baseChartColor:
                                      Colors.grey[50]!.withOpacity(0.15),
                                  colorList: colorList,
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValuesInPercentage: true,
                                  ),
                                  totalValue: taskDataList.length.toDouble(),
                                ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final containerhight = screenHight * .1;
                        final containerwidth = screenWidth * .8;
                        var check = taskDataList[index].isComplete;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: screenHight * .11,
                            width: screenWidth * .8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: check
                                      ? [dcolor2, dcolor1]
                                      : [fcolor2, fcolor1]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: check ? dcolor2 : fcolor2),
                                  height: containerhight,
                                  width: containerwidth * 2,
                                ),
                                Container(
                                  child: check
                                      ? Image.asset(
                                          'lib/assets/happy.gif',
                                          fit: BoxFit.fitWidth,
                                          width: containerwidth * 2,
                                        )
                                      : null,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: containerhight * .3,
                                      left: containerwidth * .4),
                                  child: Text(
                                    taskDataList[index].taskName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade800),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: containerhight * .8,
                                      left: containerwidth * .4),
                                  child: Text(
                                    taskDataList[index].time,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: containerhight * .2,
                                      left: containerwidth * .01),
                                  child: Checkbox(
                                    value: taskDataList[index].isComplete,
                                    onChanged: (value) async {
                                      final taskDataModel = TaskDataModel();
                                      taskDataModel.taskComplete(
                                          TaskData(
                                              id: taskDataList[index].id,
                                              taskName:
                                                  taskDataList[index].taskName,
                                              time: taskDataList[index].time,
                                              isComplete: taskDataList[index]
                                                  .isComplete),
                                          context);

                                      homeBloc.add(
                                          HomeTaskCompltedButtonClickedEvent());
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: containerhight * .3,
                                      left: containerwidth * .93),
                                  child: IconButton(
                                      onPressed: () {
                                        final taskDataModel = TaskDataModel();
                                        taskDataModel
                                            .deleteRow(taskDataList[index].id);
                                        homeBloc.add(HomeTaskDeletedEvent());
                                      },
                                      icon: Icon(Icons.delete)),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: taskDataList.length,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      height: screenHight,
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                clipBehavior: Clip.hardEdge,
                backgroundColor: primary2,
                onPressed: () {
                  showModalBottomSheet(
                    shape: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(25, 25),
                            topRight: Radius.elliptical(25, 25))),
                    context: context,
                    builder: (context) {
                      //      final dueDateController = TextEditingController();

                      return SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: bottomsheetpri,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          height:
                              MediaQuery.of(context).viewInsets.bottom + 600,
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  'Add Task',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: taskNameController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Task Name',
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    'Choose a deadline Time',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      onPressed: () => _selectTime(context),
                                      icon: const Icon(Icons.lock_clock)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final taskDataModel = TaskDataModel();

                                  taskDataModel.addTask(TaskData(
                                    id: 1,
                                    taskName: taskNameController.text,
                                    time: selectedTime,
                                    isComplete: false,
                                  ));
                                  Navigator.pop(context);
                                  homeBloc
                                      .add(HomeNewTaskAddButtonClickedEvent());
                                  setState(() {
                                    taskNameController.clear();
                                    selectedTime = '';
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .13,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 60),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: bottomsheetpri2,
                                      ),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: Text(
                                          'Add +',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                backgroundColor: primary,
              ),
              body: Image.asset(
                'lib/assets/loading.gif',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            );
        }
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final hour = picked.hourOfPeriod; // 1-12
      final minute = picked.minute;
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';

      setState(() {
        selectedTime = '$hour:$minute $period';
      });
    }
  }
}

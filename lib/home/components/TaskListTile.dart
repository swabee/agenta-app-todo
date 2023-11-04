import 'package:flutter/material.dart';

import 'package:my_manager/home/bloc/home_bloc.dart';

// ignore: must_be_immutable
class TaskListTile extends StatefulWidget {
  TaskListTile({
    Key? key,
    required this.len,
    required this.wid,
    required this.taskname,
    required this.date,
    required this.time,
    required this.isfinished,
    required this.homeBloc,
  });
  double len;
  double wid;
  String taskname;
  String date;
  String time;
  bool isfinished;

  final homeBloc;

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool isChecked = false;
  HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    const Color dcolor1 = Color.fromARGB(255, 9, 205, 16);
    const Color dcolor2 = Color.fromARGB(255, 152, 240, 155);
    const Color fcolor1 = Color.fromARGB(255, 197, 1, 191);
    const Color fcolor2 = Color.fromARGB(255, 255, 168, 245);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:
                  widget.isfinished ? [dcolor2, dcolor1] : [fcolor2, fcolor1]),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
      height: widget.len,
      width: widget.wid,
      child: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: widget.len * .3, left: widget.wid * .23),
            child: Text(
              widget.taskname,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: widget.len * .75, left: widget.wid * .23),
            child: Text(
              widget.date,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: widget.len * .75, left: widget.wid * .63),
            child: Text(
              widget.time,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 7, 6, 6)),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: widget.wid * .05, top: widget.len * .3),
            child: Checkbox(
              value: widget.isfinished,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    isChecked = value;
                    widget.isfinished = !widget.isfinished;
                  });
                }
              },
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: widget.wid * .85, top: widget.len * .3),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          )
        ],
      ),
    );
  }
}

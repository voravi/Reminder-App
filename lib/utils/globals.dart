import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reminder_app/modals/reminder.dart';
import 'package:reminder_app/utils/colours.dart';

Widget myContainer({required BuildContext context, required Reminder reminder,required int index,required Function()? editOnTap,required Function()? deleteOnTap}) {
  List<String> splitString = reminder.endTime.split(" ");
  int hour = int.parse(splitString[0]);
  (hour > 12) ? hour = hour - 12 : hour = hour;
  String myString = "${hour} : ${splitString[2] } ${splitString[3]}";

  return Container(
    alignment: Alignment.centerRight,
    height: 140,
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: colorList[index],
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.10),
          offset: const Offset(0, 0),
          spreadRadius: 5,
          blurRadius: 8,
        ),
      ],
      borderRadius: BorderRadius.circular(15),
    ),
    child: Container(
      padding: EdgeInsets.all(10),
      height: 140,
      width: 305,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.task,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    reminder.taskDesc,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              Checkbox(
                value: true,
                onChanged: (val) {},
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
          Row(
            children: [
              Text(
                myString,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.notifications_active_outlined,
                // color: Colors.red,
                color: Colors.grey,
              ),
              const Spacer(),
              IconButton(
                onPressed: editOnTap,
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.lightBlue,
                ),
              ),
              IconButton(
                onPressed: deleteOnTap,
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

List<Color> colorList = [
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
  light1,
  light2,
  light3,
  light4,
  light5,
  light6,
];

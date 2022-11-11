import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/modals/reminder.dart';
import 'package:reminder_app/providers/notification_helper.dart';
import '../../../providers/app_theme_provider.dart';
import '../../../providers/reminder_db_helper.dart';
import '../../../utils/globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController insertTaskController = TextEditingController();
  TextEditingController insertDescController = TextEditingController();

  TextEditingController updateTaskController = TextEditingController();
  TextEditingController updateDescController = TextEditingController();

  late Future<List<Reminder>> reminders;
  GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  late DateTime newDateTime;
  String task = "";
  String descTask = "";
  TimeOfDay currentTime = TimeOfDay.now();
  String taskEndTime = "hh : mm";
  String realTime = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reminders = ReminderDBHelper.reminderDBHelper.fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network(
                      "https://media.baamboozle.com/uploads/images/8578/1575967971_152588",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  "Hello,",
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
                subtitle: Text(
                  "Joko Husein",
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 2,
                          )),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 2,
                          )),
                      child: IconButton(
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false).changeTheme();
                        },
                        icon: Icon(
                          Icons.brightness_6_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Tasks",
                          style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "View more",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 498,
                      width: 340,
                      child: FutureBuilder(
                        future: reminders,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("ERROR: ${snapshot.error}"),
                            );
                          } else if (snapshot.hasData) {
                            List<Reminder>? data = snapshot.data;
                            return ListView.builder(
                              itemCount: data!.length,
                              itemBuilder: (context, i) {
                                return myContainer(
                                    context: context,
                                    reminder: data[i],
                                    index: i,
                                    editOnTap: () {
                                      updateData(context, data: data[i], i: data[i].id);
                                    },
                                    deleteOnTap: () async {
                                      log("tapped");
                                      await ReminderDBHelper.reminderDBHelper.deleteSingleData(id: data[i].id);
                                      reminders = ReminderDBHelper.reminderDBHelper.fetchAllData();
                                      setState(() {});
                                    });
                              },
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        insertReminder(context);
                      },
                      child: Ink(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Create New",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  insertReminder(BuildContext context) {
    log("I tapped", name: "Why");
    showDialog(
      context: context,
      builder: ((context) {
        return StatefulBuilder(
          builder: (context, setState) => Material(
            color: Theme.of(context).splashColor,
            child: Container(
              height: 250,
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Theme.of(context).splashColor,
              child: Form(
                key: insertFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 5,
                      indent: 120,
                      endIndent: 120,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New Task",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Title Task",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).disabledColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.9),
                      ),
                      controller: insertTaskController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        border: InputBorder.none,
                        hintText: "Enter Task",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.withOpacity(0.9),
                        ),
                      ),
                      onSaved: (val) {
                        setState(() {
                          task = val!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Task";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).disabledColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 4,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.9),
                      ),
                      controller: insertDescController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        border: InputBorder.none,
                        hintText: "Enter Description",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.withOpacity(0.9),
                        ),
                      ),
                      onSaved: (val) {
                        setState(() {
                          descTask = val!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Description";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Time",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        TimeOfDay? result = await showTimePicker(
                          context: context,
                          initialTime: currentTime,
                        );
                        if (result?.hour != null && result!.hour > 12) {
                          setState(() {
                            realTime = "${result.hour} : ${result.minute} ${result.period.name.toUpperCase()}";
                            int hour = result.hour;
                            if (hour > 12) hour = hour - 12;
                            taskEndTime = "$hour : ${result.minute} ${result.period.name.toUpperCase()}";
                            log(taskEndTime, name: "task End time");
                          });
                        } else {
                          taskEndTime = "hh : mm";
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              taskEndTime,
                              style: TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.white.withOpacity(0.2),
                            onTap: () {
                              Navigator.pop(context);
                              insertTaskController.clear();
                              insertDescController.clear();
                              taskEndTime = "hh : mm";
                            },
                            child: Ink(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (insertFormKey.currentState!.validate()) {
                                insertFormKey.currentState!.save();
                                Reminder data = Reminder(task: task, taskDesc: descTask, endTime: realTime);
                                int val = await ReminderDBHelper.reminderDBHelper.insertData(data: data);

                                log("$val", name: "Insert Data:");
                                reminders = ReminderDBHelper.reminderDBHelper.fetchAllData();
                                LocalNotificationHelper.localNotificationHelper.showLocalScheduleNotification(reminder: data);
                                Navigator.pop(context);
                              }
                              insertTaskController.clear();
                              insertDescController.clear();
                              taskEndTime = "hh : mm";
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 21),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Create"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    ).then((value) => setState(() {}));
  }

  updateData(BuildContext context, {required Reminder data, required int? i}) {
    updateTaskController.text = data.task;
    updateDescController.text = data.taskDesc;
    showDialog(
      context: context,
      builder: ((context) {
        return StatefulBuilder(
          builder: (context, setState) => Material(
            color: Theme.of(context).splashColor,
            child: Container(
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Theme.of(context).splashColor,
              child: Form(
                key: updateFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      thickness: 5,
                      indent: 120,
                      endIndent: 120,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New Task",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Title Task",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.9),
                      ),
                      controller: updateTaskController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        border: InputBorder.none,
                        hintText: "Enter Task",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.withOpacity(0.9),
                        ),
                      ),
                      onSaved: (val) {
                        setState(() {
                          task = val!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Task";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 4,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.9),
                      ),
                      controller: updateDescController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        border: InputBorder.none,
                        hintText: "Enter Description",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.withOpacity(0.9),
                        ),
                      ),
                      onSaved: (val) {
                        setState(() {
                          descTask = val!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Description";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Time",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        TimeOfDay? result = await showTimePicker(
                          context: context,
                          initialTime: currentTime,
                        );
                        if (result?.hour != null && result!.hour > 12) {
                          setState(() {
                            realTime = "${result.hour} : ${result.minute} ${result.period.name.toUpperCase()}";
                            int hour = result.hour;
                            if (hour > 12) hour = hour - 12;
                            taskEndTime = "$hour : ${result.minute} ${result.period.name.toUpperCase()}";
                          });
                        } else {
                          taskEndTime = "hh : mm";
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              taskEndTime,
                              style: const TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.white.withOpacity(0.2),
                            onTap: () {
                              insertTaskController.clear();
                              insertDescController.clear();
                              taskEndTime = "hh : mm";
                              Navigator.pop(context);
                            },
                            child: Ink(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (updateFormKey.currentState!.validate()) {
                                updateFormKey.currentState!.save();
                                Reminder data = Reminder(task: task, taskDesc: descTask, endTime: realTime);
                                int val = await ReminderDBHelper.reminderDBHelper.updateData(data: data, id: i);
                                log(val.toString(), name: "value");

                                reminders = ReminderDBHelper.reminderDBHelper.fetchAllData();
                                LocalNotificationHelper.localNotificationHelper.showLocalScheduleNotification(reminder: data);
                                insertTaskController.clear();
                                insertDescController.clear();
                                taskEndTime = "hh : mm";
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 21),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Update"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    ).then((value) => setState(() {}));
  }
}

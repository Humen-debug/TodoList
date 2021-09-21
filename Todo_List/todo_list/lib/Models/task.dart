import "package:flutter/material.dart";

class Task {
  int _id = 0;
  bool _isCompleted = false;
  String _task = '', _date = '', _time = '', _status = '';

  Task(this._task, this._date, this._isCompleted, this._time, this._status);
  Task.withId(this._id, this._task, this._date, this._isCompleted, this._time, this._status);

  int get id => _id;
  // bool get isCompleted => _isCompleted;
  set isCompleted(bool newIsCompleted) => _isCompleted = newIsCompleted;
  set task(String newTask) => _task = newTask;
  set date(String newDate) => _date = newDate;
  set time(String newTime) => _time = newTime;
  set status(String newStatus) => _status = newStatus;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['isCompleted'] = _isCompleted;
    map['task'] = _task;
    map['date'] = _date;
    map['time'] = _time;
    map['status'] = _status;
    return map;
  }

  //Extract Task object from MAP object
  Task.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _isCompleted = map['isCompleted'];
    _task = map['task'];
    _date = map['date'];
    _time = map['time'];
    _status = map['status'];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class TodoDataBase {
  List todoList = [];

  final _my_box = Hive.box('lwp');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List dataList=[];

  Future<void> loadData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Todo').get();
      List data = querySnapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return data; // Replace 'yourField' with the actual field name you want to retrieve
      }).toList();
        dataList = data;
      todoList = _my_box.get("TODOLIST");
      print('todoList-->> ${todoList.toList()}');
      print('dataList-->> ${dataList.toList()}');
      if (listsAreEqual(dataList, todoList)) {
        print('The lists are equal.');
      } else {
        todoList=dataList;
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
  Future<void> updateDatabase() async {
    _my_box.put("TODOLIST", todoList);
  }
  bool listsAreEqual(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i]["title"] != list2[i]["title"]) {
        return false;
      }
    }

    return true;
  }

}



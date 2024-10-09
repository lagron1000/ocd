import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CategoriesScreen(),
    );
  }
}

///////////Models///////////

class TodoItem {
  final String id;      // Unique ID for each item
  final String name;
  final IconData? icon;

  TodoItem({
    required this.id,
    required this.name,
    this.icon,
  });
}

class Category {
  final String name;
  final List<TodoItem> items;

  Category({
    required this.name,
    required this.items,
  });
}

List<TodoItem> availableTodoItems = [
  // TodoItem(id: '1', name: 'Grab Keys', icon: "lib\icons\key.png"),
  // TodoItem(id: '2', name: 'Grab ID', icon: "lib\icons\id.png"),
];


List<Category> categories = [
  // Category(
  //   name: 'Everyday',
  //   items: [
  //    availableTodoItems[0],
  //    availableTodoItems[1]
  //   ],
  // ),
  
];

List<Map<String, dynamic>> globalTodoItems = [
  {"task": "Turn off A.C.", "icon": Icons.ac_unit},
  {"task": "Take passport", "icon": Icons.flight},
  {"task": "Pack laptop", "icon": Icons.computer},
];




///////////Methods///////////










///////////UI///////////


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: AppBar(
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class FloatingBox extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? trailingWidget; // Optional widget for trailing actions (like checkbox)

  const FloatingBox({super.key, 
    required this.title, 
    required this.onTap,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            trailing: trailingWidget, // Used for checkbox in to-do items
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

// class CategoriesScreen extends StatefulWidget {
//   const CategoriesScreen({super.key});

//   @override
//   _CategoriesScreenState createState() => _CategoriesScreenState();
// }

// class _CategoriesScreenState extends State<CategoriesScreen> {
//   List<String> categories = ["Everyday", "Before Work", "Before Vacation"];

//   void _addCategory() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String newCategory = '';
//         return AlertDialog(
//           title: Text('New Category'),
//           content: TextField(
//             onChanged: (value) {
//               newCategory = value;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (newCategory.isNotEmpty) {
//                   setState(() {
//                     categories.add(newCategory);
//                   });
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: 'My lists'),
//       body: ListView(
//         padding: EdgeInsets.only(top: 16.0),
//         children: categories.map((category) {
//           return FloatingBox(
//             title: category,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TodoListScreen(category: category),
//                 ),
//               );
//             },
//           );
//         }).toList(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addCategory,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Explicitly type the categories list
  List<Map<String, dynamic>> categories = [
    {"title": "Everyday", "items": <Map<String, dynamic>>[]}, // Ensure the items list is typed properly
    {"title": "Before Work", "items": <Map<String, dynamic>>[]},
    {"title": "Before Vacation", "items": <Map<String, dynamic>>[]},
  ];

void _addCategory() {
  String newCategoryTitle = '';
  List<Map<String, dynamic>> selectedItems = [];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Category Title'),
                    onChanged: (value) {
                      newCategoryTitle = value;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Select Tasks:'),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: globalTodoItems.length,
                      itemBuilder: (context, index) {
                        final item = globalTodoItems[index];
                        final isSelected = selectedItems.any((element) => element['id'] == item['id']); // Check by ID

                        return CheckboxListTile(
                          title: Text(item["task"]),
                          value: isSelected,
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true && !isSelected) {
                                selectedItems.add(item); // Add item if not already selected
                              } else if (selected == false && isSelected) {
                                selectedItems.removeWhere((element) => element['id'] == item['id']); // Remove item by ID
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog without saving
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (newCategoryTitle.isNotEmpty) {
                            setState(() {
                              categories.add({
                                "title": newCategoryTitle,
                                "items": selectedItems,
                              });
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Text('Add Category'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ToDo Categories'),
      body: ListView(
        padding: EdgeInsets.only(top: 16.0),
        children: categories.map((category) {
          return FloatingBox(
            title: category["title"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoListScreen(category: category),
                ),
              );
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: Icon(Icons.add),
      ),
    );
  }
}



// class TodoListScreen extends StatefulWidget {
//   final String category;

//   TodoListScreen({required this.category});

//   @override
//   _TodoListScreenState createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
//   List<Map<String, dynamic>> todoItems = [
//     {"task": "Turn off A.C.", "isChecked": false},
//     {"task": "Take passport", "isChecked": false},
//   ];

//   void _addTodoItem() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String newTask = '';
//         return AlertDialog(
//           title: Text('New Task'),
//           content: TextField(
//             onChanged: (value) {
//               newTask = value;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (newTask.isNotEmpty) {
//                   setState(() {
//                     todoItems.add({"task": newTask, "isChecked": false});
//                   });
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: widget.category),
//       body: ListView(
//         padding: EdgeInsets.only(top: 16.0),
//         children: todoItems.map((todo) {
//           return FloatingBox(
//             title: todo["task"],
//             trailingWidget: Checkbox(
//               value: todo["isChecked"],
//               onChanged: (value) {
//                 setState(() {
//                   todo["isChecked"] = value!;
//                 });
//               },
//             ),
//             onTap: () {}, // No action needed when tapping a todo item
//           );
//         }).toList(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addTodoItem,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }


class TodoListScreen extends StatefulWidget {
  final Map<String, dynamic> category;

  TodoListScreen({required this.category});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Map<String, dynamic>> todoItems = [];

  @override
  void initState() {
    super.initState();
    todoItems = widget.category["items"];
  }

  void _editList() {
  String newCategoryTitle = widget.category["title"];
  List<Map<String, dynamic>> selectedItems = List.from(todoItems); // Use List.from() to make a typed copy

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Category Title'),
                  onChanged: (value) {
                    newCategoryTitle = value;
                  },
                  controller: TextEditingController(text: widget.category["title"]),
                ),
                Text('Edit Tasks:'),
                Expanded(
                  child: ListView(
                    children: globalTodoItems.map((item) {
                      return CheckboxListTile(
                        title: Text(item["task"]),
                        value: selectedItems.contains(item),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedItems.add(item); // Correct type
                            } else {
                              selectedItems.remove(item); // Correct type
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.category["title"] = newCategoryTitle;
                    widget.category["items"] = selectedItems; // Correct type
                    todoItems = selectedItems; // Ensure correct type assignment
                  });
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.category["title"]),
      body: ListView(
        padding: EdgeInsets.only(top: 16.0),
        children: todoItems.map((todo) {
          return FloatingBox(
            title: todo["task"],
            trailingWidget: Checkbox(
              value: todo["isChecked"] ?? false,
              onChanged: (value) {
                setState(() {
                  todo["isChecked"] = value!;
                });
              },
            ),
            onTap: () {},
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editList,
        child: Icon(Icons.edit),
      ),
    );
  }
}

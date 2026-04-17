import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> records = [];

  final List<String> itUsers = [
    "IT User 01",
    "IT User 02",
    "IT User 03",
    "IT User 04",
  ];

  // Controllers
  final TextEditingController descController = TextEditingController();
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Colors.black87),
        title: Text(
          "Home - CRUD Table",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      // ---------------- Body ---------------- //
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: records.isEmpty
                    ? Center(
                  child: Text(
                    "No Records Yet",
                    style: TextStyle(fontSize: 16),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 30,
                        headingRowColor: MaterialStateProperty.all(
                            Colors.grey.shade200),
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("User")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: List.generate(records.length, (index) {
                          final r = records[index];
                          return DataRow(
                            cells: [
                              DataCell(Text(r["id"].toString())),
                              DataCell(Text(r["desc"])),
                              DataCell(Text(r["user"])),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        _openEditDialog(index),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteRecord(index),
                                  ),
                                ],
                              )),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------------- Add Button ---------------- //
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: _openAddDialog,
      ),
    );
  }

  // ---------------- Add Dialog ---------------- //
  void _openAddDialog() {
    descController.clear();
    selectedUser = null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Record"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Select User"),
              value: selectedUser,
              items: itUsers.map((u) {
                return DropdownMenuItem(
                  value: u,
                  child: Text(u),
                );
              }).toList(),
              onChanged: (value) {
                selectedUser = value.toString();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Add"),
            onPressed: () {
              if (descController.text.isNotEmpty && selectedUser != null) {
                setState(() {
                  records.add({
                    "id": records.length + 1,
                    "desc": descController.text,
                    "user": selectedUser,
                  });
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  // ---------------- Edit Dialog ---------------- //
  void _openEditDialog(int index) {
    descController.text = records[index]["desc"];
    selectedUser = records[index]["user"];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Record"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Select User"),
              value: selectedUser,
              items: itUsers.map((u) {
                return DropdownMenuItem(
                  value: u,
                  child: Text(u),
                );
              }).toList(),
              onChanged: (value) {
                selectedUser = value.toString();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Update"),
            onPressed: () {
              setState(() {
                records[index]["desc"] = descController.text;
                records[index]["user"] = selectedUser;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ---------------- Delete Record ---------------- //
  void _deleteRecord(int index) {
    setState(() {
      records.removeAt(index);
    });
  }
}
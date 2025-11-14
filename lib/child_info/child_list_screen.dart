import 'package:flutter/material.dart';
import '../auth/screens/add_baby_info_screen.dart';
import '../services/baby_info_service.dart';
import '../utils/app_color.dart';
import 'child_info_screen.dart';

class ChildListScreen extends StatefulWidget {
  const ChildListScreen({super.key});

  @override
  State<ChildListScreen> createState() => _ChildListScreenState();
}

class _ChildListScreenState extends State<ChildListScreen> {
  List<Map<String, String>> children = [];

  @override
  void initState() {
    super.initState();
    loadChildren();
  }

  Future<void> loadChildren() async {
    final list = await BabyService.getAllChildren();
    setState(() => children = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      appBar: AppBar(
        title: const Text("Children List"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: children.isEmpty
          ? const Center(
              child: Text(
                "No children added yet.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.accentColor,
                      child: const Icon(Icons.child_care, color: Colors.white),
                    ),
                    title: Text(
                      child["name"] ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text("Age: ${child["age"]}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChildProfileScreen(childData: child),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBabyInfoScreen(screenName:'list_screen')),
          ).then((_) => loadChildren());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

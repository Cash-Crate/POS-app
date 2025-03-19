import 'package:flutter/material.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.blue.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text(
              "Dashboard",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            leading: const Icon(Icons.dashboard, color: Colors.black54),
            onTap: () {},
          ),

          const SizedBox(height: 10),

          ExpansionTile(
            title: const Text(
              "Products",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            leading: const Icon(Icons.shopping_bag, color: Colors.black54),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(left: 20),
            children: [
              ListTile(
                title: const Text("Add New Item", softWrap: true),
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Add New Category", softWrap: true),
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Update Items", softWrap: true),
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 10),

          ExpansionTile(
            title: const Text(
              "Documentation",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            leading: const Icon(Icons.book, color: Colors.black54),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(left: 20),
            children: [
              ListTile(
                title: const Text("Get Started", softWrap: true),
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                onTap: () {},
              ),
              ListTile(
                title: const Text("How to Use Proficiently", softWrap: true),
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                onTap: () {},
              ),
              ListTile(
                title: const Text("FAQ", softWrap: true),
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                onTap: () {},
              ),
            ],
          ),

          const Spacer(),
          const Divider(),

          ListTile(
            title: const Text("Settings", overflow: TextOverflow.ellipsis),
            leading: const Icon(Icons.settings, color: Colors.black54),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

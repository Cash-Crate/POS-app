import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/login_service.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  bool _isCollapsed = false; // Default to expanded

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 900; // Only apply collapsibility on tablets
    String currentRoute = ModalRoute.of(context)?.settings.name ?? "";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isTablet ? (_isCollapsed ? 60 : 200) : 200, // Collapse only for tablets
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTablet) // Show the toggle button only on tablets
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(_isCollapsed ? Icons.menu : Icons.menu_open),
                color: Colors.black54,
                onPressed: _toggleSidebar,
              ),
            ),

          // Logo Section
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SvgPicture.asset(
                "assets/images/sample-logo.svg",
                width: _isCollapsed ? 40 : 60,
                height: _isCollapsed ? 40 : 60,
              ),
            ),
          ),

          _buildListTile(
            icon: Icons.dashboard,
            label: "Dashboard",
            route: "/",
            currentRoute: currentRoute,
          ),

          _buildListTile(
            icon: Icons.shopping_bag,
            label: "Products",
            route: "/products",
            currentRoute: currentRoute,
          ),

          const SizedBox(height: 10),

          _buildExpansionTile(
            icon: Icons.book,
            label: "Documentation",
            children: [
              _buildSubListTile("Get Started", () {}),
              _buildSubListTile("How to Use Proficiently", () {}),
              _buildSubListTile("FAQ", () {}),
            ],
          ),

          const Spacer(),
          const Divider(),

          _buildListTile(
            icon: Icons.logout, 
            label: "logout",
            route: "/logout",  
            currentRoute: currentRoute,
          ),

        ],
      ),
    );
  }

  Widget _buildListTile({
  required IconData icon,
  required String label,
  required String route,
  required String currentRoute,
}) {
  bool isCurrentScreen = currentRoute == route;

  return ListTile(
    title: _isCollapsed ? null : Text(label, overflow: TextOverflow.ellipsis),
    leading: Icon(icon, color: isCurrentScreen ? Colors.grey : Colors.black54),
    onTap: isCurrentScreen
        ? null
        : () async {
            if (label == "logout") {
              // Log out the user
              await LoginService.logout();

              // bring back to login screen once logged out
              Navigator.pushReplacementNamed(context, '/login');
            } else {
              // Navigate to the route for other items
              Navigator.pushReplacementNamed(context, route);
            }
          },
    enabled: !isCurrentScreen,
  );
}


  Widget _buildExpansionTile({
    required IconData icon,
    required String label,
    required List<Widget> children,
  }) {
    if (_isCollapsed) {
      return IconButton(
        icon: Icon(icon, color: Colors.black54),
        onPressed: () {},
      );
    }
    return ExpansionTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      leading: Icon(icon, color: Colors.black54),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(left: 20),
      children: children,
    );
  }

  Widget _buildSubListTile(String label, VoidCallback onTap) {
    return ListTile(
      title: Text(label, softWrap: true),
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/services/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../../auth/screens/login_screen.dart';

import 'package:carenow/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock State for Elderly Mode until we lift it to higher provider
  bool _isLargeText = false; 

  void _showChangePasswordDialog(BuildContext context) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: currentPassController, obscureText: true, decoration: const InputDecoration(labelText: "Current Password")),
            TextField(controller: newPassController, obscureText: true, decoration: const InputDecoration(labelText: "New Password")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                await Provider.of<AuthProvider>(context, listen: false)
                    .changePassword(currentPassController.text, newPassController.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password changed successfully")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showManageElderlyDialog(BuildContext context, User user) {
    final idController = TextEditingController();
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: const Text("Manage Linked Elderly"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (user.linkedElderlyIds.isEmpty)
                const Text("No elderly linked yet."),
              ...user.linkedElderlyIds.map((id) => ListTile(
                title: Text(id),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    List<String> newIds = List.from(user.linkedElderlyIds)..remove(id);
                    await Provider.of<AuthProvider>(context, listen: false).updateLinkedElderly(newIds);
                    Navigator.pop(ctx);
                  },
                ),
              )),
              const Divider(),
              TextField(
                controller: idController, 
                decoration: const InputDecoration(labelText: "Add Elderly ID (e.g. ELD-1234)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
          ElevatedButton(
             onPressed: () async {
                if (user.linkedElderlyIds.length >= 5) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Limit of 5 reached")));
                   return;
                }
                if (idController.text.isNotEmpty) {
                    List<String> newIds = List.from(user.linkedElderlyIds)..add(idController.text.trim());
                    await Provider.of<AuthProvider>(context, listen: false).updateLinkedElderly(newIds);
                    Navigator.pop(ctx);
                }
             },
             child: const Text("Add"),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // UNIQUE ID SECTION (For Elderly)
          if (user?.role == UserRole.elderly && user?.uniqueId != null)
            ListTile(
              tileColor: Colors.teal.shade50,
              leading: const Icon(Icons.badge, color: Colors.teal),
              title: const Text("My Unique ID", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user!.uniqueId!, style: const TextStyle(fontSize: 18, color: Colors.teal)),
            ),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(authProvider.currentLocale.languageCode == 'ml' ? 'Malayalam' : 'English'),
            onTap: () {
               showDialog(context: context, builder: (context) => SimpleDialog(
                 title: Text(l10n.selectLanguage),
                 children: [
                   SimpleDialogOption(child: const Text("English"), onPressed: () { authProvider.setLanguage(const Locale('en')); Navigator.pop(context); }),
                   SimpleDialogOption(child: const Text("Malayalam (മലയാളം)"), onPressed: () { authProvider.setLanguage(const Locale('ml')); Navigator.pop(context); }),
                 ],
               ));
            },
          ),
          
          // ELDERLY MODE TOGGLE (Only for Elderly Role)
          if (user?.role == UserRole.elderly)
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: Text(l10n.elderlyMode),
              subtitle: Text(l10n.elderlyModeDesc),
              trailing: Switch(
                value: authProvider.textScaleFactor > 1.0, 
                onChanged: (val) async {
                   await authProvider.toggleElderlyMode(val);
                }
              ),
            ),
          
          // CAREGIVER MANAGER
          if (user?.role == UserRole.caregiver)
            ListTile(
              leading: const Icon(Icons.family_restroom),
              title: Text(l10n.manageLinkedElderly),
              subtitle: Text("${user?.linkedElderlyIds.length ?? 0} / 5 linked"),
              onTap: () => _showManageElderlyDialog(context, user!),
            ),

          // CHANGE PASSWORD (IN-APP)
          ListTile(
            leading: const Icon(Icons.password),
            title: Text(l10n.changePassword),
            onTap: () => _showChangePasswordDialog(context),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            onTap: () async {
              await authProvider.logout();
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

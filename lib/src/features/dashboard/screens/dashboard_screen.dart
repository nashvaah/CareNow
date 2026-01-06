import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/services/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../../settings/screens/settings_screen.dart';
import 'package:carenow/l10n/app_localizations.dart';

class DashboardScreenWrapper extends StatelessWidget {
  const DashboardScreenWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    // Check role, return appropriate scaffold
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Not Authorized")));
    }

    switch (user.role) {
      case UserRole.elderly:
        return const ElderlyDashboard();
      case UserRole.caregiver:
        return const CaregiverDashboard();
      case UserRole.hospitalStaff:
        return const StaffDashboard();
      case UserRole.volunteer:
        return const VolunteerDashboard();
      default:
        return const Scaffold(body: Center(child: Text("Unknown Role")));
    }
  }
}

// --------------------- ELDERLY DASHBOARD ---------------------
class ElderlyDashboard extends StatelessWidget {
  const ElderlyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myCare),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _BigCard(icon: Icons.medication, label: l10n.medication, color: Colors.blueAccent),
          _BigCard(icon: Icons.calendar_month, label: l10n.appointments, color: Colors.green),
          _BigCard(icon: Icons.call, label: l10n.emergency, color: Colors.red),
          _BigCard(icon: Icons.person, label: l10n.profile, color: Colors.orange),
        ],
      ),
    );
  }
}

class _BigCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _BigCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: color.withOpacity(0.2))),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// --------------------- CAREGIVER DASHBOARD ---------------------
class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({super.key});

  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  List<User> _linkedElderly = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLinkedElderly();
  }

  Future<void> _loadLinkedElderly() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profiles = await authProvider.fetchLinkedElderlyProfiles();
    
    // MOCK DATA if profiles are empty for testing UI
    if (profiles.isEmpty) {
        // Wait, not mocking per user request, but if empty show empty state
    }

    if (mounted) {
      setState(() {
        _linkedElderly = profiles;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_linkedElderly.isEmpty) {
      return Scaffold(
        appBar: AppBar(
           title: Text(l10n.caregiverFamily),
           actions: [
             IconButton(
               icon: const Icon(Icons.settings),
               onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())), // Settings available, but font toggle should be hidden inside settings screen logic
             )
           ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.link_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(l10n.noElderlyLinked, style: const TextStyle(fontSize: 18)),
               const SizedBox(height: 16),
               ElevatedButton(
                 onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                 child: Text(l10n.manageLinkedElderly),
               )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.caregiverFamily),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _linkedElderly.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final patient = _linkedElderly[index];
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Name Above Box
              Text(
                patient.name,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Card Box
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                         children: [
                           const Icon(Icons.medical_services, color: Colors.blue),
                           const SizedBox(width: 8),
                           Text(l10n.condition, style: const TextStyle(fontWeight: FontWeight.bold)),
                         ],
                       ),
                       Text(patient.conditions.isNotEmpty ? patient.conditions : l10n.noConditions, style: const TextStyle(fontSize: 16)),
                       const Divider(height: 24),
                       Row(
                         children: [
                           const Icon(Icons.medication, color: Colors.red),
                           const SizedBox(width: 8),
                           Text(l10n.medicines, style: const TextStyle(fontWeight: FontWeight.bold)),
                         ],
                       ),
                       Text(patient.medicines.isNotEmpty ? patient.medicines : l10n.noMedicines, style: const TextStyle(fontSize: 16)),
                       const Divider(height: 24),
                       Row(
                         children: [
                           const Icon(Icons.access_time, color: Colors.orange), // Clock icon for timing
                           const SizedBox(width: 8),
                           Text(l10n.medicineTiming, style: const TextStyle(fontWeight: FontWeight.bold)),
                         ],
                       ),
                       Text(patient.medicineTiming.isNotEmpty ? patient.medicineTiming : l10n.noTiming, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_task),
      ),
    );
  }
}

// --------------------- STAFF DASHBOARD ---------------------
class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _allPatients = [
    {'name': 'Anjali', 'id': '6543'},
    {'name': 'Riya', 'id': '6544'},
    {'name': 'Harsha', 'id': '6545'},
    {'name': 'Nanditha', 'id': '6546'},
    {'name': 'Alfiya', 'id': '6547'},
  ];
  List<Map<String, String>> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = _allPatients;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _filteredPatients = _allPatients;
      });
    } else {
      setState(() {
        _filteredPatients = _allPatients.where((p) => p['id'] == query).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.staffPortal),
         actions: [
            IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchByUniqueId,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _filteredPatients.isEmpty
                ? Center(child: Text(l10n.profileNotFound, style: const TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      final p = _filteredPatients[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(child: Text(p['name']![0])),
                          title: Row(
                            children: [
                              Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Text(p['id']!, style: const TextStyle(fontSize: 12, color: Colors.blue)),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add patient
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --------------------- VOLUNTEER DASHBOARD ---------------------
class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.volunteerHub),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volunteer_activism, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 24),
            Text(
              l10n.welcomeVolunteer,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(l10n.thankYouVolunteer),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Future implementation
              },
              child: Text(l10n.viewAvailableTasks),
            ),
          ],
        ),
      ),
    );
  }
}

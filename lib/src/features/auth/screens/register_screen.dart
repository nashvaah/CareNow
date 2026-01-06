import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/auth_provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import 'package:carenow/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Extra fields controllers
  final _dobController = TextEditingController();
  final _elderlyIdController = TextEditingController();
  final _staffIdController = TextEditingController();
  
  // Relationship dropdown value
  String? _selectedRelationship;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  int? _calculatedAge;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
         _dobController.text = "${picked.day.toString().padLeft(2,'0')}/${picked.month.toString().padLeft(2,'0')}/${picked.year}";
         final now = DateTime.now();
         int age = now.year - picked.year;
         if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
           age--;
         }
         _calculatedAge = age;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Increased length to 4 for Volunteer
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _elderlyIdController.dispose();
    _staffIdController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      final roleIndex = _tabController.index;
      UserRole role;
      Map<String, dynamic> additionalData = {};

      switch (roleIndex) {
        case 0: 
          role = UserRole.elderly; 
          additionalData['dob'] = _dobController.text.trim();
          break;
        case 1: 
          role = UserRole.caregiver; 
          if (_elderlyIdController.text.isNotEmpty) additionalData['elderlyLinkOf'] = _elderlyIdController.text.trim();
          if (_selectedRelationship != null) additionalData['relationship'] = _selectedRelationship;
          break;
        case 2: 
          role = UserRole.hospitalStaff; 
          if (_staffIdController.text.isNotEmpty) additionalData['staffId'] = _staffIdController.text.trim();
          additionalData['isApproved'] = false; // Staff usually needs approval
          break;
        case 3:
          role = UserRole.volunteer;
          additionalData['isApproved'] = true; // Volunteers might need approval or auto-approve
          break;
        default: 
          role = UserRole.elderly;
      }
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.register(email, password, name, role, additionalData);

      if (mounted) {
         Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (_) => const DashboardScreenWrapper()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createAccount),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.elderly),
            Tab(text: l10n.caregiverFamily),
            Tab(text: l10n.staff),
            Tab(text: l10n.volunteer),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildElderlyForm(l10n),
            _buildCaregiverForm(l10n),
            _buildStaffForm(l10n),
            _buildVolunteerForm(l10n),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleRegister,
           child: _isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(l10n.completeRegistration),
        ),
      ),
    );
  }

  Widget _buildCommonFields(AppLocalizations l10n) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          // Label changed to 'Username' as requested, with mandatory *
          decoration: InputDecoration(
            labelText: "${l10n.username} *", 
            prefixIcon: const Icon(Icons.person)
          ),
          validator: (value) => value == null || value.isEmpty ? l10n.usernameError : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "${l10n.email} *", 
            prefixIcon: const Icon(Icons.email)
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter an email'; // Should be localized potentially
            if (!value.contains('@')) return 'Please enter a valid email';
            if (!value.endsWith('@gmail.com') && !value.endsWith('@yahoo.com')) {
              return 'Only @gmail.com or @yahoo.com allowed'; 
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "${l10n.password} *",
            prefixIcon: const Icon(Icons.lock),
            helperText: l10n.passwordHelper,
            helperMaxLines: 2,
            helperStyle: const TextStyle(color: Colors.grey, fontSize: 12), 
            suffixIcon: IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return l10n.incorrectPassword; // Reusing "incorrect password" as generic "enter password", better to add specific key but sticking to available
            if (value.length < 6) return 'Password must be at least 6 characters';
            if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) return 'Must contain at least one number';
            if (!RegExp(r'(?=.*?[#?!@$%^&*-])').hasMatch(value)) return 'Must contain at least one special character';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildElderlyForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(l10n.simplifiedRegistration, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          _buildCommonFields(l10n),
          const SizedBox(height: 12),
            TextFormField(
            controller: _dobController,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              labelText: "${l10n.dateOfBirth} *", 
              prefixIcon: const Icon(Icons.calendar_today),
              errorText: (_calculatedAge != null && _calculatedAge! < 50) ? l10n.ageEligibilityError : null,
            ),
            validator: (value) {
               if (value == null || value.isEmpty) return 'Date of Birth is mandatory';
               if (_calculatedAge != null && _calculatedAge! < 50) return l10n.ageEligibilityError;
               return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCaregiverForm(AppLocalizations l10n) {
      return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
           Text(l10n.linkToElderly, style: const TextStyle(color: Colors.grey)),
           const SizedBox(height: 20),
          _buildCommonFields(l10n),
          const SizedBox(height: 12),
          TextFormField(
            controller: _elderlyIdController,
            decoration: InputDecoration(labelText: "${l10n.elderlyLinkId} *", prefixIcon: const Icon(Icons.link)),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedRelationship,
            decoration: InputDecoration(
              labelText: "${l10n.relationship} *", 
              prefixIcon: const Icon(Icons.people),
            ),
            items: ['Caregiver', 'Son/Daughter', 'Other Family Member'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedRelationship = newValue;
              });
            },
            validator: (value) => value == null ? 'Please select a relationship' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStaffForm(AppLocalizations l10n) {
      return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(child: Text(l10n.adminApprovalRequired)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildCommonFields(l10n),
          const SizedBox(height: 12),
          TextFormField(
            controller: _staffIdController,
            decoration: InputDecoration(labelText: "${l10n.staffIdOnly} *", prefixIcon: const Icon(Icons.badge)),
            validator: (value) => value == null || value.isEmpty ? 'Staff ID is required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Join as a Volunteer to help the community", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          _buildCommonFields(l10n),
          // Add extra volunteer fields if needed
        ],
      ),
    );
  }
}

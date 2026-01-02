import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_info_provider.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({super.key});

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {

  @override
  void initState() {
    super.initState();
    // Fetch users when the form loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserInfoProvider>(context, listen: false).fetchUsers();
    });
  }

  void _submitForm() async {
    final provider = Provider.of<UserInfoProvider>(context, listen: false);
    if (provider.formKey.currentState!.validate()) {
      
      final success = await provider.submitUserData();
      
      if (success) {
        // Show success message
        _showSuccessDialog();
      } else {
        // Show error message
        _showErrorDialog(provider.errorMessage ?? 'Failed to save user data');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('User information saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<UserInfoProvider>(context, listen: false).clearForm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUsersDialog() {
    final provider = Provider.of<UserInfoProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('All Users'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            
            child: provider.users.isEmpty
                ? const Center(child: Text('No users found'))
                : ListView.builder(
                    itemCount: provider.users.length,
                    itemBuilder: (context, index) {
                      final user = provider.users[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(user.name),
                          subtitle: Text('${user.city}, Age: ${user.age}'),
                          trailing: Text(user.phone),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                provider.fetchUsers(); // Refresh data
              },
              child: const Text('Refresh'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info Form'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Consumer<UserInfoProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: provider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  // Show error message if any
                  if (provider.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  
                  TextFormField(
                    controller: provider.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    enabled: !provider.isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: provider.phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    enabled: !provider.isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length < 10) {
                        return 'Phone number must be at least 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: provider.cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    enabled: !provider.isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: provider.ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.cake),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !provider.isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age < 1 || age > 120) {
                        return 'Please enter a valid age (1-120)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: provider.isLoading ? null : _showUsersDialog,
                    icon: const Icon(Icons.people),
                    label: const Text('View All Users'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
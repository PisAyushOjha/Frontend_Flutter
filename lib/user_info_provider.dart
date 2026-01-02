import 'package:flutter/material.dart';
import 'user_model.dart';
import 'api_service.dart';

class UserInfoProvider extends ChangeNotifier {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  UserInfoProvider() {
    // Add listeners to trigger validation on every keystroke
    _nameController.addListener(_onTextChanged);
    _phoneController.addListener(_onTextChanged);
    _cityController.addListener(_onTextChanged);
    _ageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Clear error message when user starts typing
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
    
    // Trigger form validation to clear red borders
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  void _clearErrorOnInput() {
    // Only clear error if user has already tried to submit (error exists)
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get cityController => _cityController;
  TextEditingController get ageController => _ageController;
  GlobalKey<FormState> get formKey => _formKey;

  String get name => _nameController.text;
  String get phone => _phoneController.text;
  String get city => _cityController.text;
  String get age => _ageController.text;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _cityController.clear();
    _ageController.clear();
    _errorMessage = null;
    notifyListeners();
  }

  // Submit data to API
  Future<bool> submitUserData() async {
    if (name.isEmpty || phone.isEmpty || city.isEmpty || age.isEmpty) {
      setError('Please fill all fields');
      return false;
    }

    setLoading(true);
    setError(null);

    try {
      final user = UserModel(
        name: name,
        phone: phone,
        city: city,
        age: age,
      );

      final createdUser = await ApiService.createUser(user);
      
      if (createdUser != null) {
        // Add to local list
        _users.insert(0, createdUser);
        setLoading(false);
        return true;
      } else {
        setError('Failed to save user data. Please check your internet connection.');
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError('Network error: Please check your internet connection and try again.');
      setLoading(false);
      return false;
    }
  }

  // Fetch all users from API
  Future<void> fetchUsers() async {
    setLoading(true);
    setError(null);

    try {
      final fetchedUsers = await ApiService.getUsers();
      _users = fetchedUsers;
      setLoading(false);
    } catch (e) {
      setError('Failed to fetch users: ${e.toString()}');
      setLoading(false);
    }
  }

  Map<String, String> getUserInfo() {
    return {
      'name': name,
      'phone': phone,
      'city': city,
      'age': age,
    };
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    _nameController.removeListener(_onTextChanged);
    _phoneController.removeListener(_onTextChanged);
    _cityController.removeListener(_onTextChanged);
    _ageController.removeListener(_onTextChanged);
    
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
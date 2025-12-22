import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/services/api_caller.dart';
import '../controller/auth_controller.dart';
import '../widgets/photo_picker.dart';
import '../widgets/snack_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final TextEditingController _firstNameTE = TextEditingController();
  final TextEditingController _lastNameTE = TextEditingController();
  final TextEditingController _mobileTE = TextEditingController();
  final TextEditingController _passwordTE = TextEditingController();

  bool _updateInProgress = false;
  bool _isLoading  = true;
  String? _currentPhotoUrl;
  bool _showPassword = false;



  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiCaller.getRequest(
        url: Urls.getProfileUrl,
      );

      if (response.isSuccess && response.responseData != null && response.responseData['status'] == 'success') {
        if (response.responseData['data'] != null &&
            response.responseData['data'] is List &&
            response.responseData['data'].isNotEmpty) {

          final profileData = response.responseData['data'][0];

          _firstNameTE.text = profileData['firstName']?.toString() ?? '';
          _lastNameTE.text = profileData['lastName']?.toString() ?? '';
          _mobileTE.text = profileData['mobile']?.toString() ?? '';


          if (profileData.containsKey('photo') && profileData['photo'] != null) {
            final photoValue = profileData['photo'].toString();
            if (photoValue.isNotEmpty &&
                photoValue != 'null' &&
                photoValue != '""' &&
                (photoValue.startsWith('http://') || photoValue.startsWith('https://'))) {
              _currentPhotoUrl = photoValue;
              print('Valid photo URL found: $_currentPhotoUrl');
            } else {
              _currentPhotoUrl = null;
              print('Invalid or empty photo URL: $photoValue');
            }
          } else {
            _currentPhotoUrl = null;
            print('No photo field in response');
          }


          final passwordValue = profileData['password'];
          if (passwordValue != null) {
            _passwordTE.text = passwordValue.toString();
          } else if (AuthController.password != null) {
            _passwordTE.text = AuthController.password!;
          } else {
            _passwordTE.text = '';
          }


          try {
            await AuthController.saveUserProfileData(profileData);
          } catch (e) {
            print('Error saving to AuthController: $e');
          }
        } else {
          print('Profile data is empty or invalid');
          _currentPhotoUrl = null;
        }
      } else {
        print('API response not successful or null');
        _currentPhotoUrl = null;
      }
    } catch (e) {
      print('Error in _loadProfileData: $e');
      _currentPhotoUrl = null;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    if (_firstNameTE.text.isEmpty) {
      showSnackBarMessage(context, 'Please enter first name');
      return;
    }
    if (_mobileTE.text.isEmpty) {
      showSnackBarMessage(context, 'Please enter mobile number');
      return;
    }

    _updateInProgress = true;
    setState(() {});

    try {
      ApiResponse response;

      if (_selectedImage != null) {

        response = await ApiCaller.profileUpdateMultipart(
          url: Urls.updateProfileUrl,
          body: {
            'email': AuthController.email ?? '',
            'firstName': _firstNameTE.text.trim(),
            'lastName': _lastNameTE.text.trim(),
            'mobile': _mobileTE.text.trim(),
            'password': _passwordTE.text.isNotEmpty
                ? _passwordTE.text.trim()
                : '',
          },
          image: _selectedImage,
        );
      } else {

        response = await ApiCaller.postRequest(
          url: Urls.updateProfileUrl,
          body: {
            'email': AuthController.email ?? '',
            'firstName': _firstNameTE.text.trim(),
            'lastName': _lastNameTE.text.trim(),
            'mobile': _mobileTE.text.trim(),
            'password': _passwordTE.text.isNotEmpty
                ? _passwordTE.text.trim()
                : '',
          },
        );
      }

      _updateInProgress = false;
      setState(() {});

      print('Update Response: ${response.responseData}');

      if (response.isSuccess && response.responseData['status'] == 'success') {
        showSnackBarMessage(
          context,
          'Profile updated successfully!',
          isError: false,
        );


        if (_selectedImage != null) {
          await _loadProfileData();
        } else {
          await AuthController.saveUserProfileData({
            'firstName': _firstNameTE.text.trim(),
            'lastName': _lastNameTE.text.trim(),
            'email': AuthController.email ?? '',
            'mobile': _mobileTE.text.trim(),
            'photo': _currentPhotoUrl,
          });
        }

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pop(context, true);
          }
        });

      } else {
        showSnackBarMessage(
          context,
          response.responseData?['message'] ?? 'Update failed',
        );
      }
    } catch (e) {
      _updateInProgress = false;
      setState(() {});
      showSnackBarMessage(context, 'Error: $e');
    }
  }


  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _picImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null && mounted) {
      setState(() {
        _selectedImage = image;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
//--

    if (_isLoading) {
      return Scaffold(
        appBar: TMAppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    //--

    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    Text(
                      'Update Your Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 10),

                    photo_picker(
                      onTap: _picImage,
                      selectedPhoto: _selectedImage,
                      currentPhotoUrl: _currentPhotoUrl,
                    ),

                    const SizedBox(height: 10),

                    TextFormField(

                      initialValue: AuthController.email ?? '',
                      readOnly: true,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _firstNameTE,
                      decoration: InputDecoration(hintText: 'First Name'),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _lastNameTE,
                      decoration: InputDecoration(hintText: 'Last Name'),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _mobileTE,
                        decoration: InputDecoration(hintText: 'Mobile'),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _passwordTE,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    FilledButton(
                      onPressed: _updateInProgress ? null : _updateProfile,
                      child: _updateInProgress
                          ? Center(
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.arrow_circle_right_outlined),
                    ),

                    const SizedBox(height: 30),
                    Center(
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

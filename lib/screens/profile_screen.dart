import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/secvices/db_service.dart';
import 'package:todo_app/widgets/custom_textfield.dart';
import 'package:todo_app/widgets/logout_dialog.dart';
import 'package:todo_app/widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  bool isEdit = false;
  bool showLoader = false;

  @override
  void initState() {
    DBService dbService = DBService();
    Map<String, dynamic> user;
    dbService.getUser().then((value) {
      user = value;
      _nameController.text = user['name'];
      _emailController.text = user['email'];
      _phoneController.text = user['phoneNumber'];
      _cityController.text = user['city'];
      _pincodeController.text = user['pinCode'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown,
        leading: GestureDetector(
          child: const Icon(CupertinoIcons.arrow_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: const Text('Your Profile'),
        actions: [
          !isEdit
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isEdit = true;
                    });
                  },
                  icon: const Icon(Icons.edit))
              : const SizedBox(),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const LogoutDialog(),
            ),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CustomTextfield(label: 'Name', controller: _nameController, isEnabled: isEdit,),
                const SizedBox(height: 20),
                CustomTextfield(label: 'Email', controller: _emailController, isEnabled: isEdit,),
                const SizedBox(height: 20),
                CustomTextfield(label: 'Phone Number', controller: _phoneController, isEnabled: isEdit,),
                const SizedBox(height: 20),
                CustomTextfield(label: 'City', controller: _cityController, isEnabled: isEdit,),
                const SizedBox(height: 20),
                CustomTextfield(label: 'PinCode', controller: _pincodeController, isEnabled: isEdit,),
                const SizedBox(height: 30),
                isEdit
                    ? PrimaryButton(
                        onTap: () async {
                          setState(() {
                            showLoader = true;
                          });
                          try {
                            DBService dbService = DBService();
                            await dbService.updateUserProfile(
                              name: _nameController.text,
                              email: _emailController.text,
                              phoneNumber: _phoneController.text,
                              city: _cityController.text,
                              pinCode: _pincodeController.text,
                            );
                            setState(() {
                              showLoader = false;
                              isEdit = false;
                            });
                            const snackBar = SnackBar(
                                content:
                                    Text('Your profile updated successfully'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } catch (e) {
                            final snackBar =
                                SnackBar(content: Text(e.toString()));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            setState(() {
                              showLoader = false;
                            });
                          }
                        },
                        showLoader: showLoader,
                        label: 'Save',
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

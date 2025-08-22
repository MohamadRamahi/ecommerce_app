import 'package:ecommerce/cubit/profile_details_cubit.dart';
import 'package:ecommerce/cubit/profile_detalis_state.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';

class DetailsAccountScreen extends StatefulWidget {
  const DetailsAccountScreen({super.key});

  @override
  State<DetailsAccountScreen> createState() => _DetailsAccountScreenState();
}

class _DetailsAccountScreenState extends State<DetailsAccountScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileDetailsCubit()..fetchUserDetails(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsiveHeight(context, 16),
              horizontal: responsiveWidth(context, 24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: responsiveHeight(context, 24)),
                Expanded(
                  child: BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
                    listener: (context, state) {
                      if (state is ProfileDetailsError) {
                        _showSnackBar(context, state.message, Colors.red);
                      } else if (state is ProfileDetailsLoaded) {
                        final user = state.userData;
                        nameController.text = user['name'] ?? '';
                        emailController.text = user['email'] ?? '';
                        phoneController.text = user['phone'] ?? '';
                        dobController.text = user['dateOfBirth'] ?? '';
                        genderController.text = user['gender'] ?? '';
                      }
                    },
                    builder: (context, state) {
                      if (state is ProfileDetailsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _buildForm(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const BackButton(),
        Text(
          "Details",
          style: TextStyle(
            fontSize: responsiveWidth(context, 24),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        NotificationIcon(),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return ListView(
      children: [
        CustomTextField(label: 'Name', controller: nameController),
        CustomTextField(
          label: 'Email',
          controller: emailController,
          readOnly: true,
        ),
        CustomTextField(
          label: 'Date of Birth',
          controller: dobController,
          fieldType: FieldType.date,
        ),
        CustomTextField(
          label: 'Gender',
          controller: genderController,
          fieldType: FieldType.gender,
          genderOptions: ['Male', 'Female', 'Other'],
        ),
        CustomTextField(
          label: 'Phone',
          controller: phoneController,
          fieldType: FieldType.phone,
        ),
        SizedBox(height: responsiveHeight(context, 40)),
        SizedBox(
          height: responsiveHeight(context, 54),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff1A1A1A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
            onPressed: () {
              context.read<ProfileDetailsCubit>().updateUserDetails(
                name: nameController.text.trim(),
                phone: phoneController.text.trim(),
                dateOfBirth: dobController.text.trim(),
                gender: genderController.text.trim(),
              );
              _showSnackBar(context,
                  'Profile updated successfully',
                  Colors.green
              );
            },
            child: const Text('Submit',
            style: TextStyle(
                color: Colors.white,
            ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}

enum FieldType { text, phone, date, gender }

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FieldType fieldType;
  final String? errorText;
  final List<String>? genderOptions;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.fieldType = FieldType.text,
    this.errorText,
    this.genderOptions,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (fieldType) {
      case FieldType.phone:
        return _buildPhoneField();
      case FieldType.date:
        return _buildDateField(context);
      case FieldType.gender:
        return _buildGenderDropdown();
      default:
        return _buildTextField();
    }
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IntlPhoneField(
        controller: controller,
        initialCountryCode: 'JO',
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        disableLengthCheck: true,
        onChanged: (phone) => controller.text = phone.completeNumber,
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            controller.text = "${date.year}-${date.month}-${date.day}";
          }
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    final options = genderOptions ?? ['Male', 'Female'];
    final value = options.contains(controller.text) ? controller.text : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        items: options.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (v) => controller.text = v ?? '',
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

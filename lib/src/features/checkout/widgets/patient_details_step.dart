import 'package:flutter/material.dart';
import 'package:myapp/src/features/checkout/widgets/section_title.dart';
import 'package:myapp/src/features/checkout/widgets/custom_text_field.dart';
import 'package:myapp/src/features/checkout/widgets/gender_selection.dart';
import 'package:myapp/src/features/checkout/widgets/custom_slider.dart';
import 'package:myapp/src/features/checkout/widgets/date_field.dart';

class PatientDetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController complaintController;
  final TextEditingController commentsController;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final TextEditingController ageController;
  final TextEditingController bloodTypeController;
  final TextEditingController allergiesController;
  final String selectedGender;
  final DateTime birthDate;
  final Function(String) onGenderChanged;
  final Function(DateTime) onBirthDateChanged;

  const PatientDetailsStep({
    Key? key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.complaintController,
    required this.commentsController,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.ageController,
    required this.bloodTypeController,
    required this.allergiesController,
    required this.selectedGender,
    required this.birthDate,
    required this.onGenderChanged,
    required this.onBirthDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Personal Information'),
            CustomTextField(
              controller: firstNameController,
              label: 'First Name',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: lastNameController,
              label: 'Last Name',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              label: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: phoneController,
              label: 'Phone Number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Address'),
            CustomTextField(
              controller: streetController,
              label: 'Street',
              prefixIcon: Icons.home_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: cityController,
              label: 'City',
              prefixIcon: Icons.location_city_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: stateController,
              label: 'State',
              prefixIcon: Icons.map_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: postalCodeController,
              label: 'Postal Code',
              prefixIcon: Icons.local_post_office_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Medical Information'),
            CustomTextField(
              controller: ageController,
              label: 'Age',
              prefixIcon: Icons.cake_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            GenderSelection(
              selectedGender: selectedGender,
              onChanged: onGenderChanged,
            ),
            const SizedBox(height: 16),
            DateField(
              label: 'Date of Birth',
              value: birthDate,
              onChanged: onBirthDateChanged,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: bloodTypeController,
              label: 'Blood Type',
              prefixIcon: Icons.bloodtype_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: allergiesController,
              label: 'Allergies',
              prefixIcon: Icons.warning_amber_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Appointment Details'),
            CustomTextField(
              controller: complaintController,
              label: 'Main Complaint',
              maxLines: 3,
              hintText: 'Please enter your main complaint here...',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: commentsController,
              label: 'Additional Comments',
              maxLines: 3,
              hintText: 'Any additional information you want to share...',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}


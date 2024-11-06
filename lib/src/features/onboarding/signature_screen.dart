import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/buttons.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/features/main/main_screen.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {}); // Trigger rebuild to update button state
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      items: [
        const Text(
          'Signature',
          style: TextStyle(fontSize: 25),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please sign below to complete your registration.',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 2),
            ),
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: RoundButton(
            label: "Register",
            onPressed: _controller.isNotEmpty
                ? () {
                    // final signaturePng = _controller.toPngBytes();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  }
                : null,
            color: const Color(0xFF4B5BA6),
          ),
        ),
        const SizedBox(height: 10),
        Center(
            child: RoundButton(
                label: 'Clear',
                onPressed: () {
                  _controller.clear();
                  _firstNameController.clear();
                  _lastNameController.clear();
                },
                color: const Color(0xFF4B5BA6))),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;

  const LoginTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: const Color(0xFF050404),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.6),
        ),
        labelStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.7),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
      ),
    );
  }
}

class SignupContactText extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String prefixText;
  final double prefixTextSize;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const SignupContactText({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixText = "(+63) ",
    this.prefixTextSize = 16,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: const Color(0xFF050404),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        hintStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.6),
        ),
        labelStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.7),
        ),
        prefixStyle: TextStyle(
          color: const Color(0xFF050404),
          fontSize: prefixTextSize,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
      ),
      validator: validator,
    );
  }
}

class SignupTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const SignupTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  _SignupTextFieldState createState() => _SignupTextFieldState();
}

class _SignupTextFieldState extends State<SignupTextField> {
  late bool _obscureText;
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      cursorColor: const Color(0xFF050404),
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.6),
        ),
        labelStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.7),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  // _obscureText ? Icons.visibility_outlined : Icons.visibility,
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _obscureText
                      ? const Color(0xFF050404).withOpacity(0.8)
                      : const Color(0xFF050404).withOpacity(0.8),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}

class EditTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const EditTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  _EditTextFieldState createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      cursorColor: const Color(0xFF050404),
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.6),
        ),
        labelStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.7),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF050404),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}

class ChatTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLines;

  const ChatTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.maxLines,
  }) : super(key: key);

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: const Color(0xFF050404),
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.6),
        ),
        labelStyle: TextStyle(
          color: const Color(0xFF050404).withOpacity(0.7),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF050404)),
        ),
      ),
    );
  }
}

class BodyMediumOver extends StatelessWidget {
  final String text;

  const BodyMediumOver({required this.text});

  @override
  Widget build(BuildContext context) {
    final List<String> parts = text.split(':');
    final String prefix = parts.length > 1 ? '${parts[0]}:' : '';
    final String restOfText =
        parts.length > 1 ? parts.sublist(1).join(':') : text;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF050404).withOpacity(0.9),
                ),
          ),
          TextSpan(
            text: restOfText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF050404).withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }
}

class BodyMediumText extends StatelessWidget {
  final String text;

  const BodyMediumText({required this.text});

  @override
  Widget build(BuildContext context) {
    final List<String> parts = text.split(':');
    final String prefix = parts.length > 1 ? '${parts[0]}:' : '';
    final String restOfText =
        parts.length > 1 ? parts.sublist(1).join(':') : text;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF050404).withOpacity(0.9),
                ),
          ),
          TextSpan(
            text: restOfText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF050404).withOpacity(0.9),
                ),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

class BodyMedium extends StatelessWidget {
  final String text;

  const BodyMedium({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF050404).withOpacity(0.9),
          ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

class TitleMediumText extends StatelessWidget {
  final String text;

  const TitleMediumText({required this.text});

  @override
  Widget build(BuildContext context) {
    final List<String> parts = text.split(':');
    final String prefix = parts.length > 1 ? '${parts[0]}:' : '';
    final String restOfText =
        parts.length > 1 ? parts.sublist(1).join(':') : text;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF050404).withOpacity(0.9),
                ),
          ),
          TextSpan(
            text: restOfText,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF050404).withOpacity(0.9),
                ),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

class TitleMediumOver extends StatelessWidget {
  final String text;

  const TitleMediumOver({required this.text});

  @override
  Widget build(BuildContext context) {
    final List<String> parts = text.split(':');
    final String prefix = parts.length > 1 ? '${parts[0]}:' : '';
    final String restOfText =
        parts.length > 1 ? parts.sublist(1).join(':') : text;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF050404).withOpacity(0.9),
                ),
          ),
          TextSpan(
            text: restOfText,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF050404).withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }
}

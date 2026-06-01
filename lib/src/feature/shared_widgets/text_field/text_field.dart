import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class const CustomTextField({
  required final String labelText,
  final TextEditingController? controller,
  final bool enabled = true,
  final String? errorText,
  final FocusNode? focusNode,
  final List<TextInputFormatter>? inputFormatters,
  final TextInputType? keyboardType,
  final int? maxLength,
  final int? maxLines = 1,
  final bool obscureText = false,
  final bool readOnly = false,
  final EdgeInsets? scrollPadding,
  final Widget? suffixIcon,
  final TextInputAction? textInputAction,
  super.key,
}) extends StatefulWidget {
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState() extends State<CustomTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _obscureText = false;

  void _onChange() => setState(() {});

  Color get _statusColor {
    if (widget.errorText != null) {
      return context.colors.error;
    }

    if (_focusNode.hasFocus) {
      return context.colors.success;
    }

    return Colors.transparent;
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onChange);
    _controller.addListener(_onChange);
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.removeListener(_onChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: context.colors.inputBgPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: _statusColor),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 12, bottom: (!_focusNode.hasFocus && _controller.text.isEmpty) ? 10 : 0),
            child: TextField(
              controller: _controller,
              cursorColor: _statusColor,
              enabled: widget.enabled,
              focusNode: _focusNode,
              inputFormatters: widget.inputFormatters,
              keyboardType: widget.keyboardType,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              obscureText: _obscureText,
              readOnly: widget.readOnly,
              // fontSize = 18
              scrollPadding:
                  widget.scrollPadding ??
                  EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    MediaQuery.viewInsetsOf(context).bottom + ((widget.maxLines ?? 1) + 1) * 18,
                  ),
              style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimary),
              textInputAction: widget.textInputAction,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  (!_focusNode.hasFocus && _controller.text.isEmpty) ? 0 : 10,
                ),
                counterText: '',
                label: Text(
                  widget.labelText,
                  style: context.textStyles.bodyRegular.copyWith(color: context.colors.textTertiary),
                  maxLines: 2,
                ),
                suffixIcon: widget.suffixIcon != null
                    ? Padding(
                        padding: EdgeInsets.only(
                          right: 16,
                          bottom: (!_focusNode.hasFocus && _controller.text.isEmpty) ? 0 : 10,
                        ),
                        child: widget.suffixIcon,
                      )
                    : widget.obscureText
                    ? Padding(
                        padding: EdgeInsets.only(
                          right: 16,
                          bottom: (!_focusNode.hasFocus && _controller.text.isEmpty) ? 0 : 10,
                        ),
                        child: IconButton(
                          onPressed: () => setState(() => _obscureText = !_obscureText),
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, size: 20),
                        ),
                      )
                    : null,
                suffixIconConstraints: BoxConstraints(
                  maxHeight: (!_focusNode.hasFocus && _controller.text.isEmpty) ? 24 : 34,
                  maxWidth: 40,
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.errorText!,
              style: context.textStyles.footnoteRegular.copyWith(color: context.colors.error),
            ),
          ),
        ],
      ],
    );
  }
}

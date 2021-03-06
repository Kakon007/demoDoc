import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/main_app/util/validator.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFieldRounded extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String errorText;
  final TextInputType keyboardType;
  final int maxLines;
  final int minLines;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry margin;
  final FocusNode focusNode;
  final bool autofocus;
  final bool enabled;
  final bool autovalidate;
  final bool readOnly;
  final bool isRequired;
  final TextInputAction textInputAction;
  final ValueChanged<String> onFieldSubmitted;
  final Widget prefix;
  final Function onChanged;
  final int maxLength;
  final GestureTapCallback onTap;
  final Key textFieldKey;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final double borderRadius;
  final bool obSecure;
  final double topPadding;

  const CustomTextFieldRounded({
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.validator,
    this.prefix,
    this.errorText,
    this.onChanged,
    this.textInputAction,
    this.autovalidate = false,
    this.controller,
    this.onFieldSubmitted,
    this.focusNode,
    this.isRequired = false,
    this.autofocus = false,
    this.labelText,
    this.hintText,
    this.minLines,
    this.prefixIcon,
    this.obSecure = false,
    this.suffixIcon,
    this.borderRadius = 10,
    this.onTap,
    this.margin = const EdgeInsets.all(5),
    this.keyboardType,
    this.contentPadding =
    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.maxLines = 1,
    this.textFieldKey,
    this.topPadding=25,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Container(
      margin: margin,
      child: Column(
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Flexible(
                    child: Text("  ${labelText ?? ""}",
                        style: GoogleFonts.roboto(fontSize: 12)),
                  ),
                  if (isRequired)
                    Text(
                      " *",
                      style: GoogleFonts.roboto(color: HexColor("#FF5B71")),
                    )
                ],
              ),
            ),
          SizedBox(
            height: 1,
          ),
          TextFormField(
            obscureText: obSecure,
            key: textFieldKey,
            onTap: onTap,
            readOnly: readOnly,
            enabled: enabled,
            maxLength: maxLength,
            minLines: minLines,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            autofocus: autofocus,
            focusNode: focusNode,
            maxLines: maxLines,
            autovalidate: autovalidate,
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            textInputAction: textInputAction,
            decoration: new InputDecoration(
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefix: prefix,
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 15, color: HexColor("#D2D2D2")),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#EAEBED"), width: 1.0),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              contentPadding: EdgeInsets.fromLTRB(15.0, topPadding, 40.0, 0.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#EAEBED"), width: 1.0),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#EAEBED"), width: 1.0),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              hintText: hintText,
            ),
          ),
          errorText == null
              ? SizedBox(height: 3,)
              : Padding(
            padding: const EdgeInsets.only(left: 38, top: 0, right: 38),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}

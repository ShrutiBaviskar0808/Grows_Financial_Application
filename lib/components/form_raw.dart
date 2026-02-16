import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_select_clone/flutter_awesome_select.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/utils/canadian_postal_code_formatter.dart';
import 'package:growsfinancial/utils/constant.dart';

class FormBasicInfoRaw extends StatelessWidget {
  final String title, firstNameError, middleNameError, lastNameError, dobError;
  final TextEditingController firstNameController,
      middleNameController,
      lastNameController,
      dobController;
  final FocusNode firstNameNode, middleNameNode, lastNameNode, dobNode;
  final GestureTapCallback onTap;
  final ValueChanged firstNameOnChanged, middleNameOnChanged, lastNameOnChanged;

  const FormBasicInfoRaw({
    super.key,
    required this.title,
    required this.firstNameController,
    required this.middleNameController,
    required this.lastNameController,
    required this.dobController,
    required this.onTap,
    required this.firstNameError,
    required this.middleNameError,
    required this.lastNameError,
    required this.dobError,
    required this.firstNameNode,
    required this.middleNameNode,
    required this.lastNameNode,
    required this.dobNode,
    required this.firstNameOnChanged,
    required this.middleNameOnChanged,
    required this.lastNameOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleTextStyle.copyWith(fontSize: 14)),
        CustomTextField(
          focusedBorderColor: primaryColor,
          borderColor: grey2,
          hintText: "First Name",
          textController: firstNameController,
          hintColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          errorText: firstNameError,
          errorColor: firstNameError.isNotEmpty ? Colors.red : Colors.white,
          focusNode: firstNameNode,
          onChanged: firstNameOnChanged,
        ),
        CustomTextField(
          focusedBorderColor: primaryColor,
          borderColor: grey2,
          hintText: "Middle Name",
          textController: middleNameController,
          hintColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          errorText: middleNameError,
          errorColor: middleNameError.isNotEmpty ? Colors.red : Colors.white,
          focusNode: middleNameNode,
          onChanged: middleNameOnChanged,
        ),
        CustomTextField(
          focusedBorderColor: primaryColor,
          borderColor: grey2,
          hintText: "Last Name",
          textController: lastNameController,
          hintColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          errorText: lastNameError,
          errorColor: lastNameError.isNotEmpty ? Colors.red : Colors.white,
          focusNode: lastNameNode,
          onChanged: lastNameOnChanged,
        ),
        Text(
          "If any of the name fields is blank, please write 'NA' in that box.",
          style: subTitleTextStyle.copyWith(fontSize: 12),
        ),
        CustomTextField(
          focusedBorderColor: primaryColor,
          borderColor: grey2,
          hintText: "Date Of Birth (Required)",
          textController: dobController,
          hintColor: primaryColor,
          onTap: onTap,
          readOnly: true,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          errorText: dobError,
          errorColor: dobError.isNotEmpty ? Colors.red : Colors.white,
          focusNode: dobNode,
        ),
      ],
    );
  }
}

class FormAddressRaw extends StatelessWidget {
  final TextEditingController address1Controller,
      address2Controller,
      cityController,
      postalCodeController;
  final FocusNode address1Node,
      address2Node,
      cityNode,
      stateNode,
      postalCodeNode;
  final String address1Error,
      address2Error,
      cityError,
      stateError,
      postalCodeError;
  final List<S2Choice<String>> list;
  final String selectedValue, title;
  final ValueChanged<S2SingleSelected<String>>? onChanged;

  const FormAddressRaw({
    super.key,
    required this.address1Controller,
    required this.address2Controller,
    required this.cityController,
    required this.postalCodeController,
    required this.list,
    this.selectedValue = "",
    required this.onChanged,
    this.title = "",
    required this.address1Node,
    required this.address2Node,
    required this.cityNode,
    required this.postalCodeNode,
    required this.stateNode,
    required this.address1Error,
    required this.address2Error,
    required this.cityError,
    required this.stateError,
    required this.postalCodeError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleTextStyle.copyWith(fontSize: 14)),
        CustomTextField(
          focusedBorderColor: primaryColor,
          borderColor: grey2,
          hintText: "Suite/Apt/Unit No.",
          textController: address1Controller,
          hintColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          focusNode: address1Node,
          errorText: address1Error,
        ),
        CustomTextField(
          focusedBorderColor: primaryColor,
          borderColor: grey2,
          hintText: "Street Number & Street Name",
          textController: address2Controller,
          hintColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          focusNode: address2Node,
          errorText: address2Error,
        ),
        CustomTextField(
          focusedBorderColor: primaryColor,
          borderColor: grey2,
          hintText: "City",
          textController: cityController,
          hintColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          focusNode: cityNode,
          errorText: cityError,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryColor, width: 2),
            color: Colors.white,
          ),
          padding: EdgeInsets.zero,
          child: SmartSelect<String>.single(
            title: 'SELECT',
            selectedValue: selectedValue,
            choiceItems: list,
            choiceLayout: S2ChoiceLayout.list,
            modalType: S2ModalType.bottomSheet,
            modalFilter: true,
            modalFilterAuto: true,
            modalConfirm: true,
            onChange: onChanged,
            choiceActiveStyle: S2ChoiceStyle(
              color: primaryColor,
            ),
            tileBuilder: (context, state) {
              return Focus(
                focusNode: stateNode,
                child: S2Tile.fromState(
                  state,
                  title: Text(
                    state.selected.title ?? 'SELECT',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(color: textColor, fontSize: 12),
                  ),
                  value: const Text(""),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        Visibility(
          visible: stateError.isNotEmpty,
          child: Text(stateError, style: const TextStyle(color: Colors.red)),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          focusedBorderColor: primaryColor,
          borderColor: grey2,
          hintText: "Postal Code (e.g., M8V 1E2)",
          textController: postalCodeController,
          hintColor: primaryColor,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            LengthLimitingTextInputFormatter(7),
            CanadianPostalCodeFormatter(),
          ],
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          focusNode: postalCodeNode,
          errorText: postalCodeError,
        ),
        Text(
          "If there is no Unit/Suite/Apartment number, please write 'NA' in the box.",
          style: subTitleTextStyle.copyWith(fontSize: 12),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}

class FormDropDown<T> extends StatelessWidget {
  const FormDropDown({
    super.key,
    required this.question,
    required this.choices,
    required this.selectedValue,
    required this.onChanged,
    this.questionStyle = titleTextStyle,
    required this.padding,
    this.errorText = '',
    required this.focusNode,
  });

  final String question;
  final List<S2Choice<T>> choices;
  final T selectedValue; // <- T? not dynamic
  final ValueChanged<S2SingleSelected<T>>? onChanged; // <- typed
  final TextStyle questionStyle;
  final EdgeInsetsGeometry padding;
  final String errorText;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: questionStyle.copyWith(
              color: errorText.isNotEmpty ? Colors.red : Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: grey2, width: 2),
              color: Colors.white,
            ),
            padding: EdgeInsets.zero,
            child: SmartSelect<T>.single(
              title: 'SELECT',
              selectedValue: selectedValue,
              // <- now correct type
              choiceItems: choices,
              choiceLayout: S2ChoiceLayout.list,
              modalType: S2ModalType.bottomSheet,
              modalFilter: true,
              modalFilterAuto: true,
              modalConfirm: true,
              choiceActiveStyle: S2ChoiceStyle(
                color: primaryColor,
              ),
              onChange: onChanged,
              tileBuilder: (context, state) {
                return Focus(
                  focusNode: focusNode,
                  child: S2Tile.fromState(
                    state,
                    title: Text(
                      state.selected.title ?? 'SELECT',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(color: textColor, fontSize: 12),
                    ),
                    value: const Text(""),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          Visibility(
            visible: errorText.isNotEmpty,
            child: Text(errorText, style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class FormMultiDropDown<T> extends StatelessWidget {
  const FormMultiDropDown({
    super.key,
    required this.question,
    required this.choices,
    required this.selectedValue,
    required this.onChanged,
    this.questionStyle,
    required this.padding,
    this.errorText = '',
    required this.focusNode,
  });

  final String question;
  final List<S2Choice<T>> choices;
  final List<T> selectedValue; // <- T? not dynamic
  final ValueChanged<S2MultiSelected<T>>? onChanged; // <- typed
  final TextStyle? questionStyle;
  final EdgeInsetsGeometry padding;
  final String errorText;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: questionStyle),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: grey2, width: 2),
              color: Colors.white,
            ),
            padding: EdgeInsets.zero,
            child: SmartSelect<T>.multiple(
              title: 'SELECT',
              selectedValue: selectedValue,
              // <- now correct type
              choiceItems: choices,
              choiceLayout: S2ChoiceLayout.list,
              modalType: S2ModalType.bottomSheet,
              modalFilter: true,
              modalFilterAuto: true,
              modalConfirm: true,
              onChange: onChanged,
              choiceActiveStyle: S2ChoiceStyle(
                color: primaryColor,
              ),
              tileBuilder: (context, state) {
                return Focus(
                  focusNode: focusNode,
                  child: S2Tile.fromState(
                    state,
                    title: Text(
                      state.selected.isEmpty
                          ? 'SELECT'
                          : state.selected.value.join(","),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(color: textColor, fontSize: 12),
                    ),
                    value: const Text(""),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          Visibility(
            visible: errorText.isNotEmpty,
            child: Text(errorText, style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

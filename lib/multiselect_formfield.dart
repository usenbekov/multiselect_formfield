library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function change;
  final Function open;
  final Function close;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color fillColor;
  final InputBorder border;
  final Widget icon;
  final Color textColor;
  final Color itemBgColor;
  final Color itemTextColor;

  MultiSelectFormField({
    FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
    dynamic initialValue,
    bool autovalidate = false,
    this.titleText = 'Title',
    this.hintText = 'Tap to select one or more',
    this.required = false,
    this.errorText = 'Please select one or more options',
    this.prefixIcon,
    this.dataSource,
    this.textField,
    this.valueField,
    this.change,
    this.open,
    this.close,
    this.okButtonLabel = 'OK',
    this.cancelButtonLabel = 'CANCEL',
    this.fillColor,
    this.border,
    this.suffixIcon = const Icon(Icons.unfold_more),
    this.icon,
    this.textColor,
    this.itemTextColor,
    this.itemBgColor,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autovalidate,
          builder: (FormFieldState<dynamic> state) {
            List<Widget> _buildSelectedOptions(state) {
              List<Widget> selectedOptions = [];

              if (state.value != null) {
                state.value.forEach((item) {
                  var existingItem =
                      dataSource.singleWhere((itm) => itm[valueField] == item, orElse: () => null);
                  selectedOptions.add(
                    Chip(
                      backgroundColor: itemBgColor,
                      labelStyle: itemTextColor == null ? null : TextStyle(color: itemTextColor),
                      label: Text(
                        existingItem[textField],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                });
              }

              return selectedOptions;
            }

            return InkWell(
              onTap: () async {
                List initialSelected = state.value;
                if (initialSelected == null) {
                  initialSelected = List();
                }

                final items = List<MultiSelectDialogItem<dynamic>>();
                dataSource.forEach((item) {
                  items.add(MultiSelectDialogItem(item[valueField], item[textField]));
                });

                List selectedValues = await showDialog<List>(
                  context: state.context,
                  builder: (BuildContext context) {
                    return MultiSelectDialog(
                      title: titleText,
                      okButtonLabel: okButtonLabel,
                      cancelButtonLabel: cancelButtonLabel,
                      items: items,
                      initialSelectedValues: initialSelected,
                    );
                  },
                );

                if (selectedValues != null) {
                  state.didChange(selectedValues);
                  state.save();
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: false,
                  errorText: state.hasError ? state.errorText : null,
                  errorMaxLines: 4,
                  fillColor: fillColor ?? Theme.of(state.context).canvasColor,
                  border: border ?? UnderlineInputBorder(),
                  icon: icon,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                ),
                isEmpty: state.value == null || state.value == '',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            titleText,
                            style: TextStyle(
                                fontSize: 13.0,
                                color: (textColor ?? Colors.black).withOpacity(0.5)),
                          )),
                          required
                              ? Padding(
                                  padding: EdgeInsets.only(top: 5, right: 5),
                                  child: Text(
                                    ' *',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    state.value != null && state.value.length > 0
                        ? Wrap(
                            spacing: 8.0,
                            runSpacing: 0.0,
                            children: _buildSelectedOptions(state),
                          )
                        : new Container(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              hintText,
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          )
                  ],
                ),
              ),
            );
          },
        );
}

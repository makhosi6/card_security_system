import 'package:flutter/material.dart';

/// Box that can be tapped.
/// When selected a check Icon appears
class SelectableContainer extends StatelessWidget {
  /// Background color for the space between the child and the
  /// Defaul value: scaffoldBackgroundColor
  final Color? marginColor;

  /// Background color when container is selected.
  /// Default value : dialogBackgroundColor
  final Color? selectedBackgroundColor;

  /// Background color when container is not selected.
  /// Default value : dialogBackgroundColor
  final Color? unselectedBackgroundColor;

  /// Background color of the icon when container is selected.
  /// Default value : theme.primaryColor
  final Color? selectedBackgroundColorIcon;

  /// Background color of the icon when container is not selected.
  /// Default value : theme.primaryColorDark
  final Color? unselectedBackgroundColorIcon;

  /// Border color when container is selected.
  /// Default value : primaryColor
  final Color? selectedBorderColor;

  /// Border color when container is not selected.
  /// Default value :primaryColorDark
  final Color? unselectedBorderColor;

  /// Border color of the icon when container is selected.
  /// Default value : Colors.white
  final Color? selectedBorderColorIcon;

  /// Border color of the icon when container is not selected.
  /// Default value : Colors.white
  final Color? unselectedBorderColorIcon;

  /// Icon's color
  /// Default value : white
  final Color iconColor;

  /// The child to render inside the container
  final Widget? child;

  /// Callback of type ValueChanged
  final ValueChanged<bool> onValueChanged;

  /// Icon to be shown when unselected.
  /// Default value : geen
  final IconData? unselectedIcon;

  ///Default not selected
  final bool selected;

  // Top position of the icon.
  final double? topIconPosition;

  // Bottom position of the icon.
  final double? bottomIconPosition;

  // Left position of the icon.
  final double? leftIconPosition;

  // Right position of the icon.
  final double? rightIconPosition;

  const SelectableContainer(
      {super.key,
      required this.selected,
      this.marginColor,
      this.unselectedBackgroundColor,
      this.selectedBackgroundColor,
      this.unselectedBackgroundColorIcon,
      this.selectedBackgroundColorIcon,
      this.selectedBorderColor,
      this.unselectedBorderColor,
      this.selectedBorderColorIcon,
      this.unselectedBorderColorIcon,
      required this.onValueChanged,
      this.iconColor = Colors.white,
      this.unselectedIcon,
      this.topIconPosition,
      this.bottomIconPosition,
      this.leftIconPosition,
      this.rightIconPosition,
      required this.child});

  @override
  Widget build(BuildContext context) {
    ///
    var iconAlignment = Alignment.topRight;
    var opacityAnimationDuration = 600;
    var padding = 8.0;
    var elevation = 0.0;
    var borderRadius = 10.0;
    var topMargin = 0.0;
    var bottomMargin = 0.0;
    var leftMargin = 0.0;
    var rightMargin = 0.0;
    var iconSize = 16;

    ///

    ///
    var borderSize = 2;

    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        onValueChanged(!selected);
      },
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: opacityAnimationDuration),
        child: Material(
          elevation: elevation,
          color: marginColor ?? theme.scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                leftMargin, topMargin, rightMargin, bottomMargin),
            child: Stack(
              alignment: iconAlignment,
              children: <Widget>[
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(iconSize / 2),
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                      border: borderSize > 0
                          ? Border.all(
                              color: selected
                                  ? selectedBorderColor ?? theme.primaryColor
                                  : unselectedBorderColor ??
                                      theme.primaryColorDark,
                              width: borderSize.toDouble(),
                            )
                          : const Border.symmetric(),
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: selected
                          ? selectedBackgroundColor ??
                              theme.dialogBackgroundColor
                          : unselectedBackgroundColor ??
                              theme.dialogBackgroundColor),
                  child: child,
                ),
                Positioned(
                  top: topIconPosition,
                  bottom: bottomIconPosition,
                  left: leftIconPosition,
                  right: rightIconPosition,
                  child: Visibility(
                      visible: !selected && unselectedIcon != null,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    unselectedBorderColorIcon ?? Colors.white),
                            shape: BoxShape.circle,
                            color: unselectedBackgroundColorIcon ??
                                theme.primaryColorDark),
                        child: Icon(
                          unselectedIcon,
                          size: iconSize.toDouble(),
                          color: iconColor,
                        ),
                      )),
                ),
                Positioned(
                  top: topIconPosition,
                  bottom: bottomIconPosition,
                  left: leftIconPosition,
                  right: rightIconPosition,
                  child: Visibility(
                    visible: selected,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedBorderColorIcon ?? Colors.white),
                          shape: BoxShape.circle,
                          color: selectedBackgroundColorIcon ??
                              theme.primaryColor),
                      child: Icon(
                        Icons.close,
                        size: iconSize.toDouble(),
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

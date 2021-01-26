import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String label;
  final IconData icon;
  final Function onTap;

  CustomButton({this.label, this.icon, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Theme.of(context).accentColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Icon(
            icon,
            size: 36,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ],
      ),
      onPressed: onTap,
    );
  }
}
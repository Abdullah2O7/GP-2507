import 'package:flutter/material.dart';

class EllipsesInResultpage extends StatelessWidget {
  const EllipsesInResultpage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Ellipse
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
              const SizedBox(
                height: 4,
              )
            ],
          ),
          const SizedBox(
            width: 2,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Ellipse
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white, width: 1),
                ),
              )
            ],
          ),
          const SizedBox(
            width: 2,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Ellipse
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white, width: 1),
                ),
              )
            ],
          ),
          const SizedBox(
            width: 2,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 4,
              ),
              //Ellipse
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white, width: 1),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

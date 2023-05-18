import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_farming/ui/smart_widgets/online_status.dart';
import 'package:stacked/stacked.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:lottie/lottie.dart';

import 'control_viewmodel.dart';

class ControlView extends StatelessWidget {
  const ControlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ControlViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Farm monitor'),
              centerTitle: true,
              actions: [IsOnlineWidget()],
            ),
            body: model.data != null
                ? const _HomeBody()
                : Center(child: Text("No data")));
      },
      viewModelBuilder: () => ControlViewModel(),
    );
  }
}

class _HomeBody extends ViewModelWidget<ControlViewModel> {
  const _HomeBody({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, ControlViewModel model) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              FarmView(
                value: model.newValue(model.data!.s1),
                text: "Farm 1",
                led: model.leds[0],
                onTap: () {
                  model.ledOnOff(0);
                },
              ),
              FarmView(
                value: model.newValue(model.data!.s2),
                text: "Farm 2",
                led: model.leds[1],
                onTap: () {
                  model.ledOnOff(1);
                },
              ),
              FarmView(
                value: model.newValue(model.data!.s3),
                text: "Farm 3",
                led: model.leds[2],
                onTap: () {
                  model.ledOnOff(2);
                },
              ),
              FarmView(
                value: model.newValue(model.data!.s4),
                text: "Farm 4",
                led: model.leds[3],
                onTap: () {
                  model.ledOnOff(3);
                },
              ),
              FarmView(
                value: model.newValue(model.data!.s5),
                text: "Farm 5",
                led: model.leds[4],
                onTap: () {
                  model.ledOnOff(4);
                },
              ),
            ],
          ),
        ),
        // else if (model.data!.s1 < 30)
        //   Positioned.fill(
        //       child: LottieShow(
        //     link: 'https://assets3.lottiefiles.com/packages/lf20_qf6zku4z.json',
        //     text: 'Connect GSR cables',
        //   ))
      ],
    );
  }
}

class FarmView extends StatelessWidget {
  final VoidCallback onTap;
  final double value;
  final String text;
  final int led;
  const FarmView({
    Key? key,
    required this.value,
    required this.text,
    required this.onTap,
    required this.led,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green.withOpacity(0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              LiquidCircularProgressIndicator(
                value: value,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                // borderColor: Colors.black,
                // borderWidth: 1.0,
                center: value == -1
                    ? Text("Error")
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${(value * 100).round()}%"),
                          Text(text),
                        ],
                      ),
              ),
              if (led == 1) Icon(Icons.circle, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}

class LottieShow extends StatelessWidget {
  final String link;
  final String text;
  const LottieShow({super.key, required this.link, required this.text});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Center(
        child: Card(
          elevation: 10,
          color: Colors.black.withOpacity(0.5),
          child: Container(
            // height: 250,
            // width: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.network(link),
                  SizedBox(height: 20),
                  Text(
                    text,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

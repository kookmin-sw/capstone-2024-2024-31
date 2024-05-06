import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';
//
// void main() {
//   runApp(const CameraAwesomeApp());
// }

class CameraAwesomeApp extends StatelessWidget {
  const CameraAwesomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CameraPage(
    );
  }
}

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photo(),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          aspectRatio: CameraAspectRatios.ratio_1_1,
        ),
        previewFit: CameraPreviewFit.contain,
        previewPadding: const EdgeInsets.only(left: 150, top: 100),
        previewAlignment: Alignment.topRight,
        // Buttons of CamerAwesome UI will use this theme
        theme: AwesomeTheme(
          bottomActionsBackgroundColor:Palette.purPle400.withOpacity(0.5),
          buttonTheme: AwesomeButtonTheme(
            backgroundColor:Palette.white.withOpacity(0.5),
            iconSize: 20,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            // Tap visual feedback (ripple, bounce...)
            buttonBuilder: (child, onTap) {
              return ClipOval(
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    splashColor: Palette.mainPurple,
                    highlightColor: Palette.mainPurple.withOpacity(0.5),
                    onTap: onTap,
                    child: child,
                  ),
                ),
              );
            },
          ),
        ),
        topActionsBuilder: (state) => AwesomeTopActions(
          padding: EdgeInsets.zero,
          state: state,
          children: [
            Expanded(
              child: AwesomeFilterWidget(
                state: state,
                filterListPosition: FilterListPosition.aboveButton,
                filterListPadding: const EdgeInsets.only(top: 8),
              ),
            ),
          ],
        ),
        middleContentBuilder: (state) {
          return Column(
            children: [
              const Spacer(),
              Builder(builder: (context) {
                return Container(
                  color: AwesomeThemeProvider.of(context)
                      .theme
                      .bottomActionsBackgroundColor,
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        "주어진 손동작과 함께 인증하세요!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
        bottomActionsBuilder: (state) => AwesomeBottomActions(
          state: state,
          left: AwesomeFlashButton(
            state: state,
          ),
          right: AwesomeCameraSwitchButton(
            state: state,
            scale: 1.0,
            onSwitchTap: (state) {
              state.switchCameraSensor(
                aspectRatio: state.sensorConfig.aspectRatio,
              );
            },
          ),
        ),
      ),
    );
  }
}
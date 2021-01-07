import 'package:flutter/material.dart';
import 'package:headtrack/constants/app_colors.dart';

class InstructionScreen extends StatefulWidget {
  @override
  _InstructionScreenState createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Colors.white, fontSize: 18);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text('Instructions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: '',
                    style: style,
                    children: <TextSpan>[
                      TextSpan(
                          text: 'On your PC:\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                            """1.On your computer, install and run the free program OpenTrack at github.com/opentrack/opentrack/releases.""",
                      ),
                      TextSpan(
                        text:
                            """\n\n2.Press the Windows key -> type "Firewall" -> "Firewall & Network Protection" -> "Advanced Settings" -> Inbound Rules -> New Rule... -> Program -> Program Path to opentrack.exe (probably "c:\program files (x86)\opentrack\opentrack.exe")""",
                      ),
                      TextSpan(
                        text:
                            """\n\n3.Right click on your network symbol at the bottom right of Windows, choose "Open Network & Internet Settings" -> Change Connection Properties -> Choose "Private" instead of "Public" (this will make your PC discoverable to your mobile device)""",
                      ),
                      TextSpan(
                        text:
                            """\n\n4.Find the IP address of your PC by running 'ipconfig' in a Command Line - look for "IPv4 Address".""",
                      ),
                      TextSpan(
                        text: """\n\n5.Now restart OpenTrack.""",
                      ),
                      TextSpan(
                        text:
                            """\n\n6.In Input, choose UDP and open up the settings and note the port (probably 4242).""",
                      ),
                      TextSpan(
                        text:
                            """\n\n7.As Output, choose "Freetrack 2.0 Enhanced" and "Both" in its settings.""",
                      ),
                      TextSpan(
                        text:
                            """\n\n8.In Options, bind a hotkey of your choice to "Center" (say, F10)""",
                      ),
                      TextSpan(
                        text: """\n\n9.Press Start in OpenTrack.""",
                      ),
                      TextSpan(
                        text: '\n\nOn your mobile device:\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            """1.If you have more than one wifi around and you have previously connected to more then one of them, then in your phone, set any other wifis "Auto-Join" to "off" """,
                      ),
                      TextSpan(
                        text: """\n\n2.Now restart the app.""",
                      ),
                      TextSpan(
                        text:
                            """\n\n3.Enter the local IPv4 address from above in the app by clicking on the edit button next to the IP Address""",
                      ),
                      TextSpan(
                        text:
                            """\n\n4.Enter the port  from above in the app by clicking on the edit button next to the Port""",
                      ),
                      TextSpan(
                        text: """\n\n5.Make sure enabled is switch on.""",
                      ),
                      TextSpan(
                        text: """\n\n""",
                      ),
                    ],
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

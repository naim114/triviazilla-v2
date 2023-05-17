import 'package:flutter/material.dart';
import 'package:triviazilla/oss_licenses.dart';

import '../../../services/helpers.dart';

class Libraries extends StatelessWidget {
  const Libraries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          "Libraries",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: ossLicenses.map((package) {
          return ExpansionTile(
            title: Text('${package.name} ${package.version}'),
            children: [
              ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(color: getColorByBackground(context)),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Website URL: \n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: package.homepage ?? "None"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(color: getColorByBackground(context)),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Repository URL: \n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: package.repository ?? "None"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(color: getColorByBackground(context)),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Description: \n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: package.description),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(color: getColorByBackground(context)),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'License: \n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: package.license ?? "None"),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

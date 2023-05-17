import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/user_activity_model.dart';
import '../../services/helpers.dart';

Widget listTileActivity({
  required BuildContext context,
  required UserActivityModel activity,
  bool includeNetworkInfo = false,
  bool signInFormat = false,
}) =>
    ExpansionTile(
      title: Text(
        signInFormat ? activity.deviceInfo ?? "None" : activity.description,
        style: const TextStyle(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle:
          Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(activity.createdAt)),
      children: <Widget>[
        !signInFormat
            ? ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(color: getColorByBackground(context)),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Description: \n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: activity.description),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        ListTile(
          title: RichText(
            text: TextSpan(
              style: TextStyle(color: getColorByBackground(context)),
              children: <TextSpan>[
                const TextSpan(
                    text: 'Date Time: \n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: DateFormat('dd/MM/yyyy HH:mm:ss')
                        .format(activity.createdAt)),
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
                    text: 'Device info: \n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: activity.deviceInfo),
              ],
            ),
          ),
        ),
        !includeNetworkInfo
            ? const SizedBox()
            : Column(
                children: [
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        style: TextStyle(color: getColorByBackground(context)),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Wifi Name: \n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: activity.wifiName),
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
                              text: 'Wifi BSSID: \n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: activity.wifiBSSID),
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
                              text: 'Wifi IPv4: \n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: activity.wifiIPv4),
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
                              text: 'Wifi IPv6: \n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: activity.wifiIPv6),
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
                              text: 'Wifi GatewayIP: \n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: activity.wifiGatewayIP),
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
                              text: 'Wifi Broadcast: \n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: activity.wifiBroadcast),
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
                              text: 'Wifi Submask: \n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: activity.wifiSubmask),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );

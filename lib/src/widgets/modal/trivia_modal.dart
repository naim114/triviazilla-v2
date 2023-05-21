import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:triviazilla/src/features/trivia/leaderboard.dart';
import 'package:triviazilla/src/model/role_model.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/helpers.dart';

import '../image/avatar.dart';

void showTriviaModal({
  required BuildContext context,
}) =>
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: Container(
            color:
                isDarkTheme(context) ? CustomColor.darkerBg : Colors.grey[200],
            height: MediaQuery.of(context).size.height * 0.9,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Cover image
                    SliverAppBar(
                      flexibleSpace: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://cdn.pixabay.com/photo/2019/07/02/10/25/giraffe-4312090_1280.jpg',
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.3,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: CupertinoColors.systemGrey,
                            highlightColor: CupertinoColors.systemGrey2,
                            child: Container(
                              color: Colors.grey,
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/noimage.png',
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ),
                      ),
                      expandedHeight: MediaQuery.of(context).size.height * 0.3,
                      leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == 'Leaderboard') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TriviaLeaderboard(),
                                ),
                              );
                            } else if (value == 'Like') {
                              //
                            } else if (value == 'Bookmark') {
                              //
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            PopupMenuItem(
                              value: 'Leaderboard',
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                      color: getColorByBackground(context)),
                                  children: const [
                                    WidgetSpan(child: Icon(Icons.leaderboard)),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    TextSpan(text: "Leaderboard"),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'Like',
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                      color: getColorByBackground(context)),
                                  children: const [
                                    WidgetSpan(
                                        child: Icon(CupertinoIcons.heart_fill)),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    TextSpan(text: "Like"),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'Bookmark',
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                      color: getColorByBackground(context)),
                                  children: const [
                                    WidgetSpan(child: Icon(Icons.bookmark)),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    TextSpan(text: "Bookmark"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Title & Stats
                    SliverToBoxAdapter(
                      child: Container(
                        color: isDarkTheme(context)
                            ? CustomColor.darkBg
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Is this a Rhinosaurous?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getColorByBackground(context),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const Divider(color: CupertinoColors.systemGrey),
                              // Stats Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            CupertinoIcons.play_arrow_solid,
                                            size: 25,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' 12',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            CupertinoIcons.question_circle_fill,
                                            size: 25,
                                            color: Colors.green,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' 5',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            CupertinoIcons.heart_fill,
                                            size: 25,
                                            color: Colors.pink,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' 10',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Author & Description
                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: Column(
                          children: [
                            ListTile(
                              leading: avatar(
                                user: UserModel(
                                  id: 'id',
                                  name: 'name',
                                  email: 'email',
                                  password: 'password',
                                  role: RoleModel(
                                    id: 'id',
                                    name: 'name',
                                    displayName: 'displayName',
                                    description: 'description',
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                  ),
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              title: Text(
                                'user.name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: getColorByBackground(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                'user.email',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: getColorByBackground(context)),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'What is Vantablack? Vantablack is the brand name for a new class of super-black coatings. The coatings are unique in that they all have hemispherical reflectances below 1% and also retain that level of performance from all viewing angles. The original coating known just as Vantablack® was a super-black coating that holds the independently verified world record as the darkest man-made substance. It was originally developed for satellite-borne blackbody calibration systems, but due to limitations in how it was manufactured its been surpassed by our spray applied Vantablack coatings. Spray applied Vantablack coatings have unrivalled absorption from ultra-violet out beyond the terahertz spectral range. The totally unique properties of Vantablack coatings are being exploited for applications such as deep space imaging, automotive sensing, optical systems, art and aesthetics. Vantablack Coating Range Vantablack S-VIS (UV-THz performance - space qualified) Vantablack S-IR (Optimised from 5-14um - space qualified for blackbody applications) Vantablack VBx2 (Terrestrial applications from UV-THz) Typical Coating Properties Ultra-low reflectance - exceptional performance from all angles UV, Visible and IR absorption - Absorption works from UV (200-350 nm wavelength), through the visible (350-700nm) and into the far infrared (>600 microns) spectrum, with no spectral features. Super hydrophobic - Unlike other black coatings, humidity will not degrade the optical properties Very high thermal shock resistance - Repeatedly plunging a Vantablack S-VIS coated substrate into liquid Nitrogen at -196°C and then transferring to a 200°C hot plate in air does not affect its properties. Resistant to shock and vibration - Independently tested, coatings have been subjected to shock and vibration simulating launch and staging. Low outgassing and mass loss - Independent testing to ECSS shows TML<0.5 Excellent BDRF and TIS performance - Even at shallow angles the levels of blackness outperforms all other commercial super-black coatings',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkTheme(context)
                          ? CustomColor.darkBg
                          : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Start",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

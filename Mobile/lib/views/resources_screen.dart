import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:splash_onboarding_test/views/links_page.dart';
import 'package:splash_onboarding_test/widgets/tab_bar_header.dart';
import 'package:url_launcher/url_launcher.dart';

// A class to hold video URL and title
class VideoItem {
  final String url;
  final String title;
  VideoItem({required this.url, required this.title});
}

class ResourcesScreen extends HookWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    final selectedIndex = useState(0);
    final searchController = useTextEditingController();
    final categories = useState<List<dynamic>>([]);
    final filteredCategories = useState<List<dynamic>>([]);
    final isLoading = useState<bool>(true);

    final allVideos = useState<List<VideoItem>>([]);
    final filteredVideos = useState<List<VideoItem>>([]);

    final videoLinks = [
      'https://youtu.be/tJQRsIbD110?si=rH6SxFR281xMct7z',
      'https://youtu.be/7qir8-ncvBA?si=jTMlvO6HmEWcQltP',
      'https://youtu.be/hzSx4rMyVjI?si=0E-3wc3o7k_0RFWG',
      'https://youtu.be/w8JnDhp83gA?si=vavBFHyQ-zws8aoc',
      'https://youtu.be/xsEJ6GeAGb0?si=CK45pe8hIGqwHQ_7',
      'https://youtu.be/QuWsHyuLD_E?si=0mT6MuNWlTjjotGg',
    ];

    Future<void> fetchCategories() async {
      try {
        final response = await http.get(
          Uri.parse(
              'https://gpappapis.azurewebsites.net/api/get_all_categoires'),
        );
        if (response.statusCode == 200) {
          final fetched = jsonDecode(response.body);
          categories.value = fetched;
          filteredCategories.value = fetched;
        } else {
          debugPrint("Failed to load categories: ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("Error fetching categories: $e");
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> fetchVideoTitles() async {
      List<VideoItem> loaded = [];
      for (String url in videoLinks) {
        try {
          final response = await http.get(
              Uri.parse('https://www.youtube.com/oembed?url=$url&format=json'));
          if (response.statusCode == 200) {
            final title =
                jsonDecode(response.body)['title'] ?? 'Untitled Video';
            loaded.add(VideoItem(url: url, title: title));
          } else {
            loaded.add(VideoItem(url: url, title: 'Untitled Video'));
          }
        } catch (_) {
          loaded.add(VideoItem(url: url, title: 'Untitled Video'));
        }
      }
      allVideos.value = loaded;
      filteredVideos.value = loaded;
    }

    void filterContent(String query) {
      final q = query.toLowerCase();
      if (selectedIndex.value == 0) {
        filteredCategories.value = categories.value.where((cat) {
          final name = cat['disorder_name']?.toLowerCase() ?? '';
          return name.contains(q);
        }).toList();
      } else {
        filteredVideos.value = allVideos.value.where((video) {
          return video.title.toLowerCase().contains(q);
        }).toList();
      }
    }

    useEffect(() {
      fetchCategories();
      fetchVideoTitles();

      tabController.addListener(() {
        selectedIndex.value = tabController.index;
        filterContent(searchController.text);
      });

      searchController.addListener(() {
        filterContent(searchController.text);
      });

      return () {
        searchController.dispose();
      };
    }, []);

    return Scaffold(
      backgroundColor: const Color(0xffFFFAEF),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                TabBarHeader(
                  selectedIndex: selectedIndex.value,
                  tabController: tabController,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                  child: SizedBox(
                    height: 40,
                    width: 400,
                    child: TextFormField(
                      controller: searchController,
                      style: const TextStyle(color: Color(0xff537F5C)),
                      cursorColor: const Color(0xff537F5C),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffFFFAEF),
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF537F5C)),
                        suffixIcon: const Icon(Icons.mic_none,
                            color: Color(0xFF537F5C)),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Color(0xFF537F5C),
                          fontFamily: 'Ledger',
                          fontSize: 18,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Color(0xFF537F5C), width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Color(0xFF537F5C), width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Color(0xFF537F5C), width: 1.2),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      // Tab 1 - Categories
                      ListView(
                        children: filteredCategories.value.map((cat) {
                          Widget imageWidget;
                          if (cat['picture'] != null &&
                              cat['picture'].contains(',')) {
                            try {
                              final imageBytes =
                                  base64Decode(cat['picture'].split(',')[1]);
                              imageWidget = ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(imageBytes,
                                    width: 150.w,
                                    height: 104.h,
                                    fit: BoxFit.cover),
                              );
                            } catch (_) {
                              imageWidget = const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey);
                            }
                          } else {
                            imageWidget = const Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey);
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MentalHealthWidget(
                                        disorderName: cat['disorder_name']),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff537F5C)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    imageWidget,
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          cat['disorder_name'],
                                          style: const TextStyle(
                                            fontFamily: 'Regular',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Tab 2 - Videos
                      ListView(
                        children: filteredVideos.value.map((video) {
                          final videoId = Uri.parse(video.url)
                              .pathSegments
                              .last
                              .split('?')
                              .first;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10),
                            child: GestureDetector(
                              onTap: () async {
                                final url = Uri.parse(video.url);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url,
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Could not launch video')),
                                  );
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      'https://img.youtube.com/vi/$videoId/0.jpg',
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    video.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'InriaSans-Bold',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading.value)
              Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.white,
                  size: 50.h,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

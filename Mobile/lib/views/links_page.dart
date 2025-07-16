import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MentalHealthWidget extends StatefulWidget {
  final String disorderName;

  const MentalHealthWidget({super.key, required this.disorderName});

  @override
  _MentalHealthWidgetState createState() => _MentalHealthWidgetState();
}

class _MentalHealthWidgetState extends State<MentalHealthWidget> {
  String? disorderName;
  Uint8List? disorderImage;
  List<dynamic> resources = [];
  bool isLoading = true;
  bool hasError = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchResources();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchResources() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        hasError = false;
      });
    }

    final url = Uri.parse(
        'https://gpappapis.azurewebsites.net/api/get_resources/${widget.disorderName}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);

        if (mounted) {
          setState(() {
            disorderName = data['disorder_name'];
            resources = data['resources'];

            if (data['picture'] != null && data['picture'].contains(',')) {
              try {
                disorderImage = base64Decode(data['picture'].split(',')[1]);
              } catch (e) {
                debugPrint("Error decoding image: $e");
              }
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            hasError = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching resources: $e");
      if (mounted) {
        setState(() {
          hasError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(Uri.encodeFull(url));

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint("Could not launch $url");
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFAEF),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: const Color(0xff537F5C),
                size: 50.h,
              ),
            )
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: disorderImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                ),
                                child: Image.memory(
                                  disorderImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(),
                      ),
                      Positioned(
                        left: 10.w,
                        top: MediaQuery.of(context).padding.top,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Color(0xff000000), size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Positioned(
                        bottom: 16.h,
                        left: 25.w,
                        right: 25.w,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: const Color(0xffD9D9D9).withOpacity(.20),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Text(
                              disorderName ?? widget.disorderName,
                              style: const TextStyle(
                                color: Color(0xff000000),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'InriaSans-Bold',
                                shadows: [
                                  Shadow(
                                    blurRadius: 6.0,
                                    color: Colors.black45,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasError)
                  const Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        "Failed to load resources. Please try again later.",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Expanded(
                    flex: 4,
                    child: ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor:
                            WidgetStateProperty.all(const Color(0xff537F5C)),
                        radius: const Radius.circular(10),
                        thickness: WidgetStateProperty.all(6.0),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: resources.length,
                              itemBuilder: (context, index) {
                                final resource = resources[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Color(0xff537F5C)),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  color:
                                      const Color(0xff537F5C).withOpacity(.38),
                                  elevation: 6,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                  child: InkWell(
                                    onTap: () => _launchURL(resource['link']),
                                    child: Container(
                                      padding: EdgeInsets.all(16.h),
                                      alignment: Alignment.center,
                                      child: Text(
                                        resource['title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Regular',
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

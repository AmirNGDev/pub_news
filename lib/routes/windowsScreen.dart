// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pub_news/services/rss_to_json.dart';
import 'package:url_launcher/url_launcher.dart';

class WindowsScreen extends StatefulWidget {
  const WindowsScreen({super.key});

  @override
  State<WindowsScreen> createState() => _WindowsScreenState();
}

class _WindowsScreenState extends State<WindowsScreen> {
  Future<dynamic>? data;

  @override
  void initState() {
    super.initState();
    data = rssToJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
      body: SafeArea(
        child: FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text('please wait'),
                ],
              ));
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data['feed'] == null)
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Please check your internet connection and try again.',
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              data = rssToJson();
                            });
                          },
                          icon: const Icon(Icons.refresh))
                    ],
                  ),
                );
              else
                return CustomScrollView(
                  slivers: [
                    SliverAppBar.medium(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset('assets/dart.png'),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('Pub News'),
                        ],
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      centerTitle: true,
                    ),
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 0.82,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(
                                  snapshot.data['feed']['entry'][index]['link']['href']);

                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, left: 8, right: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 5 - 80,
                                        child: Text(
                                          snapshot.data['feed']['entry'][index]['title']['\$t']
                                              .split('of')
                                              .last
                                              .trim(),
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      snapshot.data['feed']['entry'][index]['content']['\$t'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(horizontal: 10),
                                                child: Center(
                                                  child: Text(
                                                    snapshot.data['feed']['entry'][index]['title']['\$t'].split('of').first.trim(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text: snapshot.data['feed']['entry'][index]
                                                        ['link']['href'],
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                margin: const EdgeInsets.only(left: 8),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.copy,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Center(
                                            child: Text(
                                              'updated: ${snapshot.data['feed']['entry'][index]['updated']['\$t'].toString().substring(11, 16)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: snapshot.data['feed']['entry'][index]
                                                  ['author'] !=
                                              null,
                                          child: Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Center(
                                              child: Text(
                                                snapshot.data['feed']['entry'][index]
                                                            ['author'] ==
                                                        null
                                                    ? ''
                                                    : 'author: ${snapshot.data['feed']['entry'][index]['author']['name']['\$t'].toString()}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data['feed']['entry'].length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            snapshot.data['feed']['title']['\$t'].toString(),
                            style: const TextStyle(fontSize: 19),
                          ),
                          Text(
                            snapshot.data['feed']['subtitle']['\$t'].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'The Latest Update : ${snapshot.data['feed']['updated']['\$t'].toString().substring(0, 10)}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pub_news/routes/webview.dart';
import 'package:pub_news/services/rss_to_json.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                ));
              else
                return RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 2));
                    data = rssToJson();
                    setState(() {});
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
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
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                      url: snapshot.data['feed']['entry'][index]['link']
                                          ['href']),
                                ));
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
                                          width: MediaQuery.of(context).size.width - 80,
                                          child: Text(
                                            snapshot.data['feed']['entry'][index]['title']
                                                ['\$t'],
                                            style: const TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: snapshot.data['feed']['entry'][index]
                                                    ['link']['href']));
                                          },
                                          tooltip: 'Copy Link',
                                          icon: const Icon(
                                            Icons.copy,
                                            color: Colors.black,
                                          ),
                                        ),
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
                                        maxLines: null,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                              width: 8,
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
                                                padding:
                                                    const EdgeInsets.symmetric(horizontal: 10),
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
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

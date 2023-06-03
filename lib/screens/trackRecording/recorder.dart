import 'package:divya/screens/trackRecording/trackList.dart';
import 'package:flutter/material.dart';

class RecorderPage extends StatefulWidget {
  const RecorderPage({Key? key});

  @override
  _RecorderPageState createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          SizedBox(height: 100),
          // Text(RecorderPage
          //   "Record Track",
          //   style: TextStyle(color: Colors.black, fontSize: 30),
          // ),
          SizedBox(
            height: 10,
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.5)),
                  controller: tabController,
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 30),
                  tabs: [
                    Tab(
                      child: Text(
                        "Tracks",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Recordings",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ]),
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: [
              Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => const TrackList(),
                  );
                },
              ),
              Container(
                child: Center(
                  child: Text('Tab 2 Content'),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

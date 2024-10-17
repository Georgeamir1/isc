import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize YouTube video controller
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId("https://youtu.be/JI8K27cG-Jw")!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    // Start the timer for the loading screen
    Timer(Duration(seconds: 7), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildVideoInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Flutter YouTube Video Player Example",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1.2M views • 3 days ago",
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up_alt_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down_alt_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.download),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedVideosSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 100,
              height: 56,
              color: Colors.grey[300],
              child: Icon(Icons.play_arrow, color: Colors.white),
            ),
            title: Text("Recommended Video Title $index"),
            subtitle: Text("Channel Name • 120K views • 2 days ago"),
            onTap: () {
              // Handle video tap (you could load a new video here)
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            builder: (context, player) {
              return player;
            },
          ),
          _buildVideoInfoSection(),
          Divider(color: Colors.grey[800]),
          _buildRecommendedVideosSection(),
        ],
      ),
    );
  }
}

import 'package:auto_route/annotations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:libtorrent_flutter/libtorrent_flutter.dart';

@RoutePage()
class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = useStream(LibtorrentFlutter.instance.torrentUpdates);
    final firstEntry = stream.data?.entries.first;
    final progress = firstEntry?.value.progress ?? 0.0;
    final downloadSpeed = firstEntry?.value.downloadRate ?? 0;
    final engine = LibtorrentFlutter.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          FilledButton.tonal(
            onPressed: () async {
              final result = await FilePicker.pickFiles(
                allowMultiple: false,
                type: FileType.custom,
                allowedExtensions: ['torrent'],
              );

              if (result != null) {
                final torrentId = LibtorrentFlutter.instance.addTorrentFile(
                  result.files.single.path!,
                );

                engine.resumeTorrent(torrentId);
              }
            },
            child: Text('Press Me'),
          ),
          LinearProgressIndicator(value: progress),
          Text('Download Speed: ${formatSpeed(downloadSpeed)}'),
          Text('State: ${firstEntry?.value.state.label ?? 'N/A'}'),
        ],
      ),
    );
  }
}

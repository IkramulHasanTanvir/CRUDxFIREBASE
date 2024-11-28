import 'package:crud/models/note_model.dart';
import 'package:crud/services/firestore.dart';
import 'package:flutter/material.dart';

class NoteTile extends StatefulWidget {
  const NoteTile({
    super.key,
    required this.noteModel,
    required this.onTapUpdate,
  });

  final NoteModel noteModel;
  final VoidCallback onTapUpdate;

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  final FireStoreService _fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.noteModel.note,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: widget.onTapUpdate,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: ()=> _fireStoreService.deleteNotes(widget.noteModel.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
          Text(widget.noteModel.timestamp.toDate().toString()),
        ],
      ),
    );
  }
}

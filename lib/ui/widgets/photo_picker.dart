import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class photo_picker extends StatelessWidget {
  final VoidCallback onTap;
  final XFile? selectedPhoto;
  final String? currentPhotoUrl;

  const photo_picker({
    super.key,
    required this.onTap,
    this.selectedPhoto,
    this.currentPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [

              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _buildImageWidget(),
                ),
              ),


              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),


        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                _getMainStatusText(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),


              if (selectedPhoto != null) ...[

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    selectedPhoto!.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else if (_isValidNetworkImageUrl(currentPhotoUrl)) ...[

                Text(
                  'Current profile picture',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ] else ...[

                Text(
                  'Tap to add profile photo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],

              const SizedBox(height: 8),


              if (!_isValidNetworkImageUrl(currentPhotoUrl) && selectedPhoto == null)
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'No photo available',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget() {

    if (selectedPhoto != null) {
      return Image.file(
        File(selectedPhoto!.path),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }


    if (_isValidNetworkImageUrl(currentPhotoUrl)) {
      return Image.network(
        currentPhotoUrl!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }


    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }


  bool _isValidNetworkImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    final trimmedUrl = url.trim();


    if (trimmedUrl.isEmpty) {
      return false;
    }


    if (trimmedUrl.toLowerCase() == 'null') {
      return false;
    }


    if (trimmedUrl == '""' || trimmedUrl == "''") {
      return false;
    }


    if (trimmedUrl.startsWith('file://')) {
      return false;
    }


    if (!trimmedUrl.startsWith('http://') && !trimmedUrl.startsWith('https://')) {
      return false;
    }


    try {
      final uri = Uri.parse(trimmedUrl);
      if (uri.host.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }


  String _getMainStatusText() {
    if (selectedPhoto != null) {
      return 'New Photo Selected';
    } else if (_isValidNetworkImageUrl(currentPhotoUrl)) {
      return 'Profile Photo';
    }
    return 'Add Photo';
  }
}
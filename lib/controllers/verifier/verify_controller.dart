import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/login_controller.dart';
import '../members/member_controller.dart';
import '../../models/member.dart';
import '../../services/app_photo.dart';
import 'package:get/get.dart';

class VerifyController extends GetxController {
  /* <---- Dependency -----> */
  // ignore: unused_field
  late CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection('members')
      .doc(_currentUserID)
      .collection('members_collection');

  /// User ID of Current Logged In user
  late String _currentUserID;
  _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().user!.uid;
  }

  /// All Members Photo
  List<String> allMemberImagesURL = [];

  /// Get All Members Images
  /// This is the firebase way
  // Future<void> _getAllMembersImagesURL() async {
  //   allMemberImagesURL = [];
  //   _collectionReference.get().then((value) {
  //     value.docs.forEach((element) {
  //       Map<String, dynamic> map = element.data() as Map<String, dynamic>;
  //       String imageURl = map['memberPicture'];
  //       allMemberImagesURL.add(imageURl);
  //     });
  //   });
  // }
  /// Local Way of Getting Images URL
  _getAllMembersImagesURL() {
    List<Member> _allMember = Get.find<MembersController>().allMember;
    _allMember.forEach((element) {
      allMemberImagesURL.add(element.memberPicture);
    });
  }

  /// All Files are stored in Ram, These can be a quick way to verify
  /// the user. So that we don't have to downlaod the user picture again and
  /// again
  List<File> allMemberImagesFile = [];

  /// Convert All The URLs To File by Downloading it and
  /// storing it to the ram
  Future<void> _getAllMemberImagesToFile() async {
    // You can delay this a little bit to get performance
    await Future.forEach<String>(allMemberImagesURL, (element) async {
      File _file = await AppPhotoService.fileFromImageUrl(element);
      allMemberImagesFile.add(_file);
    });
  }

  /* <---- Method Channel -----> */
  // static const MethodChannel _channel = MethodChannel('verifier');

  /// Verify Person
  /// You can invoke method channel with this function
  Future<bool> verifyPerson() async {
    allMemberImagesURL.forEach((personImage) {
      /// Each person Image can be verified here
      // _channel.invokeMethod('verifyperson');
    });
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _getAllMembersImagesURL();
    _getAllMemberImagesToFile();
  }
}

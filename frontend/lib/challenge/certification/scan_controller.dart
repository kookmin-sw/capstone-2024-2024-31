import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class ScanController extends GetxController {

  final RxBool isInitialized = RxBool(false);
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;


  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;
  
  Future<void> _initCamera() async{
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then ((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    
    }).catchError((Object e) {
        if (e is CameraException)  {
          switch (e.code){
            case 'CameraAccessDenied':
              print('User denied camera access');
              break;
            default:
              print('Handle other errors.');
              break;    
            }
        }
    })
  }



  @override
  void onInit() {
    _initCamera();
    super.onInit();
  }
}
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class sucesscontroller extends GetxController
{
  RxList days=[].obs;
  RxString DocName=''.obs;
  RxString   appointday=''.obs;
  RxString date=' ' .obs;
  RxString Tokennum=' '.obs;
  RxString SelectDate=''.obs;
  RxList<RxBool> loadingList = <RxBool>[].obs;
  RxBool loginbool=false.obs;
  RxBool mobilenumcheck=false.obs;
  RxBool otpinput=false.obs;
  RxBool SignUpbool=false.obs;




  void setLoadingStates(int length) {
    loadingList.clear();
    for (int i = 0; i < length; i++) {
      loadingList.add(RxBool(false));
    }
  }

}
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine; // 아고라 엔진을 저장할 변수
  int? uid; // 내 ID
  int? otherUid; // 상대방 ID
  String appId = dotenv.env["APP_ID"]!;
  String channelName = dotenv.env["CHANNEL_NAME"]!;
  String tempToken = dotenv.env["TEMP_TOKEN"]!;

  // 권한 관련 작업 모두 실행
  Future<bool> init() async {
    // 권한(카메라, 마이크) List로 한 번에 Request 하기
    final resp = await [Permission.camera, Permission.microphone].request();

    // 요청한 권한(카메라, 마이크) Response 체크
    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    // 카메라, 마이크 권한 요청 허가가 되지 않았을 때.
    // granted: 권한이 허가가 완료된 상태
    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다.';
    }

    if (engine == null) {
      // 엔진이 정의되지 않았으면 새로 정의하기
      engine = createAgoraRtcEngine();

      // 아고라 엔진을 초기화합니다.
      await engine!.initialize(
        // 초기화할 때 사용할 설정을 제공합니다.
        RtcEngineContext(
          // 미리 저장해둔 APP ID를 입력합니다.
          appId: appId,
          // 라이브 동영상 송출에 최적화합니다.
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      // 아고라 엔진에서 받을 수 있는 이벤트 값들 등록하기
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            // 채널 접속에 성공했을 때 실행
            print('채널에 입장했습니다. uid: ${connection.localUid}');
            setState(() {
              this.uid = connection.localUid;
            });
          },
          // 채널을 퇴장했을 때 실행
          onLeaveChannel: (connection, stats) {
            print('채널 퇴장');
            setState(() {
              uid = null;
            });
          },
          // 다른 사용자(User)가 접속했을 때(Joined) 실행
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print('상대가 채널에 입장했습니다. uid : $remoteUid');
            setState(() {
              otherUid = remoteUid;
            });
          },
          // 다른 사용자(User)가 채널을 나갔을 때(Offline) 실행
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            print('상대가 채널에서 나갔습니다. uid : $uid');
            setState(() {
              otherUid = null;
            });
          },
        ),
      );

      // 엔진으로 영상을 송출하겠다고 설정합니다.
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo(); // 동영상 기능을 활성화합니다.
      await engine!.startPreview(); // 카메라를 이용해 동영상을 화면에 실행합니다.
      // 채널에 들어가기
      await engine!.joinChannel(
        // 채널 입장하기
        token: tempToken,
        channelId: channelName,
        // 영상과 관련된 여러 가지 설정을 할 수 있다.
        // 현재 프로젝트에는 불필요하다.
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE'),
      ),
      // FutureBuilder - 비동기인 Future 값을 기반으로 위젯 렌더링
      body: FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // Future 실행 후 에러가 있을 때
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          // Future 실행 후 아직 데이터가 없을 때(CircularProgressIndicator 로딩 중)
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                // 나머지 상황에 권한 있음을 표시
                child: Stack(
                  children: [
                    renderMainView(), // 상대방이 찍는 화면
                    // 내가 찍는 화면
                    Align(
                      alignment: Alignment.topLeft, // 왼쪽 위에 위치
                      child: Container(
                        color: Colors.grey,
                        height: 160,
                        width: 120,
                        child: renderSubView(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (engine != null) {
                      await engine!.leaveChannel();
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text('채널 나가기'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 내 핸드폰이 찍는 화면
  Widget renderSubView() {
    if (uid != null) {
      // AgoraVideoView 위젯을 사용하면
      // 동영상을 화면에 보여주는 위젯을 구현할 수 있다.
      return AgoraVideoView(
        // VideoViewController를 매개변수로 입력해주면
        // 해당 컨트롤러가 제공하는 동영상 정보를
        // AgoraVideoView 위젯을 통해 보여줄 수 있다.
        controller: VideoViewController(
          rtcEngine: engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      // 아직 내가 채널에 접속하지 않았다면
      // 로딩 화면을 보여준다.
      return CircularProgressIndicator();
    }
  }

  // 상대 핸드폰이 찍는 화면 렌더링
  Widget renderMainView() {
    // 상대가 채널에 들어왔을 때
    if (otherUid != null) {
      return AgoraVideoView(
        // VideoViewController.remote 생성자를 이용하면
        // 상대방의 동영상을 AgoraVideoView 그려낼 수 있다.
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(
            channelId: CHANNEL_NAME,
          ),
        ),
      );
    }
    // 상대가 아직 채널에 들어오지 않았다면
    else {
      // 대기 메시지를 보여줍니다.
      return Center(
        child: const Text(
          '다른 사용자가 입장할 때까지 대기해주세요.',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

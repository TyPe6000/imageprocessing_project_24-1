# imageprocessing_project_24-1

상명대학교 서울캠퍼스 지능IoT융합전공 전공수업 '지능형영상처리' 기말 프로젝트 5조

주제 : 감정 인식 결과에 따른 이미지 필터 적용하기

외부 API 인 AWS Rekognition을 활용.
이용자로부터 image file을 입력받는다.
Python 코드로 구성된 Rekognition 코드를 통해, AWS 서버에서 Detect_Faces 기능을 활용하여 감정을 인식한다.
인식된 감정은 8가지 대표 감정에 대한 각각의 Confidence 점수가 부여되는 형태이며, 이 정보는 json 파일로 저장된다.

MATLAB 환경에서 작성된 image_filtering 코드는 json 파일을 읽어 가장 높은 Confidence 점수의 감정을 대표 감정으로 선정하고,
함수로 저장된 감정별filter를 적용한다.
필터링된 이미지를 저장한다.
원본 이미지와 필터링된 이미지, 대표 감정과 Confidence 점수를 각각 figure를 통해 출력한다.

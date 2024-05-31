# imageprocessing_project_24-1

상명대학교 서울캠퍼스 지능IoT융합전공 2024학년도 1학기 '지능형영상처리' 강의 기말 프로젝트 5조

윤성민, 이동원, 최성우

### 주제 : 감정 인식 결과에 따른 이미지 필터 적용하기

외부 API 인 AWS Rekognition을 활용.
이용자로부터 image file을 입력받는다.
Python 코드로 구성된 Rekognition 코드를 통해, AWS 서버에서 Detect_Faces 기능을 활용하여 감정을 인식한다.
인식된 감정은 8가지 대표 감정에 대한 각각의 Confidence 점수가 부여되는 형태이며, 이 정보는 json 파일로 저장된다.

MATLAB 환경에서 작성된 image_filtering 코드는 json 파일을 읽어 가장 높은 Confidence 점수의 감정을 대표 감정으로 선정하고,
함수로 저장된 감정별filter를 적용한다.
원본 이미지와 필터링된 이미지, 대표 감정과 Confidence 점수를 각각 figure를 통해 출력한다.
필터링된 이미지, figure에 출력된 이미지를 저장한다.

## 환경 설정

아래는 Win11과 Win10환경, 설치판 MATLAB R2024a 버전, Python 3.11.9 버전 기준으로 작성되었습니다.

해당 프로젝트는 MATLAB 애드온 Computer Vision Toolbox, Image Processing Toolbox를 필요로 합니다. 미설치 시, 애드온 설치 이후 진행하십시오.

MATLAB R2024a 버전 기준으로 MATLAB 환경 내에서 Python 3.9, 3.10, 3.11의 실행을 지원합니다.
관련 상세는 아래 링크 참고.
https://kr.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility

자신의 Python 버전이 호환 상태에 맞는지 확인하고, 설치 경로를 확인합니다.

아래 코드의 python.exe 위치를 자신의 환경에 맞게 설정하여 MATLAB에서 실행합니다. 명령 창에 한줄씩 입력하거나, .m 파일로 작성하여 실행해도 됩니다.
pyenv를 활용하여 MATLAB에 Python의 경로를 설정합니다.

% MATLAB에서 Python 환경 설정

pe = pyenv('Version', 'C:\path\to\python\python.exe');

% 설정 확인

disp(pe)

현재 작성된 코드는 boto3 라이브러리를 필요로 합니다. python.exe 위치를 맞게 수정하여 *명령 프롬포트에서 아래 코드를 실행합니다.
C:\path\to\your\python.exe -m pip install boto3


ACCESS_KEY 와 SECRET_ACCESS_KEY가 지급된 값이 맞는지 확인합니다.

image_filtering.m의 이미지 불러오기 경로인 image_path 값을 sample 폴더에 저장된 대상 이미지의 경로로 수정하고 MATLAB에서 image_filtering.m을 실행합니다.

## 코드 진행 과정
MATLAB 환경에서 MATLAB 코드 image_filtering.m 실행
sample 폴더에 저장된 파일명(image_path)의 이미지 가져오고 
Python 코드 detect_faces.py 호출
감정 인식 후 결과값 json 파일로 저장
가장 큰 Confidence 값을 maxEmotion으로 설정.
maxEmotion에 대응하는 준비된 filter 함수 적용.
원본 이미지, filter 적용 이미지, maxEmotion 항목과 Confidence점수 figure에 출력.
filter 적용 이미지와 figure 화면 저장.

